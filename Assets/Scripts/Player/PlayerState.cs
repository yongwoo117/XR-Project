using System;

/// <summary>
/// 플레이어를 위한 State들의 베이스 클래스입니다.
/// </summary>
[Serializable]
public class PlayerState : IState<e_PlayerState,PlayerState> 
{
    public StateMachine<e_PlayerState, PlayerState> StateMachine { get; set; }

    public virtual void Initialize()
    {
        
    }

    public virtual void Enter()
    {
        
    }

    public virtual void Exit()
    {
     
    }

    /// <summary>
    /// 플레이어의 인터렉션 이벤트가 발생하면 Callback 됩니다.
    /// </summary>
    /// <param name="interactionType">State에 전달할 InteractionType입니다.</param>
    /// <param name="arg">Input과 관련한 매개변수 입니다. 상황에 따라 캐스팅하여 사용합니다.</param>
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
