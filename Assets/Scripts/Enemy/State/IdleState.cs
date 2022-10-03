using System;
using UnityEngine;

namespace Enemy.State
{
    public class IdleState : EnemyState
    {
        float checkRange;
        public override void Initialize()
        {
            SetupProfile();
        }

        public override void Enter()
        {
            
        }

        public override void LogicUpdate()
        {
            //탐색 범위 안에 들어왔을 경우 추격 상태로 변경
            Collider[] chaseHit = Physics.OverlapSphere(StateMachine.transform.position, checkRange, GetLayerMasks.Player);

            if (chaseHit.Length > 0)
            {
                StateMachine.ChangeState(e_EnemyState.Chase);
            }
        }

        public override void OnDrawGizmos()
        {
            Gizmos.DrawWireSphere(StateMachine.transform.position, checkRange);
        }


        private void SetupProfile()
        {
            var profile = StateMachine.Profile;

            checkRange = profile.f_CheckRange;
        }
    }
}