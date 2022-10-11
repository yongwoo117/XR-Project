using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        public override void Enter()
        {
            var DeadEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterDead");
            var transform = gameObject.transform;
            DeadEffect.transform.position = transform.position;
            DeadEffect.transform.localScale = transform.localScale;

            gameObject.SetActive(false);
        }
    }
}