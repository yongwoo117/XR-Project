using Enemy.Profile;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStateMachine : StateMachine<e_EnemyState, EnemyState, EnemyProfile>
{
    protected override e_EnemyState StartState => e_EnemyState.Idle;
    protected override IStateDictionary<e_EnemyState, EnemyState> StateDictionary => new EnemyStateDictionary();

    protected override void Start()
    {
        //적 체력이 0이면 시작할때 죽는 상태로 변경
        if(Profile.i_Hp<=0)
        {
            ChangeState(e_EnemyState.Die);
        }

        base.Start();
        RhythmCore.Instance.onRhythm.AddListener(OnRhythm);
    }

    private void OnDrawGizmos()
    {
        currentState?.OnDrawGizmos();
    }

    private void FixedUpdate()
    {
        currentState?.PhysicsUpdate();
    }

    private void Update()
    {
        currentState?.LogicUpdate();
    }

    private void OnRhythm()
    {
        currentState?.OnRhythm();
    }

    private void OnDestroy()
    {
        RhythmCore.Instance.onRhythm.RemoveListener(OnRhythm);
    }

}
