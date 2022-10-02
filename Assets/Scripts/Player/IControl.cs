using UnityEngine;
using UnityEngine.Events;


public interface IControl
{
    /// <summary>
    /// 현재 입력이 가리키는 월드좌표계 값입니다.
    /// </summary>
    Vector3? Position { get; }
    
    /// <summary>
    /// 현재 오브젝트에서 Position까지의 방향벡터입니다.
    /// </summary>
    Vector3? Direction { get; }

    /// <summary>
    /// 사용자의 입력에 대한 콜백입니다.
    /// </summary>
    UnityEvent<InteractionType, object> OnInteraction { get; }
}