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
            GameObject HitEffect =  ObjectPoolingManager.Instance.Pool<EffectCallBack>("Eff_MonsterHit").Get();
            HitEffect.transform.position = StateMachine.transform.GetChild(0).position;

            if(--Hp==0)
            {
                StateMachine.ChangeState(e_EnemyState.Die);
            }
        }

        private void SetupProfile()
        {
            var profile = StateMachine.Profile;

            Hp = profile.i_Hp;
        }
    }
}