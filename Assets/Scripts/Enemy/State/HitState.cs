using System;
using UnityEngine;

namespace Enemy.State
{
    public class HitState : EnemyState
    {
        public override void Enter()
        {
            var HitEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterHit");
            HitEffect.transform.position = gameObject.transform.GetChild(0).position;
        }

        public override void Dead()
        {
            StateMachine.ChangeState(e_EnemyState.Die);
        }
    }
}