using UnityEngine.Events;

/// <summary>
/// 인터렉션 이벤트를 수신하여 리듬에 맞는지 체크합니다.
/// </summary>
public abstract class RhythmInputModule : StateMachine<e_PlayerState, PlayerState, PlayerStateMachine>
{
    //true일 때만 노트를 칠 수 있습니다.
    private bool rhythmFlag;
    
    /// <summary>
    /// 너무 일찍 노트를 친 경우 호출됩니다.
    /// </summary>
    public UnityEvent onTooEarly;

    /// <summary>
    /// 노트를 놓쳐버린 경우 호출됩니다.
    /// </summary>
    public UnityEvent onTooLate;

    protected abstract void OnInteraction(InteractionType type);

    protected override void Awake()
    {
        base.Awake();
        rhythmFlag = true;
    }

    public void InteractionCallback(InteractionType type)
    {
        if (rhythmFlag && RhythmCore.Instance.Judge())
        {
            OnInteraction(type);
            rhythmFlag = false;
        }
        else
        {
            onTooEarly?.Invoke();
            OnInteraction(InteractionType.RhythmEarly);
        }
    }

    public virtual void OnRhythmLate()
    {
        if (rhythmFlag)
        {
            onTooLate?.Invoke();
            OnInteraction(InteractionType.RhythmLate);
        }

        rhythmFlag = true;
    }
}