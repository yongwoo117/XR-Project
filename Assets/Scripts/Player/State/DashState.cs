using UnityEngine;

namespace Player.State
{
    public class DashState : PlayerState
    {
        private float physicsCurveArea;
        private float dashingTime;
        private float dashTime;
        private float dashDistance;

        private AnimationCurve dashGraph;
        private Rigidbody rigid;
        private IControl control;

        private Vector3 pointDir;
        private Vector3 dashAttackRange;

        private bool isActivated;

        #region StateFunction
        public override void Initialize()
        {
            rigid = StateMachine.GetComponent<Rigidbody>();
            control = StateMachine.GetComponent<IControl>();
            SetupProfile();
            SetupIntegralPhysicsGraph(); //물리 그래프 적분 함수
        }

        public override void Enter()
        {
            Debug.Log("Dash Enter");
        
            isActivated = false;
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

        private void CheckEnemyHit()
        {
            //오버렙 박스 이용해서 플레이어 위치에서 대쉬 공격 범위 만큼 판정 검사
            Collider[] enemyHits = Physics.OverlapBox(StateMachine.transform.position+pointDir.normalized*new Vector3(dashAttackRange.x,0f,dashAttackRange.z).magnitude, dashAttackRange, Quaternion.Euler(0f, Mathf.Atan2(pointDir.z, pointDir.x) * -Mathf.Rad2Deg, 0f), GetLayerMasks.Enemy);
         

            if (enemyHits.Length > 0)
            {
                enemyHits[0].GetComponent<IHealth>().HealthPoint -= 1.2f;
                StateMachine.ChangeState(e_PlayerState.Idle);
            }
        }

        public override void HandleInput(InteractionType interactionType, object arg)
        {
            switch (interactionType)
            {
                case InteractionType.DashExit:
                    Reset(); //초기 변수 초기화
                    break;
            }
        }

        public override void Exit()
        {
            Debug.Log("Dash Exit");

            rigid.velocity = Vector3.zero; //대쉬 시간이 끝났으면 플레이어를 멈춰줌
            base.Exit();
        }

        public override void OnDrawGizmos()
        {
            if (control.Direction == null) return;
            var direction = (Vector3)control.Direction;
            
            var attackRange = new Vector3(direction.magnitude,
                StateMachine.Profile.v3_dashRange.y, StateMachine.Profile.v3_dashRange.z);

            Gizmos.matrix = Matrix4x4.TRS(rigid.transform.position,
                Quaternion.Euler(0f, Mathf.Atan2(direction.z, direction.x) * -Mathf.Rad2Deg, 0f),
                rigid.transform.localScale);
            Gizmos.DrawWireCube(Vector3.right * (direction.magnitude * 0.5f), attackRange);
        }
        #endregion


        /// <summary>
        /// 초기 변수들 초기화
        /// </summary>
        private void Reset()
        {
            if (control.Direction == null) return;
            var dashPoint = (Vector3)control.Direction;
            
            // 대쉬 이동 거리에 제약을 걸어줍니다.
            pointDir = dashPoint.magnitude > dashDistance ? dashPoint.normalized * dashDistance : dashPoint;
            dashingTime = dashTime;
            isActivated = true;

        }

        /// <summary>
        /// 초기에 애니메이션 그래프를 fixedDeltaTime 주기에 맞게 적분하여 그래프 전체 영역을 구함
        /// </summary>
        private void SetupIntegralPhysicsGraph()
        {
            physicsCurveArea = 0f;
            for (float i = 0; i < dashTime; i += Time.fixedDeltaTime)
            {
                physicsCurveArea += dashGraph.Evaluate(i);
            }
        }

        /// <summary>
        /// PlayerProfile 정보를 받아와서 변수들을 초기화합니다.
        /// </summary>
        private void SetupProfile()
        {
            var profile = StateMachine.Profile;
            dashGraph = profile.dashPhysicsGraph;
            dashTime = profile.f_dashTime;
            dashDistance = profile.f_dashDistance;
            dashAttackRange = profile.v3_dashRange;
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
            {
                StateMachine.ChangeState(e_PlayerState.Idle); //대쉬 시간이 끝이면 Idle로 상태 변환
            }
            else
                rigid.velocity = pointDir / dashTime * ((dashTime / Time.fixedDeltaTime) / physicsCurveArea) * dashGraph.Evaluate(dashTime - dashingTime); //대쉬 시간이 끝이 아니면 그래프에 값 만큼 물리 적용

            dashingTime -= Time.deltaTime; 
        }
    }
}


