using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

/// <summary>
/// 키보드 & 마우스 입력장치에 대한 이벤트를 처리합니다.
/// </summary>
public class KBDMouseControl : MonoBehaviour, IControl
{
    private Plane rayCastPlane;
    
    /// <summary>
    /// 현재 마우스 커서가 가리키는 rayCastPlane 위의 한 점입니다.
    /// </summary>
    public Vector3? Position {
        get
        {
            if (position != null) return position;
            var ray = Camera.main!.ScreenPointToRay(Mouse.current.position.ReadValue());
            position = !rayCastPlane.Raycast(ray, out var distance) ? null : ray.GetPoint(distance);
            return position;
        }
        private set => position = value;
    }
    private Vector3? position;
    
    /// <summary>
    /// 현재 오브젝트에서 Position까지의 방향벡터입니다.
    /// </summary>
    public Vector3? Direction => Position - transform.position;

    public UnityEvent<InteractionType> OnInteraction => onInteraction;
    public UnityEvent<InteractionType> onInteraction;
    
    private void Start()
    {
        rayCastPlane = new Plane(Vector3.up, -transform.position.y);
    }

    private void LateUpdate()
    {
        Position = null;
    }

    /// <summary>
    /// 마우스 왼쪽 버튼과 관련된 이벤트를 처리합니다.
    /// </summary>
    public void OnPrimaryInteraction(InputAction.CallbackContext context)
    {
        switch (context.action.phase)
        {
            case InputActionPhase.Started:
                onInteraction?.Invoke(InteractionType.Ready);
                break;
            case InputActionPhase.Canceled:
                onInteraction?.Invoke(InteractionType.Dash);
                break;
        }
    }

    /// <summary>
    /// 스페이스바와 관련된 이벤트를 처리합니다.
    /// </summary>
    public void OnThirdInteraction(InputAction.CallbackContext context)
    {
        if(!context.started) return;
            onInteraction?.Invoke(InteractionType.Cut);
    }

   
}
