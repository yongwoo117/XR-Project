using System;
using UnityEngine;

[Serializable]
public class State : IState
{
    protected StateMachine m_stateMachine;
    public void SetMachine(StateMachine stateMachine)
    {
        m_stateMachine = stateMachine;
    }
    public virtual void Enter()
    {
        
    }

    public virtual void Exit()
    {
     
    }

    public virtual void HandleInput()
    {
     
    }

    public virtual void PhysicsUpdate()
    {
       
    }

    public virtual void RogicUpdate()
    {
       
    }
}
