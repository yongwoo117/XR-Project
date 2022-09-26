using UnityEngine;

public class IdleState : State
{
    public override void Enter()
    {
        Debug.Log("Idle Enter");
    }

    public override void HandleInput(InteractionType interactionType, object arg)
    {
        switch (interactionType)
        {
            case InteractionType.Primary:
                m_stateMachine.ChangeState(e_State.Dash);
                break;
        }
    }
}