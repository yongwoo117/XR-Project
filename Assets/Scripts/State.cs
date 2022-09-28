using System;
using UnityEngine;

/// <summary>
/// 모든 상태의 베이스 클래스입니다.
/// </summary>
[Serializable]
public class State : IState<e_State,State> //TODO: 일단 땜빵으로 해놓은 거라 하위에 PlayerState를 만들어줘야 합니다.
{
    protected StateMachine<e_State,State> m_stateMachine;
    public void SetMachine(StateMachine<e_State,State> stateMachine)
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
