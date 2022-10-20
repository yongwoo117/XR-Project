using System;
using UnityEngine;

/// <typeparam name="T1">State를 구분할 enum 형식입니다.</typeparam>
public interface IState<T1, T2, T3> where T1 : Enum where T2 : IState<T1, T2, T3> where T3 : StateMachine<T1, T2, T3>
{
    public T3 StateMachine { set; }

    /// <summary>
    /// MonoBehaviour.Awake()와 같은 시점에 호출됩니다.
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

    void OnDamaged(float value);

    void HealthRatioChanged(float value);

    /// <summary>
    /// 체력 변경 요청에 대한 응답을 나타냅니다.
    /// </summary>
    /// <param name="value">양수면 피해, 음수면 회복입니다. 전달된 값을 변경하면 그 값이 체력에 반영됩니다.</param>
    /// <returns>true를 반환하면 체력 변경 요청을 수락합니다.</returns>
    bool AcceptHealthChange(ref float value);
}
