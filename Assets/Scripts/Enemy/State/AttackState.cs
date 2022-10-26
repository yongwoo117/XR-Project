using Enemy.Animation;
using Enemy.Profile;
using UnityEngine;

namespace Enemy.State
{
    public class AttackState : EnemyState
    {
        private float attackTime;
        private float thresholdTime;

        public override EnemyProfile Profile
        {
            set => attackTime = value.f_attackTime;
        }

        public override void Enter()
        {
            
            thresholdTime = Time.realtimeSinceStartup + attackTime;
            StateMachine.Anim.SetTrigger(AnimationParameter.Attack);
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