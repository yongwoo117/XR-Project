

public interface IState 
{
    /// <summary>
    /// State가 시작되는 시점에 Callback 됩니다.
    /// </summary>
    void Enter();
    
    /// <summary>
    /// State가 끝나는 시점에 Callback 됩니다.
    /// </summary>
    void Exit();
    void LogicUpdate();
    void PhysicsUpdate();
    
    /// <summary>
    /// 플레이어의 인터렉션 이벤트가 발생하면 Callback 됩니다.
    /// </summary>
    /// <param name="interactionType">State에 전달할 InteractionType입니다.</param>
    void HandleInput(InteractionType interactionType);
}
