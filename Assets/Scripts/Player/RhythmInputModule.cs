using UnityEngine.Events;

/// <summary>
/// 인터렉션 이벤트를 수신하여 리듬에 맞는지 체크합니다.
/// </summary>
public abstract class RhythmInputModule : StateMachine<e_PlayerState, PlayerState, PlayerStateMachine>
{
    /// <summary>
    /// 노트를 잘 못 친 경우 호출됩니다.
    /// </summary>
    public UnityEvent onRhythmMissed;

    /// <summary>
    /// 노트를 놓친 경우 호출됩니다.
    /// </summary>
    public UnityEvent onRhythmLost;


    public UnityEvent<InteractionType> onRhythm;
    protected abstract void OnInteraction(InteractionType type);


    //true일 때만 노트를 칠 수 있습니다.
    public bool RhythmFlag { get; private set; }


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
            onRhythm?.Invoke(type);
            rhythmFlag = false;
        }
        else
        {
            onRhythmMissed?.Invoke();
            OnInteraction(InteractionType.RhythmMiss);
        }

        RhythmFlag = false;
    }

    public virtual void OnRhythmHalf() => RhythmFlag = true;

    public virtual void OnRhythmLate()
    {
        if (!RhythmFlag) return;
        onRhythmLost?.Invoke();
        OnInteraction(InteractionType.RhythmLost);
    }
}