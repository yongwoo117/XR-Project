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

        private void SetupProfile()
        {
            var profile = StateMachine.Profile;

            checkRange = profile.f_CheckRange;
        }

        public override void LogicUpdate()
        {
            
        }

        public override void OnDrawGizmos()
        {
            Gizmos.DrawWireSphere(StateMachine.transform.position, checkRange);
        }
    }
}