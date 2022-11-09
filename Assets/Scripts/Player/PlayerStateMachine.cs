using FMODUnity;
using UnityEngine;

public class PlayerStateMachine : CombatComboModule
{
    [SerializeField] private PlayerProfile profile;
    [SerializeField] private Animator AnimationController;
    
    public Animator Anim => AnimationController;
    
    protected override void OnEnable()
    {
        base.OnEnable();
        RhythmCore.Instance.onEarly.AddListener(OnEarly);
        RhythmCore.Instance.onRhythm.AddListener(OnRhythm);
    }

    protected override void OnDisable()
    {
        base.OnDisable();
        RhythmCore.Instance.onEarly.RemoveListener(OnEarly);
        RhythmCore.Instance.onRhythm.RemoveListener(OnRhythm);
    }

    private void OnEarly() => currentState.OnRhythmEarly();
    private void OnRhythm() => currentState.OnRhythm();
    public override void OnRhythmLate()
    {
        base.OnRhythmLate();
        currentState.OnRhythmLate();
    }
    
    protected override e_PlayerState StartState => e_PlayerState.Idle;
    protected override float MaximumHealth => profile.f_maximumHealth;
    protected override int CombatComboLimit => profile.i_maximumCombatCombo;
    protected override void OnInteraction(InteractionType type) => currentState?.HandleInput(type);
    protected override void OnBeforeStateInitialize(PlayerState state)
    {
        base.OnBeforeStateInitialize(state);
        state.Profile = profile;
    }
    
    protected override void OnDead()
    {
        base.OnDead();
        ChangeState(e_PlayerState.Die);
    }
}