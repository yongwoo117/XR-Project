using UnityEngine;
using UnityEngine.Events;

/// <summary>
/// 인터렉션 이벤트를 수신하여 리듬에 맞는지 체크합니다.
/// </summary>
public class RhythmInput : MonoBehaviour
{
    //true일 때만 노트를 칠 수 있습니다.
    private bool rhythmFlag;
    
    public UnityEvent<int> onRhythmStreakChanged;
    public UnityEvent<InteractionType, object> onInteraction;
    
    private int RhythmStreak
    {
        get => rhythmStreak;
        set
        {
            rhythmStreak = value;
            onRhythmStreakChanged.Invoke(rhythmStreak);
        }
    }
    private int rhythmStreak;
    
    /// <summary>
    /// 너무 일찍 노트를 친 경우 호출됩니다.
    /// </summary>
    public UnityEvent onTooEarly;
    
    /// <summary>
    /// 노트를 놓쳐버린 경우 호출됩니다.
    /// </summary>
    public UnityEvent onTooLate;

    private void Start()
    {
        rhythmFlag = true;
        rhythmStreak = 0;
    }

    public void OnInteraction(InteractionType type, object arg)
    {
        if (rhythmFlag && RhythmCore.Instance.Judge())
        {
            onInteraction?.Invoke(type, arg);
            RhythmStreak++;
        }
        else
        {
            onTooEarly?.Invoke();
            onInteraction?.Invoke(InteractionType.RhythmEarly, arg);
            RhythmStreak = 0;
        }
        rhythmFlag = false;
    }

    public void OnRhythmLate()
    {
        if (rhythmFlag)
        {
            onTooLate?.Invoke();
            onInteraction?.Invoke(InteractionType.RhythmLate, null);
            RhythmStreak = 0;
        }

        rhythmFlag = true;
    }
}
