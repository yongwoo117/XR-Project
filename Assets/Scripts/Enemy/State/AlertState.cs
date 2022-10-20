using Enemy.Profile;
using UnityEngine;

namespace Enemy.State
{
    public class AlertState : EnemyState
    {
        private float checkRange;
        private float chaseRange;

        private readonly Collider[] collisionBuffer = new Collider[1];

        private GameObject player;
        
        public override EnemyProfile Profile
        {
            set
            {
                checkRange = value.f_CheckRange;
                chaseRange = value.f_ChaseRange;
            }
        }

        public override void Enter()
        {
            if (Physics.OverlapSphereNonAlloc(StateMachine.transform.position, checkRange, collisionBuffer, GetLayerMasks.Player) <= 0)
            {
                StateMachine.ChangeState(e_EnemyState.Idle);
                return;
            }

            player = collisionBuffer[0].gameObject;
        }

        public override void OnDrawGizmos()
        {
            var point = StateMachine.transform.position;
            Gizmos.DrawWireSphere(point, checkRange);
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(point, chaseRange);
        }

        public override void LogicUpdate()
        {
            var distance = (player.transform.position - StateMachine.transform.position).magnitude;
            if (distance < chaseRange)
                StateMachine.ChangeState(e_EnemyState.Chase);
            else if (distance > checkRange)
                StateMachine.ChangeState(e_EnemyState.Idle);
        }
        
        public override void OnDamaged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }
    }
}