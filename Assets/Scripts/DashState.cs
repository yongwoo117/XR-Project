using System;
using UnityEngine;

public class DashState : State
{
    public override void Enter()
    {
        Debug.Log("Dash Enter");
    }

    public override void HandleInput(InteractionType interactionType)
    {
        switch (interactionType)
        {
            case InteractionType.Primary:
                break;
            case InteractionType.Secondary:
                m_stateMachine.ChangeState(e_State.Idle);
                break;
            case InteractionType.Wrong:
                m_stateMachine.ChangeState(e_State.Idle);
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(interactionType), interactionType, null);
        }
    }
}


