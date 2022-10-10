using Enemy.Profile;

public class EnemyStateMachine : StateMachine<e_EnemyState, EnemyState, EnemyProfile>
{
    protected override e_EnemyState StartState => e_EnemyState.Idle;

    private void Start()
    {
        //적 체력이 0이면 시작할때 죽는 상태로 변경
        if (Profile.f_maximumHealth <= 0)
        {
            ChangeState(e_EnemyState.Die);
        }

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
