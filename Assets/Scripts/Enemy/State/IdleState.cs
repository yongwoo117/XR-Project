using Enemy.Profile;
using UnityEngine;

namespace Enemy.State
{
    public class IdleState : EnemyState
    {
        private float checkRange;
        private Transform transform;

        private readonly Collider[] collisionBuffer = new Collider[1];

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
            if (Physics.OverlapSphereNonAlloc(transform.position, checkRange, collisionBuffer, GetLayerMasks.Player) > 0)
                StateMachine.ChangeState(e_EnemyState.Alert);
        }

        public override void OnDrawGizmos()
        {
            Gizmos.DrawWireSphere(transform.position, checkRange);
        }

        public override void OnDamaged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }
    }
}