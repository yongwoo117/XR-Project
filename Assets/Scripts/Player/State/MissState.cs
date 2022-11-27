using Player.Animation;
using UnityEngine;

namespace Player.State
{
    public class MissState : PlayerState
    {
        public override void Enter()
        {
            Debug.Log("Miss Enter");
            StateMachine.EffectState = FeedbackState.Idle;
            StateMachine.Anim.SetTrigger(AnimationParameter.Miss);
            StateMachine.RhythmCombo = 0;
        }

        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.Ready:
                    StateMachine.ChangeState(e_PlayerState.Ready);
                    break;
                case InteractionType.Cut:
                    StateMachine.ChangeState(e_PlayerState.Cut);
                    break;
                case InteractionType.RhythmMiss:
                    if (StateMachine.RhythmFlag) Enter();
                    break;
            }
        }
    }
}