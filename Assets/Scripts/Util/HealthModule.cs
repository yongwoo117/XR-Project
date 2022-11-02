using System;
using UnityEngine;
using UnityEngine.Events;

public abstract class HealthModule : MonoBehaviour
{
    /// <summary>
    /// 체력값이 변경되었을 때, 체력값이 매개변수에 전달되며 호출됩니다.
    /// </summary>
    public UnityEvent<float> onHealthChanged;

    /// <summary>
    /// 체력값이 변경되었을 때, 체력 비례값이 매개변수에 전달되며 호출됩니다.
    /// </summary>
    public UnityEvent<float> onHealthRatioChanged;

    /// <summary>
    /// 피해를 입은 경우, 입은 피해량이 매개변수에 전달되며 호출됩니다.
    /// </summary>
    public UnityEvent<float> onDamaged;

    /// <summary>
    /// 체력이 회복된 경우, 회복된 체력량이 매개변수에 전달되며 호출됩니다.
    /// </summary>
    public UnityEvent<float> onHealed;

    /// <summary>
    /// 사망시에 호출됩니다.
    /// </summary>
    public UnityEvent onDead;

    /// <summary>
    /// 피해를 무시한 경우 호출됩니다.
    /// </summary>
    public UnityEvent onDamageCanceled;
    
    protected abstract float MaximumHealth { get; }
    
    public float HealthPoint
    {
        get => healthPoint;
        private set
        {
            var difference = healthPoint - value;
            healthPoint = value;
            if (difference > 0)
                onDamaged?.Invoke(difference);
            else
                onHealed?.Invoke(-difference);
            onHealthChanged?.Invoke(healthPoint);
            onHealthRatioChanged?.Invoke(HealthRatio);
            if (healthPoint <= 0)
                onDead?.Invoke();
        }
    }
    private float healthPoint;

    public float HealthRatio => HealthPoint / MaximumHealth;
    
    /// <summary>
    /// 대상에게 피해를 가하거나, 회복시키기 위해 요청합니다.
    /// </summary>
    /// <param name="value">양수이면 피해, 음수이면 회복으로 간주합니다.</param>
    public void RequestDamage(float value)
    {
        if (AcceptHealthChange(ref value))
        {
            HealthPoint -= value;
        }
        else if (value > 0)
        {
            onDamageCanceled?.Invoke();
        }
    }

    /// <summary>
    /// RequestHealthChange가 호출되면 호출됩니다.
    /// </summary>
    /// <param name="value">변경요청된 체력량입니다. 양수면 피해, 음수면 회복입니다.</param>
    /// <returns>true가 반환되면 체력에 반영됩니다.</returns>
    protected abstract bool AcceptHealthChange(ref float value);
    
    protected virtual void OnEnable()
    {
        HealthPoint = MaximumHealth;
    }
}
