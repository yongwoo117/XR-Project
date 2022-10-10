
using Enemy.Profile;

public class EnemyState : IState<e_EnemyState,EnemyState,EnemyProfile>
{
    public StateMachine<e_EnemyState, EnemyState, EnemyProfile> StateMachine { get; set; }

    public virtual void Initialize()
    {
        
    }

    public virtual void Enter()
    {
        
    }

    public virtual void Exit()
    {
        
    }

    public virtual void LogicUpdate()
    {
        
    }

    public virtual void PhysicsUpdate()
    {
        
    }

    public virtual void Dead()
    {
        
    }

    public virtual void HealthChanged(float value)
    {
        
    }

    public virtual void HealthRatioChanged(float value)
    {
        
    }

    public virtual void OnRhythm()
    {

    }

    /// <summary>
    /// 적 상태 범위를 보기 위한 기즈모 추가
    /// </summary>
    public virtual void OnDrawGizmos()
    {

    }
}
