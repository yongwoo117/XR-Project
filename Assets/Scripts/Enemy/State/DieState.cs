using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        public override void Enter()
        {
            var deadEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterDead");
            if (deadEffect is not null)
            {
                var transform= StateMachine.transform;
                deadEffect.transform.position = transform.GetChild(0).position;
                deadEffect.transform.localScale = transform.localScale;
            }

            StateMachine.GetComponent<SpawnCallback>()?.Return();
        }
    }
}