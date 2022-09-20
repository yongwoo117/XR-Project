using UnityEngine.Events;
using UnityEngine.InputSystem;

public class PlayerStateMachine : StateMachine
{
    //true면 노트를 칠 수 있고, false면 칠 수 없습니다.
    private bool RhythmFlag
    {
        get => rhythmFlag;
        set
        {
            rhythmFlag = value;
            onRhythmFlagChanged?.Invoke(rhythmFlag);
        }
    }
    private bool rhythmFlag;

    /// <summary>
    /// RhythmFlag의 값이 변경되면 RhythmFlag의 값과 함께 Callback됩니다.
    /// </summary>
    public UnityEvent<bool> onRhythmFlagChanged;
    
    private void Start() => rhythmFlag = true;

    public void OnRhythmLate()
    {
        //true였다면 노트를 놓친 경우이므로 패널티를 부여합니다.
        //false였다면 정상적인 플레이였거나, 패널티를 받았더라도 이미 수행한 경우이므로 true를 넘겨줍니다.
        RhythmFlag = !RhythmFlag;
    }

    private void OnInteraction(InputAction.CallbackContext context, InteractionType interactionType)
    {
        //필요 없는 이벤트를 걸러냅니다.
        if (!context.performed) return;
        
        //모든 조건식이 참인 경우 interactionType을 넘깁니다.
        //리듬에 맞지 않거나, 이미 한 번 처리했던 노트인 경우 Wrong을 넘깁니다.
        currentState?.HandleInput(RhythmFlag && RhythmCore.Instance.Judge() ? interactionType : InteractionType.Wrong);
        RhythmFlag = false;
    }

    public void OnPrimaryInteraction(InputAction.CallbackContext context) => OnInteraction(context, InteractionType.Primary);
    public void OnSecondaryInteraction(InputAction.CallbackContext context) => OnInteraction(context, InteractionType.Secondary);
}