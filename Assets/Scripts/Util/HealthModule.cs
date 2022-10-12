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
    /// 사망시에 호출됩니다.
    /// </summary>
    public UnityEvent onDead;
    
    protected abstract HealthProfile healthProfile { get; }

    public float MaximumHealth => healthProfile.f_maximumHealth;
    
    public float HealthPoint
    {
        get => healthPoint;
        set
        {
            healthPoint = value;
            onHealthChanged?.Invoke(healthPoint);
            onHealthRatioChanged?.Invoke(HealthRatio);
            if (healthPoint <= 0)
                onDead?.Invoke();
        }
    }
    private float healthPoint;

    public float HealthRatio => HealthPoint / MaximumHealth;

    protected virtual void Awake()
    {
        HealthPoint = healthProfile.f_maximumHealth;
    }
}
