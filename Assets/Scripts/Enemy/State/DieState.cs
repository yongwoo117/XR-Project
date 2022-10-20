using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        public Action<GameObject> DieAction;
        public override void Enter()
        {
            var deadEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterDead");
            if (deadEffect is not null)
            {
                var transform= StateMachine.transform;
                deadEffect.transform.position = transform.GetChild(0).position;
                deadEffect.transform.localScale = transform.localScale;
            }

            StateMachine.gameObject.SetActive(false);
        }
    }
}