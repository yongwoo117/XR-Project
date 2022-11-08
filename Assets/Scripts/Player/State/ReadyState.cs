using FMODUnity;
using Player.Animation;

namespace Player.State
{
    public class ReadyState : PlayerState
    {
        private EventReference readySfx;

        public override PlayerProfile Profile
        {
            set => readySfx = value.SFXDictionary[SFXType.Charging];
        }

        public override void Enter()
        {
            StateMachine.RhythmCombo++;
            StateMachine.AddCombatCombo(e_PlayerState.Ready);
            StateMachine.EffectState = FeedbackState.Direction;
            var chargedEffect = EffectProfileData.Instance.PopEffect("Eff_CharacterCharge");
            if (chargedEffect is not null) 
                chargedEffect.transform.position = StateMachine.transform.GetChild(0).position;
            StateMachine.Anim.SetTrigger(AnimationParameter.Charge);
            readySfx.AttachedOneShot(StateMachine.gameObject);
        }

        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.Cut:
                    StateMachine.ChangeState(e_PlayerState.Cut);
                    break;
                case InteractionType.Dash:
                    StateMachine.ChangeState(e_PlayerState.Dash);
                    break;
                default:
                    StateMachine.ChangeState(e_PlayerState.Miss);
                    break;
            }
        }

    }
}
