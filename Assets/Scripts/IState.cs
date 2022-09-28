

public interface IState<T1, T2> where T2 : IState<T1,T2>
{
    //TODO: StateMachine 인터페이스화
    void SetMachine(StateMachine<T1, T2> stateMachine);

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

    /// <summary>
    /// 플레이어의 인터렉션 이벤트가 발생하면 Callback 됩니다.
    /// </summary>
    /// <param name="interactionType">State에 전달할 InteractionType입니다.</param>
    /// <param name="arg">Input과 관련한 매개변수 입니다. 상황에 따라 캐스팅하여 사용합니다.</param>
    void HandleInput(InteractionType interactionType, object arg);
}
