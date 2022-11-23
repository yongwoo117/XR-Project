using Enemy.Animation;
using Enemy.Profile;
using FMODUnity;
using UnityEngine;

namespace Enemy.State
{
    public class AttackState : EnemyState
    {
        private float preDelay;
        private float postDelay;
        private float attackRange;
        private Vector3 attackBox;
        private float damage;
        private EventReference attackSfx;
        
        private float thresholdTime;
        private bool isAttacked;
        private Vector3 playerPosition;

        public override EnemyProfile Profile
        {
            set
            {
                preDelay = value.f_attackPreDelay;
                postDelay = value.f_attackPostDelay;
                attackSfx = value.SFXDictionary[SFXType.Attack1];
                attackBox = value.v3_attackBox;
                damage = value.f_damage;
                attackRange = value.f_AttackRange;
            }
        }

        public override void Enter()
        {
            var colliders = Physics.OverlapSphere(StateMachine.transform.position, attackRange, GetLayerMasks.Player);
            if (colliders.Length <= 0)
            {
                StateMachine.ChangeState(e_EnemyState.Idle);
                return;
            }

         

            playerPosition = colliders[0].transform.position;
            thresholdTime = Time.realtimeSinceStartup + preDelay;
            isAttacked = false;
            StateMachine.Anim.SetTrigger(AnimationParameter.Ready);
        }

        public override void LogicUpdate()
        {
            if (Time.realtimeSinceStartup < thresholdTime) return;
            
            if (isAttacked) StateMachine.ChangeState(e_EnemyState.Idle);
            else
            {

                StateMachine.Anim.SetTrigger(AnimationParameter.Attack);
                var currentPosition = StateMachine.transform.position;
                var direction = (playerPosition - currentPosition).normalized;
                var colliders = Physics.OverlapBox(currentPosition + direction * attackBox.z, attackBox / 2,
                    Quaternion.LookRotation(direction), GetLayerMasks.Player);
                if (colliders.Length > 0) colliders[0].GetComponent<HealthModule>().RequestDamage(damage);
                attackSfx.AttachedOneShot(StateMachine.gameObject);
                thresholdTime = Time.realtimeSinceStartup + postDelay;
                isAttacked = true;

                GameObject attackEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterAttack");

                if (attackEffect is not null)
                {
                    attackEffect.transform.parent = StateMachine.transform.GetChild(0);
                    attackEffect.transform.localPosition = Vector3.zero;
                    attackEffect.transform.localScale = Vector3.one;
                }
            }
        }
        
        public override void OnDamaged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }
    }
}