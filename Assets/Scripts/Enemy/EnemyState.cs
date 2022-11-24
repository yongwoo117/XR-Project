using Enemy.Profile;
using UnityEngine;

public class EnemyState : IState<e_EnemyState, EnemyState, EnemyStateMachine>
{
    public EnemyStateMachine StateMachine { get; set; }

    public virtual EnemyProfile Profile
    {
        set { }
    }
    
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
    
    public virtual void OnDamaged(float value)
    {
        
    }

    public virtual bool AcceptHealthChange(ref float value) => true;

    public virtual void OnRhythm()
    {

    }

    public virtual void OnPause(bool isPaused)
    {
        
    }
    
    /// <summary>
    /// 적 상태 범위를 보기 위한 기즈모 추가
    /// </summary>
    public virtual void OnDrawGizmos()
    {

    }

    public virtual void Release()
    {
        
    }
}
