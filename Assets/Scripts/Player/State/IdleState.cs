using UnityEngine;

namespace Player.State
{
    public class IdleState : PlayerState
    {
        public override void Enter()
        {
            Debug.Log("Idle Enter");
        }

        public override void HandleInput(InteractionType interactionType, object arg)
        {
            switch (interactionType)
            {
                case InteractionType.Primary:
                    StateMachine.ChangeState(e_PlayerState.Dash);
                    break;
                case InteractionType.Third:
                    StateMachine.ChangeState(e_PlayerState.Cut);
                    break;
            }
        }
    }
}