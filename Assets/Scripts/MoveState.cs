
using UnityEngine;

public class MoveState : State
{
    public override void Enter()
    {
        Debug.Log("Move Enter");
        m_stateMachine.ChangeState("AttackState");
    }
}
