using Enemy.Profile;
using FMODUnity;
using UnityEngine;

namespace Enemy.State
{
    public class AttackState : EnemyState
    {
        private float attackTime;
        private float thresholdTime;
        private EventReference attackSfx;

        public override EnemyProfile Profile
        {
            set
            {
                attackTime = value.f_attackTime;
                attackSfx = value.SFXDictionary[SFXType.Attack1];
            }
        }

        public override void Enter()
        {
            thresholdTime = Time.realtimeSinceStartup + attackTime;
            attackSfx.PlayOneShot();
        }

        public override void LogicUpdate()
        {
            if (Time.realtimeSinceStartup > thresholdTime)
                StateMachine.ChangeState(e_EnemyState.Idle);
        }
        
        public override void OnDamaged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }
    }
}