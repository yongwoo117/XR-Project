using Enemy.Profile;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStateMachine : StateMachine<e_EnemyState, EnemyState, EnemyProfile>
{
    protected override e_EnemyState StartState => e_EnemyState.Idle;
    protected override IStateDictionary<e_EnemyState, EnemyState> StateDictionary => new EnemyStateDictionary();

    private void Start()
    {
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
