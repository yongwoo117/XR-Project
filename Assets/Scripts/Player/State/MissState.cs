using Player.Animation;
using UnityEngine;

namespace Player.State
{
    public class MissState : PlayerState
    {
        public override void Enter()
        {
            Debug.Log("Miss Enter");
            StateMachine.EffectState = FeedbackState.Miss;
            StateMachine.Anim.SetTrigger(AnimationParameter.Miss);
        }

        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.RhythmLate:
                    StateMachine.ChangeState(e_PlayerState.Idle);
                    break;
                default:
                    StateMachine.ChangeState(e_PlayerState.Miss);
                    break;
            }
        }


    }
}