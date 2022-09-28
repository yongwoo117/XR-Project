

public interface IState<T1, T2> where T2 : IState<T1,T2>
{
    public StateMachine<T1, T2> StateMachine { set; }

    /// <summary>
    /// MonoBehaviour.Start()와 같은 시점에 호출됩니다.
    /// </summary>
    void Initialize();
    
    /// <summary>
    /// State가 시작되는 시점에 Callback 됩니다.
    /// </summary>
    void Enter();
    
    /// <summary>
    /// State가 끝나는 시점에 Callback 됩니다.
    /// </summary>
    void Exit();
    
    void LogicUpdate();
    
    /// <summary>
    /// FixedUpdate()와 동일합니다.
    /// </summary>
    void PhysicsUpdate();
}
