using UnityEngine;

public class PlayerStateMachine : RhythmModule
{
    [SerializeField] private PlayerProfile profile;
    protected override e_PlayerState StartState => e_PlayerState.Idle;
    protected override HealthProfile healthProfile => profile;
    protected override void OnInteraction(InteractionType type) => currentState?.HandleInput(type);
    protected override void OnBeforeStateInitialize(PlayerState state)
    {
        base.OnBeforeStateInitialize(state);
        state.Profile = profile;
    }
}