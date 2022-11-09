using FMODUnity;
using Player.Animation;

namespace Player.State
{
    public class HitState : PlayerState
    {
        private EventReference hitSfx;

        public override PlayerProfile Profile
        {
            set => hitSfx = value.SFXDictionary[SFXType.Hit];
        }

        public override void Enter()
        {
            hitSfx.PlayOneShot();
            StateMachine.EffectState = FeedbackState.Idle;
            StateMachine.Anim.SetTrigger(AnimationParameter.Hit);
            StateMachine.RhythmCombo = 0;
            StateMachine.CombatComboBreak();
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
            }
        }
    }
}