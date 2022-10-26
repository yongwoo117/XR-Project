using Enemy.Animation;
using Enemy.Profile;
using UnityEngine;

namespace Enemy.State
{
    public class ChaseState : EnemyState
    {
        //Profile 변수
        private float chaseRange;
        private float chaseSpeed;
        private float attackRange;
        private float damage;

        //상태 변수
        private HealthModule player;

        //Machine 변수
        private Rigidbody rigid;

        private readonly Collider[] collisionBuffer = new Collider[1];

        public override EnemyProfile Profile
        {
            set
            {
                chaseSpeed = value.f_ChaseSpeed;
                chaseRange = value.f_ChaseRange;
                attackRange = value.f_AttackRange;
                damage = value.f_damage;
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

            StateMachine.Anim.SetTrigger(AnimationParameter.Move);
        }

        public override void Exit()
        {
            rigid.velocity = Vector3.zero;
        }

        public override void PhysicsUpdate()
        {
            ApplyPhysics();
        }

        public override void LogicUpdate()
        {
            var dir = player.transform.position - StateMachine.transform.position;
            var distance = dir.magnitude;

            if (distance > chaseRange)
            {
                StateMachine.ChangeState(e_EnemyState.Idle);
            }
            else if (distance <= attackRange)
            {
                //TODO: 공격 애니메이션 타이밍에 맞춰서 데미지를 주는 로직을 추가해야 합니다.
                player.RequestDamage(damage);
                StateMachine.ChangeState(e_EnemyState.Attack);
            }
            else
            {
                FlipToDirection(dir);
            }
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

        private void FlipToDirection(Vector3 direction)
        {
            Vector3 GFXScale = StateMachine.Anim.transform.localScale;
            GFXScale.x = Mathf.Abs(GFXScale.x) * (direction.x > 0 ? -1 : 1);
            StateMachine.Anim.transform.localScale = GFXScale;
        }
    }
}