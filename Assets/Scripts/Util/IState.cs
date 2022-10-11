using System;
using UnityEngine;

/// <typeparam name="T1">State를 구분할 enum 형식입니다.</typeparam>
public interface IState<T1> where T1 : Enum
{
    public IStateMachine<T1> StateMachine { set; }
    public GameObject gameObject { set; }

    /// <summary>
    /// MonoBehaviour.Start()와 같은 시점에 호출됩니다.
    /// </summary>
    void Initialize();
    
    /// <summary>
    /// State가 시작되는 시점에 Callback 됩니다.
    /// </summary>
    void Enter();
    
    /// <summary>
    /// State가 끝나는 시점에 Callback 됩니다.
    /// </summary>
    void Exit();
    
    /// <summary>
    /// Update()와 동일합니다.
    /// </summary>
    void LogicUpdate();
    
    /// <summary>
    /// FixedUpdate()와 동일합니다.
    /// </summary>
    void PhysicsUpdate();

    void OnDrawGizmos();

    void Dead();

    void HealthChanged(float value);

    void HealthRatioChanged(float value);
}
