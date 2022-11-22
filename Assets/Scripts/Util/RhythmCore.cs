using System;
using UnityEngine;
using UnityEngine.Events;

public enum EventState
{
    OnHalf,     //리듬과 리듬 사이 중간
    OnEarly,    //리듬 판정시 true가 되는 시점
    OnRhythm,   //노트의 목표 시간
    OnLate      //리듬 판정시 false가 되는 시점
}

public class RhythmCore : Singleton<RhythmCore>
{
    [SerializeField] private double bpm;
    [SerializeField] [Range(0.0f, 0.5f)] private double judgeOffsetRatio;
    [SerializeField] private double startOffset;
    
    private EventState? currentEventState;
    private double eventActivateTime;
    private bool pauseFlag;
    private double pausedTime;

    /// <summary>
    /// Bpm이 변경되면 Callback됩니다.
    /// </summary>
    public UnityEvent onBpmChanged;

    /// <summary>
    /// 노트와 노트 사이에 발생합니다.
    /// </summary>
    public UnityEvent onHalf;
    
    /// <summary>
    /// 노트를 친 것으로 판정이 가능해지는 시점에 Callback됩니다.
    /// </summary>
    public UnityEvent onEarly;
    
    /// <summary>
    /// 노트가 목표로 하는 시점에 Callback됩니다.
    /// </summary>
    public UnityEvent onRhythm;
    
    /// <summary>
    /// 노트를 놓쳤다고 판정이 가능해지는 시점에 Callback됩니다.
    /// </summary>
    public UnityEvent onLate;

    /// <summary>
    /// RhythmCore가 시작하는 시점을 초단위로 조정합니다. 음수면 더 늦게 시작되며, 양수면 더 빨리 시작됩니다.
    /// </summary>
    public double StartOffset
    {
        get => startOffset;
        set => startOffset = value;
    }
    
    /// <summary>
    /// 노트 간격 시간입니다.
    /// </summary>
    public double RhythmDelay { get; private set; }
    
    /// <summary>
    /// Half부터 Early까지의 시간 간격입니다.
    /// </summary>
    public double HalfToEarly { get; private set; }

    /// <summary>
    /// 판정 범위를 나타냅니다. 이 값 만큼 위, 아래에 범위를 적용하여 노트를 판정합니다.
    /// </summary>
    public double JudgeOffset { get; private set; }

    /// <summary>
    /// 판정 범위를 노트 간격 시간에 대한 비례로 나타냅니다.
    /// </summary>
    public double JudgeOffsetRatio => judgeOffsetRatio;
    
    /// <summary>
    /// 분당 노트의 출현 횟수를 의미합니다.
    /// </summary>
    public double Bpm
    {
        get => bpm;
        set
        {
            bpm = value;
            Initialize();
            RhythmStart(0);
            onBpmChanged?.Invoke();
        }
    }

    /// <summary>
    /// 현재 시점을 기준으로 노트를 판정합니다.
    /// </summary>
    public bool Judge() => currentEventState is EventState.OnRhythm or EventState.OnLate;
    
    /// <summary>
    /// 다음 리듬까지 남은 시간에 관한 정보를 반환합니다.
    /// </summary>
    public double? RemainTime(EventState destinationState)
    {
        if (currentEventState is not { } currentState || pauseFlag) return null;
        var nextRemain = eventActivateTime - Time.realtimeSinceStartupAsDouble;
        while (currentState != destinationState)
        {
            nextRemain += destinationState switch
            {
                EventState.OnHalf or EventState.OnEarly => HalfToEarly,
                EventState.OnLate or EventState.OnRhythm => JudgeOffset,
                _ => throw new ArgumentOutOfRangeException()
            };
            destinationState = destinationState != EventState.OnHalf ? destinationState - 1 : EventState.OnLate;
        }

        return nextRemain;
    }

    private void Initialize()
    {
        RhythmDelay = 60 / Bpm;
        JudgeOffset = judgeOffsetRatio * RhythmDelay;
        HalfToEarly = RhythmDelay / 2 - JudgeOffset;
        currentEventState = EventState.OnHalf;
    }
    
    private void RhythmStart(double offset)
    {
        eventActivateTime = Time.realtimeSinceStartupAsDouble + offset + currentEventState switch
        {
            EventState.OnHalf or EventState.OnLate => HalfToEarly,
            EventState.OnEarly or EventState.OnRhythm => JudgeOffset,
            _ => throw new ArgumentOutOfRangeException()
        };
    }

    protected virtual void FixedUpdate()
    {
        if (eventActivateTime > Time.realtimeSinceStartupAsDouble || pauseFlag) return;
        switch (currentEventState)
        {
            case EventState.OnHalf:
                eventActivateTime += HalfToEarly;
                currentEventState++;
                onHalf?.Invoke();
                break;
            case EventState.OnEarly:
                eventActivateTime += JudgeOffset;
                currentEventState++;
                onEarly?.Invoke();
                break;
            case EventState.OnRhythm:
                eventActivateTime += JudgeOffset;
                currentEventState++;
                onRhythm?.Invoke();
                break;
            case EventState.OnLate:
                eventActivateTime += HalfToEarly;
                currentEventState = EventState.OnHalf;
                onLate?.Invoke();
                break;
        }
    }

    protected virtual void Start()
    {
        pauseFlag = false;
        Initialize();
        RhythmStart(StartOffset);
    }
    
    protected void PauseRhythm(bool isPaused)
    {
        pauseFlag = isPaused;
        if (isPaused) pausedTime = eventActivateTime - Time.realtimeSinceStartupAsDouble;
        else RhythmStart(pausedTime);
    }
}
