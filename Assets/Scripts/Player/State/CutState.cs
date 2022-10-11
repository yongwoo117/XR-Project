
using UnityEngine;

namespace Player.State
{
    public class CutState : PlayerState
    {
        private float cutTime;
        private float thresholdTime;

        public override PlayerProfile Profile
        {
            set => cutTime = value.f_cutTime;
        }

        public override void Enter()
        {
            Debug.Log("Cut Enter");
            thresholdTime = Time.realtimeSinceStartup + cutTime;
        }

        public override void Exit()
        {
            Debug.Log("Cut Exit");
        }

        public override void PhysicsUpdate()
        {
            if (thresholdTime < Time.realtimeSinceStartup)
            {
                StateMachine.ChangeState(e_PlayerState.Idle);
            }
        }
    }
}