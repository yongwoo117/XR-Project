using System.Collections.Generic;
using UnityEngine;

namespace Player.State
{
    public class DashState : PlayerState
    {
        private float physicsCurveArea;
        private float dashingTime;
        private float dashTime;
        private float dashDistance;
        private float damage;
        private float multiplier;

        private AnimationCurve dashGraph;
        private Rigidbody rigid;
        private IControl control;

        private Vector3 pointDir;
        private Vector3 dashAttackRange;

        private bool isActivated;
        private GameObject dashEffect;
        
        private readonly Collider[] collisionBuffer = new Collider[1];
        private readonly List<GameObject> damagedObjects = new();

        #region StateFunction
        public override void Initialize()
        {
            rigid = StateMachine.GetComponent<Rigidbody>();
            control = StateMachine.GetComponent<IControl>();
            SetupIntegralPhysicsGraph(); //물리 그래프 적분 함수
        }
        
        public override PlayerProfile Profile
        {
            set
            {
                dashGraph = value.dashPhysicsGraph;
                dashTime = value.f_dashTime;
                dashDistance = value.f_dashDistance;
                dashAttackRange = value.v3_dashRange;
                damage = value.f_standardDamage;
                multiplier = value.f_dashMultiplier;
            }
        }

        public override bool AcceptHealthChange(ref float value) => !isActivated;

        public override void Enter()
        {
            Debug.Log("Dash Enter");
        
            dashingTime = dashTime;
            isActivated = false;
            StateMachine.RhythmCombo++;
            StateMachine.AddCombatCombo(e_PlayerState.Dash);
            damagedObjects.Clear();
            Activate();
        }

        public override void PhysicsUpdate()
        {
            if (isActivated)
                ApplyDashPhysics();
        }

        public override void LogicUpdate()
        {
            if(isActivated)
                CheckEnemyHit();
        }

        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.Cut when dashingTime < 0: // dashingTime이 음수라면, 대쉬가 끝난 뒤 입력대기상태를 의미합니다.
                    StateMachine.ChangeState(e_PlayerState.Cut);
                    break; 
                case InteractionType.Ready when dashingTime < 0:
                    StateMachine.ChangeState(e_PlayerState.Ready);
                    break;
                default:
                    StateMachine.ChangeState(e_PlayerState.Idle);
                    break;
            }
        }

        public override void Exit()
        {
            Debug.Log("Dash Exit");
            Deactivate();
        }

        public override void OnDrawGizmos()
        {
            if (control.Direction == null) return;
            var direction = (Vector3)control.Direction;

            var attackRange = new Vector3(direction.magnitude, dashAttackRange.y, dashAttackRange.z);

            Gizmos.color = Color.red;
            Gizmos.matrix = Matrix4x4.TRS(rigid.transform.position,
                Quaternion.Euler(0f, Mathf.Atan2(direction.z, direction.x) * -Mathf.Rad2Deg, 0f),
                rigid.transform.localScale);
            Gizmos.DrawWireCube(Vector3.right * (direction.magnitude * 0.5f), attackRange);
        }
        #endregion
        
        private void CheckEnemyHit()
        {
            //오버렙 박스 이용해서 플레이어 위치에서 대쉬 공격 범위 만큼 판정 검사
            var size = Physics.OverlapBoxNonAlloc(
                StateMachine.transform.position + pointDir.normalized *
                new Vector3(dashAttackRange.x, 0f, dashAttackRange.z).magnitude, dashAttackRange, collisionBuffer,
                Quaternion.Euler(0f, Mathf.Atan2(pointDir.z, pointDir.x) * -Mathf.Rad2Deg, 0f), GetLayerMasks.Enemy);

            if (size == 0) return;
            foreach (var collider in collisionBuffer)
            {
                var enemy = collider.gameObject;
                if(damagedObjects.Contains(enemy)) continue;
                enemy.GetComponent<HealthModule>()?.RequestDamage(damage * multiplier);
                damagedObjects.Add(enemy);
            }
        }

        /// <summary>
        /// 대쉬를 실행합니다.
        /// </summary>
        private void Activate()
        {
            if (control.Direction == null) return;
            var dashPoint = (Vector3)control.Direction;

            // 대쉬 이동 거리에 제약을 걸어줍니다.
            pointDir = dashPoint.magnitude > dashDistance ? dashPoint.normalized * dashDistance : dashPoint;

            isActivated = true;

            DashEffect();
        }

        private void DashEffect()
        {
            dashEffect = EffectProfileData.Instance.PopEffect("Eff_Trail");
            dashEffect.SetActive(false);


            dashEffect.transform.parent = StateMachine.transform.GetChild(0);
            dashEffect.transform.position = StateMachine.transform.GetChild(0).position;


            //float direction= Mathf.Atan2(pointDir.z, pointDir.x) * Mathf.Rad2Deg;

            //DashEffect.transform.localEulerAngles = new Vector3(0f, 0f, -direction); 
            dashEffect.SetActive(true);
        }

        /// <summary>
        /// 대쉬를 멈춥니다.
        /// </summary>
        private void Deactivate()
        {
            dashingTime = -1;
            rigid.velocity = Vector3.zero; //대쉬 시간이 끝났으면 플레이어를 멈춰줌
            isActivated = false;

            dashEffect.GetComponent<ParticleSystem>().Pause();
        }

        /// <summary>
        /// 초기에 애니메이션 그래프를 fixedDeltaTime 주기에 맞게 적분하여 그래프 전체 영역을 구함
        /// </summary>
        private void SetupIntegralPhysicsGraph()
        {
            physicsCurveArea = 0f;
            for (float i = 0; i < dashTime; i += Time.fixedDeltaTime)
                physicsCurveArea += dashGraph.Evaluate(i);
        }
        
        /// <summary>
        /// 그래프를 통해서 목표 지점 까지 물리 적용
        /// 목표지점 까지의 속력: pointDir / dashTime 
        /// 물리 이동 시 전체 영역: (dashTime / Time.fixedDeltaTime)
        /// 사용할 그래프의 전체 영역: physicsCurveArea
        /// 현제 시간에서의 그래프 값: dashGraph.Evaluate(dashTime - dashingTime)
        /// 요약: 목표지점 까지의 속력값이 1이고 사용할 그래프 값이 1로 고정됐을때, 전체 이동 거리는 대쉬시간에 프레임 수와 같다.
        /// 그렇기 때문에 사용할 그래프의 영역을 대쉬시간 프레임으로 나눠주면 그래프 값에 1에 대한 변경된 속도 계산이 가능해진다.
        /// </summary>
        private void ApplyDashPhysics()
        {
            if (dashingTime <= 0f)
                Deactivate();
            else
                rigid.velocity = pointDir / dashTime * ((dashTime / Time.fixedDeltaTime) / physicsCurveArea) *
                                 dashGraph.Evaluate(dashTime - dashingTime); //대쉬 시간이 끝이 아니면 그래프에 값 만큼 물리 적용


            dashingTime -= Time.fixedDeltaTime; 
        }
    }
}


