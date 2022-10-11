using System;
using UnityEngine;

namespace Enemy.State
{
    public class HitState : EnemyState
    {
        int Hp;
        public override void Initialize()
        {
            SetupProfile();
        }

        public override void Enter()
        {
            GameObject HitEffect=EffectProfileData.Instance.PopEffect("Eff_MonsterHit");
            HitEffect.transform.position = StateMachine.transform.GetChild(0).position;

            StateMachine.ChangeState(e_EnemyState.Die);
            // if(--Hp==0)
            // {
            //     StateMachine.ChangeState(e_EnemyState.Die);
            // }
        }

        private void SetupProfile()
        {
            var profile = StateMachine.Profile;

            Hp = profile.i_Hp;
        }
    }
}