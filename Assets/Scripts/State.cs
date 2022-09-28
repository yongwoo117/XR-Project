using System;
using UnityEngine;

/// <summary>
/// 모든 상태의 베이스 클래스입니다.
/// </summary>
[Serializable]
public class State : IState
{
    protected StateMachine m_stateMachine;
    public void SetMachine(StateMachine stateMachine)
    {
        m_stateMachine = stateMachine;
    }

    public virtual void Initialize()
    {
        
    }

    public virtual void Enter()
    {
        
    }

    public virtual void Exit()
    {
     
    }

    public virtual void HandleInput(InteractionType interactionType, object arg)
    {
     
    }

    public virtual void PhysicsUpdate()
    {
       
    }

    public virtual void LogicUpdate()
    {
       
    }
}
