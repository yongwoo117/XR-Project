using System;
using UnityEngine;

/// <summary>
/// 플레이어를 위한 State들의 베이스 클래스입니다.
/// </summary>
[Serializable]
public abstract class PlayerState : IState<e_PlayerState, PlayerState, PlayerStateMachine>
{
    public PlayerStateMachine StateMachine { get; set; }

    public virtual PlayerProfile Profile
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

    /// <summary>
    /// 플레이어의 인터렉션 이벤트가 발생하면 Callback 됩니다.
    /// </summary>
    /// <param name="interactionType">State에 전달할 InteractionType입니다.</param>
    public virtual void HandleInput(InteractionType interactionType)
    {

    }

    /// <summary>
    /// 기즈모를 사용하려는 경우 이 메서드를 구현합니다.
    /// </summary>
    public virtual void OnDrawGizmos()
    {

    }

    public virtual void PhysicsUpdate()
    {

    }

    public virtual void LogicUpdate()
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

    public virtual void OnRhythmEarly()
    {
        
    }

    public virtual void OnRhythm()
    {
        
    }

    public virtual void OnRhythmLate()
    {
        
    }

    public void Release()
    {
        
    }
}
