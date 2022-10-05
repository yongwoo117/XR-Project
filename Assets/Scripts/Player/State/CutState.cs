
using UnityEngine;

namespace Player.State
{
    public class CutState : PlayerState
    {
        private float cutTime;
        private float thresholdTime;
        private int cutCount;
        private int remainCutCount;

        public override void Initialize()
        {
            cutTime = StateMachine.Profile.f_cutTime;
            cutCount = StateMachine.Profile.i_cutCount;
            
            //TODO: thresholdTIme을 이용하여 애니메이션 배속같은 것을 지정합니다.
            thresholdTime = Time.realtimeSinceStartup + cutTime;
        }

        public override void Enter()
        {
            Debug.Log("Cut Enter");
            remainCutCount = cutCount - 1;
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
                    IncreaseStreak();
                    remainCutCount--;
                    break;
                case InteractionType.DashEnter:
                    IncreaseStreak();
                    StateMachine.ChangeState(e_PlayerState.Dash);
                    break;
                default:
                    BreakStreak();
                    StateMachine.ChangeState(e_PlayerState.Idle);
                    break;
            }
        }
    }
}