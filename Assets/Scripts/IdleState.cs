using UnityEngine;

public class IdleState : State
{
    public override void Enter()
    {
        Debug.Log("Idle Enter");
        m_stateMachine.ChangeState(e_State.Move);
    }


}