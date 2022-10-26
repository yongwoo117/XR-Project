using Enemy.Profile;
using FMOD.Studio;
using FMODUnity;
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
        private EventReference moveSfx;

        //상태 변수
        private HealthModule player;

        //Machine 변수
        private Rigidbody rigid;

        private EventInstance moveInstance;

        private readonly Collider[] collisionBuffer = new Collider[1];

        public override EnemyProfile Profile
        {
            set
            {
                chaseSpeed = value.f_ChaseSpeed;
                chaseRange = value.f_ChaseRange;
                attackRange = value.f_AttackRange;
                moveSfx = value.SFXDictionary[SFXType.Move];
                moveInstance = RuntimeManager.CreateInstance(moveSfx);
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
            moveInstance.start();
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
            var distance = (player.transform.position - StateMachine.transform.position).magnitude;
            if (distance > chaseRange) StateMachine.ChangeState(e_EnemyState.Idle);
            else if (distance <= attackRange) StateMachine.ChangeState(e_EnemyState.Attack);
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
            
            rigid.velocity = new Vector3(dir.x,0f,dir.z);
        }

        public override void OnDamaged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }

        ~ChaseState() => moveInstance.release();
    }
}