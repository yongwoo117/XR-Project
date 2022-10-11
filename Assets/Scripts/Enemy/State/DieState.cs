using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        private float thresholdTIme;

        private Vector3 startPosition;
        
        public override void Initialize()
        {
            startPosition = StateMachine.transform.position;
        }

        public override void Enter()
        {
            GameObject DeadEffect = EffectProfileData.Instance.PopEffect("Eff_MonsterDead");
            DeadEffect.transform.position = StateMachine.transform.GetChild(0).position;
            DeadEffect.transform.localScale = StateMachine.transform.localScale;

            StateMachine.gameObject.GetComponent<Collider>().enabled = false;
            StateMachine.gameObject.GetComponentInChildren<SpriteRenderer>().enabled = false;
            thresholdTIme = Time.realtimeSinceStartup + 2f;
        }

        public override void LogicUpdate()
        {
            if (thresholdTIme > Time.realtimeSinceStartup) return;
            
            StateMachine.gameObject.GetComponent<Collider>().enabled = true;
            StateMachine.gameObject.GetComponentInChildren<SpriteRenderer>().enabled = true;
            StateMachine.transform.position = startPosition;
            StateMachine.ChangeState(e_EnemyState.Idle);
        }
    }
}