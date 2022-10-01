
using UnityEngine;

namespace Player.State
{
    public class CutState : PlayerState
    {
        private float cutTime;
        private float thresholdTime;
        
        public override void Enter()
        {
            Debug.Log("Cut Enter");
            cutTime = PlayerVariables.Instance.Profile.f_cutTime;
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