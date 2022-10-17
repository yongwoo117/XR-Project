using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        public override void Enter()
        {
            GameObject DeadEffect = EffectProfileData.Instance.PopObject("Eff_MonsterDead");
            DeadEffect.transform.position = StateMachine.transform.position;
            DeadEffect.transform.localScale = StateMachine.transform.localScale;

            StateMachine.gameObject.SetActive(false);
        }
    }
}