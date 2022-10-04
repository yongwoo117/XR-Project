using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStateMachine : StateMachine<e_EnemyState, EnemyState> //TODO: 나중에 Enemy용으로 타입을 수정해줘야 합니다.
{
    protected override e_EnemyState StartState => e_EnemyState.Idle;
    protected override IStateDictionary<e_EnemyState, EnemyState> StateDictionary => new EnemyStateDictionary();

    private void FixedUpdate()
    {
        currentState?.PhysicsUpdate();
    }

}
