using FMODUnity;
using Player.Animation;
using UnityEngine;

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

            var hitEffect = EffectProfileData.Instance.PopEffect("Eff_CharacterHit");
            if (hitEffect is not null)
                hitEffect.transform.parent = StateMachine.transform.GetChild(0);

            hitEffect.transform.localPosition = Vector3.zero;
            hitEffect.transform.localScale = Vector3.one;
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