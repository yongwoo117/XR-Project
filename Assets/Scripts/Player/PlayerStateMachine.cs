
using FMODUnity;
using System;
using UnityEngine;
using Player.Animation;

public class PlayerStateMachine : RhythmFeedbackModule
{
    [SerializeField] private PlayerProfile profile;
    [SerializeField] private Animator AnimationController;
    
    public Animator Anim => AnimationController;
    public bool IsFlip => isFlip;
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
    protected override void OnInteraction(InteractionType type) => currentState?.HandleInput(type);
    protected override void OnBeforeStateInitialize(PlayerState state)
    {
        base.OnBeforeStateInitialize(state);
        state.Profile = profile;
    }

    protected override void OnDamaged(float value)
    {
        base.OnDamaged(value);
        ChangeState(e_PlayerState.Hit);
    }

    protected override void OnDead()
    {
        base.OnDead();
        ChangeState(e_PlayerState.Die);
    }

    public  void AddDictionaryState(e_PlayerState e_state)
    {
        //이미 추가된 키값이면 넘깁니다.
        if (Dic_States.ContainsKey(e_state)) return;

        var type = e_state.GetStateType();

        //IState가 아닌 경우 넘깁니다.
        if (type is null) return;
        if (!type.IsSubclassOf(typeof(PlayerState))) return;

        var state = (PlayerState)Activator.CreateInstance(type);
        OnBeforeStateInitialize(state);
        state.Initialize();
        Dic_States.Add(e_state, state);

    }
}