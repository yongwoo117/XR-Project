using UnityEngine;

public class PlayerStateMachine : RhythmModule
{
    [SerializeField] private PlayerProfile profile;
    protected override e_PlayerState StartState => e_PlayerState.Idle;
    protected override HealthProfile healthProfile => profile;
    protected override void OnInteraction(InteractionType type) => currentState?.HandleInput(type);

    private void Start()
    {
        foreach (var pair in Dic_States)
            pair.Value.Profile = profile;
    }
}