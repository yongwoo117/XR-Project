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
                break;
            case InteractionType.Secondary:
                CheckDashDistance();
                m_stateMachine.ChangeState(e_State.Dash);
                break;
            case InteractionType.Wrong:
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(interactionType), interactionType, null);
        }
    }

    /// <summary>
    /// Ground 레이어에 Ray를 통해 충돌 체크 후 포인트 반환 PlayerStateMachine에 반환
    /// </summary>
    private void CheckDashDistance()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        PlayerStateMachine playerStateMachine = m_stateMachine as PlayerStateMachine;

        if (Physics.Raycast(ray, out RaycastHit rayhit,100f,GetLayerMasks.Ground))
            playerStateMachine.PointDir = rayhit.point - m_stateMachine.transform.position;
    }
}