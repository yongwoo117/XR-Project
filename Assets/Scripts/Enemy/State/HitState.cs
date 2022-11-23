using Enemy.Profile;
using FMODUnity;
using UnityEngine;

namespace Enemy.State
{
    public class HitState : EnemyState
    {
        private float hitTime;
        private float thresholdTime;
        private EventReference hitSfx;

        public override EnemyProfile Profile
        {
            set
            {
                hitTime = value.f_hitTime;
                hitSfx = value.SFXDictionary[SFXType.Hit];
            }
        }

        public override void Enter()
        {
            thresholdTime = Time.realtimeSinceStartup + hitTime;
            Debug.Log("Hit!");

            var hitEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterHit");
            hitSfx.AttachedOneShot(StateMachine.gameObject);

            if (hitEffect is null) return;
            hitEffect.transform.position = StateMachine.transform.GetChild(0).position;
            hitEffect.transform.localScale = Vector3.one;
        }

        public override void LogicUpdate()
        {
            if (Time.realtimeSinceStartup > thresholdTime)
                StateMachine.ChangeState(e_EnemyState.Idle);
        }

        public override void OnDamaged(float value)
        {
            Enter();
        }

        public override void Dead()
        {
            StateMachine.ChangeState(e_EnemyState.Die);
        }
    }
}