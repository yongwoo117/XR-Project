

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
    void HandleInput();
}
