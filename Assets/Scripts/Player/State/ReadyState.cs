using FMODUnity;
using Player.Animation;

namespace Player.State
{
    public class ReadyState : PlayerState
    {
        private EventReference readySfx;
        private EventReference hitSfx;

        public override PlayerProfile Profile
        {
            set
            {
                readySfx = value.SFXDictionary[SFXType.Charging];
                hitSfx = value.SFXDictionary[SFXType.Hit];
            }
        }

        public override void Enter()
        {
            StateMachine.RhythmCombo++;
            StateMachine.EffectState = FeedbackState.Direction;
            var chargedEffect = EffectProfileData.Instance.PopEffect("Eff_CharacterCharge");
            if (chargedEffect is not null) 
                chargedEffect.transform.position = StateMachine.transform.GetChild(0).position;
            StateMachine.Anim.SetTrigger(AnimationParameter.Charge);
            readySfx.AttachedOneShot(StateMachine.gameObject);
        }
        
        public override void OnDamaged(float value)
        {
            hitSfx.AttachedOneShot(StateMachine.gameObject);
        }

        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.Cut:
                    StateMachine.ChangeState(e_PlayerState.Cut);
                    break;
                case InteractionType.Dash:
                    if (!StateMachine.ChangeState(e_PlayerState.Dash))
                        StateMachine.ChangeState(e_PlayerState.Idle);
                    break;
                default:
                    StateMachine.ChangeState(e_PlayerState.Miss);
                    break;
            }
        }

    }
}
