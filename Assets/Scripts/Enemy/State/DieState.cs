using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        private ObjectPoolingCallBack objectPoolingCallBack;
        public override void Enter()
        {
            if(objectPoolingCallBack==null)
                objectPoolingCallBack = StateMachine.GetComponent<ObjectPoolingCallBack>();

            GameObject DeadEffect = ObjectPoolingManager.Instance.Pool<EffectCallBack>("Eff_MonsterDead").Get();
            DeadEffect.transform.position = StateMachine.transform.position;
            DeadEffect.transform.localScale = StateMachine.transform.localScale;

            objectPoolingCallBack?.Pool.Release(StateMachine.gameObject);
        }
    }
}