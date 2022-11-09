using Enemy.Profile;
using UnityEngine;

namespace Enemy.State
{
    public class HitState : EnemyState
    {
        private float hitTime;
        private float thresholdTime;

        public override EnemyProfile Profile
        {
            set => hitTime = value.f_hitTime;
        }

        public override void Enter()
        {
            thresholdTime = Time.realtimeSinceStartup + hitTime;
            Debug.Log("Hit!");

            var hitEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterHit");

            if (hitEffect is not null)
            {
                hitEffect.transform.position = StateMachine.transform.GetChild(0).position;
                hitEffect.transform.localScale = StateMachine.transform.localScale;
            }
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