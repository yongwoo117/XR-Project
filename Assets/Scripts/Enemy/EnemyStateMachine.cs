using Enemy.Profile;
using System.Collections.Generic;
using UnityEngine;

public class EnemyStateMachine : StateMachine<e_EnemyState, EnemyState, EnemyStateMachine>
{
    [SerializeField] private EnemyProfile profile;
    [SerializeField] private Animator AnimationController;


    protected override e_EnemyState StartState => e_EnemyState.Idle;
    protected override float MaximumHealth => profile.f_maximumHealth;

    public Dictionary<e_EnemyState, EnemyState> States => Dic_States;

    public Animator Anim => AnimationController;

    protected override void OnBeforeStateInitialize(EnemyState state)
    {
        base.OnBeforeStateInitialize(state);
        state.Profile = profile;
    }

    private void Start()
    {
        //적 체력이 0이면 시작할때 죽는 상태로 변경
        if (profile.f_maximumHealth <= 0) ChangeState(e_EnemyState.Die);

        RhythmCore.Instance.onRhythm.AddListener(OnRhythm);
    }

    private void OnRhythm()
    {
        currentState?.OnRhythm();
    }

    private void OnDestroy()
    {
        RhythmCore.Instance.onRhythm.RemoveListener(OnRhythm);
    }
}
