using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStateMachine : StateMachine<e_State,State> //TODO: 나중에 Enemy용으로 타입을 수정해줘야 합니다.
{
    protected override e_State StartState { get; }
    protected override IStateDictionary<e_State, State> StateDictionary { get; }

    private void Start()
    {

    }
    private void FixedUpdate()
    {
        currentState?.PhysicsUpdate();
    }

}
