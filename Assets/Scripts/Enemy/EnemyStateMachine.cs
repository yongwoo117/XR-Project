using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStateMachine : StateMachine
{
    private void Start()
    {

    }
    private void FixedUpdate()
    {
        currentState?.PhysicsUpdate();
    }

}
