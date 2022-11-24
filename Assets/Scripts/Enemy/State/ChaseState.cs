using Enemy.Animation;
using Enemy.Profile;
using FMOD.Studio;
using UnityEngine;
using STOP_MODE = FMOD.Studio.STOP_MODE;

namespace Enemy.State
{
    public class ChaseState : EnemyState
    {
        //Profile 변수
        private float chaseRange;
        private float chaseSpeed;
        private float attackRange;

        //상태 변수
        private HealthModule player;

        //Machine 변수
        private Rigidbody rigid;

        private AnimationCurve chaseGraph;
        private float chaseGraphCurveArea;
        private float chaseTime;
        private float chasingTime;
        
        private EventInstance moveInstance;

        private readonly Collider[] collisionBuffer = new Collider[1];

        public override EnemyProfile Profile
        {
            set
            {
                chaseSpeed = value.f_ChaseSpeed;
                chaseRange = value.f_ChaseRange;
                chaseTime = value.f_ChaseTime;
                chaseGraph = value.chasePhysicsGraph;
                attackRange = value.f_AttackRange;
                moveInstance = value.SFXDictionary[SFXType.Move].CreateAttach(StateMachine.transform);
            }
        }

        public override void Initialize()
        {
            rigid = StateMachine.GetComponent<Rigidbody>();
        }

        public override void Enter()
        {
            //추격 범위 안에 들어왔을 경우 추격, 범위 밖일 경우 대기 상태로 변경
            if (Physics.OverlapSphereNonAlloc(StateMachine.transform.position, chaseRange, collisionBuffer, GetLayerMasks.Player) <= 0)
            {
                StateMachine.ChangeState(e_EnemyState.Idle);
                return;
            }

            player = collisionBuffer[0].GetComponent<HealthModule>();

            SetupIntegralPhysicsGraph();
            
            moveInstance.start();
            StateMachine.Anim.SetTrigger(AnimationParameter.Move);
        }

        public override void Exit()
        {
            rigid.velocity = Vector3.zero;
            moveInstance.stop(STOP_MODE.IMMEDIATE);
        }

        public override void PhysicsUpdate()
        {
            ApplyPhysics();
        }

        public override void LogicUpdate()
        {
            var dir = player.transform.position - StateMachine.transform.position;
            var distance = dir.magnitude;
            FlipToDirection(dir);
            if (distance > chaseRange) StateMachine.ChangeState(e_EnemyState.Idle);
            else if (distance <= attackRange) StateMachine.ChangeState(e_EnemyState.Attack);
        }

        public override void OnRhythm()
        {
            chasingTime = chaseTime;
        }

        public override void OnDrawGizmos()
        {
            var point = StateMachine.transform.position;
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(point, chaseRange);
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(point, attackRange);
        }

        private void ApplyPhysics()
        {
            var dir = (player.transform.position - StateMachine.transform.position).normalized;
            dir *= chaseSpeed;

            if (chasingTime > 0f)
            {
                dir = dir / chaseTime * ((chaseTime / Time.fixedDeltaTime) / chaseGraphCurveArea) *
                                     chaseGraph.Evaluate((chaseTime - chasingTime) / chaseTime); //대쉬 시간이 끝이 아니면 그래프에 값 만큼 물리 적용

                chasingTime -= Time.fixedDeltaTime;
            }



            rigid.velocity = new Vector3(dir.x,0f,dir.z);
        }

        public override void OnDamaged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }

        public override void Release()
        {
            moveInstance.stop(STOP_MODE.IMMEDIATE);
            moveInstance.release();
        }

        public override void OnPause(bool isPaused) => moveInstance.setPaused(isPaused);

        private void FlipToDirection(Vector3 direction)
        {
            Vector3 GFXScale = StateMachine.Anim.transform.localScale;
            GFXScale.x = Mathf.Abs(GFXScale.x) * (direction.x > 0 ? -1 : 1);
            StateMachine.Anim.transform.localScale = GFXScale;
        }

        /// <summary>
        /// 초기에 애니메이션 그래프를 fixedDeltaTime 주기에 맞게 적분하여 그래프 전체 영역을 구함
        /// </summary>
        private void SetupIntegralPhysicsGraph()
        {
            chaseGraphCurveArea = 0f;
            float reciprocal = 1f / chaseTime; //역수

            for (float i = 0; i < chaseTime; i += Time.fixedDeltaTime)
                chaseGraphCurveArea += chaseGraph.Evaluate(i * reciprocal);
        }
    }
}