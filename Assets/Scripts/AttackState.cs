

using UnityEngine;

public class AttackState : State
{
    public override void Enter()
    {
        Debug.Log("Attack Enter");
        m_stateMachine.ChangeState("SkillState");
    }
}


