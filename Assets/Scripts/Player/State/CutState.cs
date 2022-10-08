
using UnityEngine;

namespace Player.State
{
    public class CutState : PlayerState
    {
        private float cutTime;
        private int cutCount;
        private int remainCutCount;
        private RhythmCombo combo;

        public override void Initialize()
        {
            cutTime = StateMachine.Profile.f_cutTime;
            cutCount = StateMachine.Profile.i_cutCount;
            combo = StateMachine.GetComponent<RhythmCombo>();
        }

        public override void Enter()
        {
            Debug.Log("Cut Enter");
            remainCutCount = cutCount - 1;
            combo.Combo++;
        }

        public override void Exit()
        {
            Debug.Log("Cut Exit");
        }
        
        public override void HandleInput(InteractionType interactionType, object arg)
        {
            switch (interactionType)
            {
                case InteractionType.CutEnter when remainCutCount != 0:
                    combo.Combo++;
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