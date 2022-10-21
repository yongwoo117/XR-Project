using System.Collections.Generic;
using UnityEngine;

public class PlayerStateMachine : RhythmFeedbackModule
{
    [SerializeField] private PlayerProfile profile;

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
    protected override HealthProfile healthProfile => profile;
    protected override void OnInteraction(InteractionType type) => currentState?.HandleInput(type);
    protected override void OnBeforeStateInitialize(PlayerState state)
    {
        base.OnBeforeStateInitialize(state);
        state.Profile = profile;
    }
}