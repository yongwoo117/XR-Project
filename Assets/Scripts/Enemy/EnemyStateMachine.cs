using Enemy.Profile;
using UnityEngine;

public class EnemyStateMachine : StateMachine<e_EnemyState, EnemyState>
{
    [SerializeField] private EnemyProfile profile;
    protected override e_EnemyState StartState => e_EnemyState.Idle;
    protected override HealthProfile healthProfile => profile;

    private void Start()
    {
        //적 체력이 0이면 시작할때 죽는 상태로 변경
        if (profile.f_maximumHealth <= 0) ChangeState(e_EnemyState.Die);

        RhythmCore.Instance.onRhythm.AddListener(OnRhythm);
        foreach (var pair in Dic_States)
            pair.Value.Profile = profile;
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
