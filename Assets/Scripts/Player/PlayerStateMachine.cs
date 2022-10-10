
public class PlayerStateMachine : StateMachine<e_PlayerState, PlayerState, PlayerProfile>
{
    protected override e_PlayerState StartState => e_PlayerState.Idle;

    private void Update() => currentState?.LogicUpdate();

    private void FixedUpdate() => currentState?.PhysicsUpdate();

    private void OnDrawGizmos() => currentState?.OnDrawGizmos();

    public void OnInteraction(InteractionType type, object arg) => currentState?.HandleInput(type, arg);
}