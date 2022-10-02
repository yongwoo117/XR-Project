using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStateMachine : StateMachine<e_EnemyState, EnemyState>
{
    protected override e_EnemyState StartState => e_EnemyState.Idle;
    protected override IStateDictionary<e_EnemyState, EnemyState> StateDictionary => new EnemyStateDictionary();

    protected override void Start()
    {
        base.Start();
    }
    
    private void FixedUpdate()
    {
        currentState?.PhysicsUpdate();
    }

}
