using FMODUnity;
using UnityEngine;

namespace Player.State
{
    public class CutState : PlayerState
    {
        private float attackRange;
        private float damage;
        private float multiplier;

        private EventReference cutSfx;
        
        private readonly Collider[] collisionBuffer = new Collider[10];
        
        public override PlayerProfile Profile
        {
            set
            {
                attackRange = value.f_cutRange;
                damage = value.f_standardDamage;
                multiplier = value.f_cutMultipier;
                cutSfx = value.SFXDictionary[SFXType.Attack2];
            }
        }

        public override void Enter()
        {
            Debug.Log("Cut Enter");
            StateMachine.RhythmCombo++;
            StateMachine.AddCombatCombo(e_PlayerState.Cut);
            cutSfx.PlayOnShot();
            Attack();
        }

        public override void Exit()
        {
            Debug.Log("Cut Exit");
        }
        
        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.Cut:
                    Enter();
                    break;
                case InteractionType.Ready:
                    StateMachine.ChangeState(e_PlayerState.Ready);
                    break;
                case InteractionType.Dash:
                    StateMachine.ChangeState(e_PlayerState.Dash);
                    break;
                default:
                    StateMachine.ChangeState(e_PlayerState.Idle);
                    break;
            }
        }

        public override void OnDrawGizmos()
        {
            Gizmos.color = Color.cyan;
            Gizmos.DrawWireSphere(StateMachine.transform.position, attackRange);
        }
        
        private void Attack()
        {
            var count = Physics.OverlapSphereNonAlloc(StateMachine.transform.position, attackRange, collisionBuffer,
                GetLayerMasks.Enemy);
            if (count == 0) return;
            
            var nearestEnemy = collisionBuffer[0].gameObject;
            var nearestSqrDistance = (nearestEnemy.transform.position - StateMachine.transform.position).sqrMagnitude;
            
            for (var index = 1; index < count; index++)
            {
                var sqrDistance = (collisionBuffer[index].transform.position - StateMachine.transform.position)
                    .sqrMagnitude;
                if (!(sqrDistance < nearestSqrDistance)) continue;
                nearestEnemy = collisionBuffer[index].gameObject;
                nearestSqrDistance = sqrDistance;
            }

            nearestEnemy.GetComponent<HealthModule>().RequestDamage(damage * multiplier);
        }
    }
}