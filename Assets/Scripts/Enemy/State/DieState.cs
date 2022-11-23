using System;
using Enemy.Profile;
using FMODUnity;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        private EventReference deadSfx;
        
        public override EnemyProfile Profile
        {
            set => deadSfx = value.SFXDictionary[SFXType.Dead];
        }

        public override void Enter()
        {
            var deadEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterDead");
            deadSfx.AttachedOneShot(StateMachine.gameObject);
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