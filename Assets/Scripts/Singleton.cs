using UnityEngine;

/// <summary>
/// 이 Class를 상속하면 Singleton 컴포넌트가 되며, 어디서나 접근 가능한 Instance 프로퍼티를 갖게 됩니다. 대신 Awake를 사용하면 안됩니다.
/// </summary>
/// <typeparam name="T"></typeparam>
public class Singleton<T> : MonoBehaviour
{
    public static T Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.Log($"{typeof(T)}is already exist!!");
            Destroy(gameObject);
            return;
        }
        Instance = GetComponent<T>();
    }
}
