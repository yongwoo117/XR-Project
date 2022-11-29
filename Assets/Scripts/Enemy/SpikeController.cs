using System.Collections;
using Enemy.Animation;
using FMODUnity;
using UnityEngine;
using Random = UnityEngine.Random;

public class SpikeController : MonoBehaviour
{
    [SerializeField] private float standardAttackDelay;
    [SerializeField] private float attackDelayRange;
    [SerializeField] private float damage;
    [SerializeField] private float warningTime;
    [SerializeField] private float attackRange;
    [SerializeField] private EventReference attackSfx;
    [SerializeField] private EventReference warningSfx;
    private GameObject player;
    private float activateTime;
    private Animator animator;
    private readonly Collider[] collisionBuffer = new Collider[1];

    private float RandomDelay => standardAttackDelay + Random.Range(-attackDelayRange, attackDelayRange);
    
    private void Start()
    {
        animator = GetComponent<Animator>();
        player = GameObject.FindWithTag("Player");
        StartCoroutine(WaitRoutine());
    }

    private IEnumerator WaitRoutine()
    {
        yield return new WaitForSeconds(RandomDelay);
        StartCoroutine(AttackRoutine());
    }

    private IEnumerator AttackRoutine()
    {
        transform.position = player.transform.position;
        animator.SetTrigger(AnimationParameter.Ready);
        warningSfx.AttachedOneShot(gameObject);
        yield return new WaitForSeconds(warningTime);
        Attack();
    }

    private void Attack()
    {

        animator.SetTrigger(AnimationParameter.Attack);
        attackSfx.AttachedOneShot(gameObject);
        var count = Physics.OverlapSphereNonAlloc(transform.position, attackRange, collisionBuffer,
            GetLayerMasks.Player);
        for (var i = 0; i < count; ++i)
            collisionBuffer[i].gameObject.GetComponent<HealthModule>().RequestDamage(damage);
        StartCoroutine(WaitRoutine());
    }

    private void OnDrawGizmos() => Gizmos.DrawWireSphere(transform.position, attackRange);
}
