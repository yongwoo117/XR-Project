using UnityEngine;

namespace Player.State
{
    public class IdleState : PlayerState
    {
        private RhythmCombo combo;

        public override void Initialize()
        {
            combo = StateMachine.GetComponent<RhythmCombo>();
        }

        public override void Enter()
        {
            Debug.Log("Idle Enter");
            combo.Combo = 0;
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
                default:
                    combo.Combo = 0;
                    break;
            }
        }
    }
}