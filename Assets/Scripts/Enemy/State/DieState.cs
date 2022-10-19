using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        public Action<GameObject> DieAction;
        public override void Enter()
        {
            GameObject DeadEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterDead");
            DeadEffect.transform.position = StateMachine.transform.GetChild(0).position;
            DeadEffect.transform.localScale = StateMachine.transform.localScale;
            DieAction(StateMachine.gameObject);
        }
    }
}