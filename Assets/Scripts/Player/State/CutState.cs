
using UnityEngine;

namespace Player.State
{
    public class CutState : PlayerState
    {
        private int cutCount;
        private int remainCutCount;
        
        public override PlayerProfile Profile
        {
            set => cutCount = value.i_cutCount;
        }

        public override void Enter()
        {
            Debug.Log("Cut Enter");
            remainCutCount = cutCount - 1;
            StateMachine.Combo++;
        }

        public override void Exit()
        {
            Debug.Log("Cut Exit");
        }
        
        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.CutEnter when remainCutCount != 0:
                    StateMachine.Combo++;
                    remainCutCount--;
                    break;
                case InteractionType.DashEnter:
                    StateMachine.ChangeState(e_PlayerState.Dash);
                    break;
                default:
                    StateMachine.ChangeState(e_PlayerState.Idle);
                    break;
            }
        }
    }
}