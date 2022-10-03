

/// <typeparam name="T3"></Profile을 추가하기 위해서 제네릭 타입을 추가하였습니다.>
public interface IState<T1, T2, T3> where T2 : IState<T1,T2, T3> 
{
    public StateMachine<T1, T2, T3> StateMachine { set; }

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
    
    /// <summary>
    /// Update()와 동일합니다.
    /// </summary>
    void LogicUpdate();
    
    /// <summary>
    /// FixedUpdate()와 동일합니다.
    /// </summary>
    void PhysicsUpdate();
}
