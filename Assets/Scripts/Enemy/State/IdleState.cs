using Enemy.Profile;
using UnityEngine;

namespace Enemy.State
{
    public class IdleState : EnemyState
    {
        private float checkRange;
        private Transform transform;

        public override EnemyProfile Profile
        {
            set => checkRange = value.f_CheckRange;
        }

        public override void Initialize()
        {
            transform = StateMachine.transform;
        }
        
        public override void LogicUpdate()
        {
            //탐색 범위 안에 들어왔을 경우 추격 상태로 변경
            Collider[] chaseHit = Physics.OverlapSphere(transform.position, checkRange, GetLayerMasks.Player);

            if (chaseHit.Length > 0)
            {
                StateMachine.ChangeState(e_EnemyState.Chase);
            }
        }

        public override void OnDrawGizmos()
        {
            Gizmos.DrawWireSphere(transform.position, checkRange);
        }

        
        public override void HealthChanged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }
    }
}