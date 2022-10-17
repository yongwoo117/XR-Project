using System;
using UnityEngine;

/// <summary>
/// 이 Class를 상속하면 Singleton 컴포넌트가 되며, 어디서나 접근 가능한 Instance 프로퍼티를 갖게 됩니다.
/// </summary>
/// <typeparam name="T"></typeparam>
public class Singleton<T> :MonoBehaviour where T : Component
{
    public static T Instance { get; private set; }

    /// <summary>
    /// 오버라이딩하는 경우 하위 클래스에서 반드시 base.Awake()를 호출해야 합니다.
    /// </summary>
    protected virtual void Awake()
    {
        if (Instance != null)
        {
            Debug.Log($"{typeof(T)}is already exist!!");
            Destroy(gameObject);
            return;
        }
        Instance = GetComponent<T>();

        if (Instance == null)
            Instance = gameObject.AddComponent<T>();

    }
}
