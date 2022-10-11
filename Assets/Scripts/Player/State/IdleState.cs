using UnityEngine;

namespace Player.State
{
    public class IdleState : PlayerState
    {
        public override void Enter()
        {
            Debug.Log("Idle Enter");
        }

        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.DashEnter:
                    StateMachine.ChangeState(e_PlayerState.Dash);
                    break;
                case InteractionType.CutEnter:
                    StateMachine.ChangeState(e_PlayerState.Cut);
                    break;
            }
        }
    }
}