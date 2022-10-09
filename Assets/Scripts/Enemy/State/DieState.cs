using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        public override void Enter()
        {
            GameObject DeadEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterDead");
            DeadEffect.transform.localScale = StateMachine.transform.localScale;

            StateMachine.gameObject.SetActive(false);
        }
    }
}