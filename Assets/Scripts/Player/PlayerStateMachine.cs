using UnityEngine;

public class PlayerStateMachine : CombatComboModule
{
    [SerializeField] private PlayerProfile profile;
    protected override e_PlayerState StartState => e_PlayerState.Idle;
    protected override float MaximumHealth => profile.f_maximumHealth;
    protected override int CombatComboLimit => profile.i_maximumCombatCombo;
    protected override void OnInteraction(InteractionType type) => currentState?.HandleInput(type);
    protected override void OnBeforeStateInitialize(PlayerState state)
    {
        base.OnBeforeStateInitialize(state);
        state.Profile = profile;
    }

}