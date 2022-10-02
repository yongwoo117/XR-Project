
public class PlayerStateMachine : StateMachine<e_PlayerState, PlayerState>
{
    protected override e_PlayerState StartState => e_PlayerState.Idle;
    protected override IStateDictionary<e_PlayerState, PlayerState> StateDictionary => new PlayerStateDictionary();

    private void Update() => currentState?.LogicUpdate();

    private void FixedUpdate() => currentState?.PhysicsUpdate();

    private void OnDrawGizmos() => currentState?.OnDrawGizmos();

    public void OnInteraction(InteractionType type, object arg) => currentState?.HandleInput(type, arg);
}