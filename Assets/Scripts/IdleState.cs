using System;
using UnityEngine;

public class IdleState : State
{
    public override void Enter()
    {
        Debug.Log("Idle Enter");
    }

    public override void HandleInput(InteractionType interactionType)
    {
        switch (interactionType)
        {
            case InteractionType.Primary:
                m_stateMachine.ChangeState(e_State.Dash);
                break;
            case InteractionType.Secondary:
                break;
            case InteractionType.Wrong:
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(interactionType), interactionType, null);
        }
    }
}