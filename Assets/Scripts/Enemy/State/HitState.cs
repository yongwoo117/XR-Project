using System;
using UnityEngine;

namespace Enemy.State
{
    public class HitState : EnemyState
    {
        public override void Enter()
        {
            GameObject HitEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterHit");
            HitEffect.transform.position = StateMachine.transform.GetChild(0).position;
            if (StateMachine.HealthPoint < 0)
                StateMachine.ChangeState(e_EnemyState.Die);
        }
    }
}