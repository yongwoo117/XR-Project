using FMODUnity;
using UnityEngine;
using Player.Animation;

namespace Player.State
{
    public class IdleState : PlayerState
    {
        private EventReference hitSfx;

        public override PlayerProfile Profile
        {
            set => hitSfx = value.SFXDictionary[SFXType.Hit];
        }

        public override void OnDamaged(float value)
        {
            hitSfx.AttachedOneShot(StateMachine.gameObject);
            StateMachine.Anim.SetTrigger(AnimationParameter.Hit);
        }

        public override void Enter()
        {
            Debug.Log("Idle Enter");
            StateMachine.EffectState = FeedbackState.Idle;
            StateMachine.Anim.SetTrigger(AnimationParameter.Idle);
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
                case InteractionType.RhythmMiss:
                    StateMachine.ChangeState(e_PlayerState.Miss);
                    break;
            }
        }
    }
}