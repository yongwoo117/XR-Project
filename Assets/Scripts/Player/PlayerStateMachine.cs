
public class PlayerStateMachine : StateMachine<e_PlayerState, PlayerState, PlayerProfile>
{
    protected override e_PlayerState StartState => e_PlayerState.Idle;
    
    public void OnInteraction(InteractionType type, object arg) => currentState?.HandleInput(type, arg);
}