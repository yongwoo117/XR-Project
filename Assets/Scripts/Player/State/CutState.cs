using FMODUnity;
using Player.Animation;
using Unity.VisualScripting;
using UnityEngine;

namespace Player.State
{
    public class CutState : PlayerState
    {
        private float attackRange;
        private float damage;
        private float multiplier;
        private int cutIndex=0;

        private EventReference cutSfx;
        private IControl control;
        
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

        public override void Initialize()
        {
            control = StateMachine.GetComponent<IControl>();
        }

        public override void Enter()
        {
            Debug.Log("Cut Enter");
            var cutEffect = EffectProfileData.Instance.PopEffect(cutIndex == 0 ? "Eff_SlashDown" : "Eff_SlashUp");

            StateMachine.RhythmCombo++;
            StateMachine.AddCombatCombo(e_PlayerState.Cut);
            StateMachine.Anim.SetTrigger(AnimationParameter.Cut);
            StateMachine.Anim.SetFloat(AnimationParameter.CutIndex, cutIndex++);

            control.IsActive = false;
            if (cutIndex >= 2) cutIndex = 0;
            if (cutEffect != null)
            {
                var cutScale = cutEffect.transform.localScale;
                cutScale.x = Mathf.Abs(cutScale.x);
                cutEffect.transform.parent = StateMachine.transform.GetChild(0);
                cutEffect.transform.localPosition = Vector3.zero;
                cutEffect.transform.localScale = cutScale;
            }

            Attack();
        }

        public override void Exit()
        {
            Debug.Log("Cut Exit");
            cutIndex = 0;
            control.IsActive = true;
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
                    StateMachine.ChangeState(e_PlayerState.Miss);
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
            cutSfx.AttachedOneShot(StateMachine.gameObject);
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
            
            var gfx = StateMachine.transform.GetChild(0);
            var scale = gfx.localScale;
            scale.x = Mathf.Abs(scale.x);
            if ((nearestEnemy.transform.position - StateMachine.transform.position).x > 0) scale.x *= -1; 
            gfx.localScale = scale;

            nearestEnemy.GetComponent<HealthModule>().RequestDamage(damage * multiplier);
        }
    }
}