using FMODUnity;
using UnityEngine;
using Player.Animation;

namespace Player.State
{
    public class DieState : PlayerState
    {
        private EventReference dieSfx;

        public override PlayerProfile Profile
        {
            set => dieSfx = value.SFXDictionary[SFXType.Dead];
        }

        public override void Enter()
        {
            dieSfx.PlayOneShot();
            StateMachine.GetComponent<Collider>().enabled = false;
            StateMachine.Anim.SetTrigger(AnimationParameter.Dead);
            StateMachine.EffectState = FeedbackState.Off;
        }
    }
}