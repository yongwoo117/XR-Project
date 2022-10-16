using System;
using UnityEngine;
using UnityEngine.Events;

public class RhythmCore : Singleton<RhythmCore>
{
    [SerializeField] private double bpm;
    [SerializeField] private float judgeOffset;
    [SerializeField] private float startOffset;
    
    private double startTime;
    private double rhythmDelay;
    private EventState currentEventState;

    /// <summary>
    /// Bpm이 변경되면 Callback됩니다.
    /// </summary>
    public UnityEvent onBpmChanged;
    
    /// <summary>
    /// 노트를 친 것으로 판정이 가능해지는 시점에 Callback됩니다.
    /// </summary>
    public UnityEvent onEarly;
    
    /// <summary>
    /// 노트가 목표로 하던 아주 정확한 시점에 Callback됩니다.
    /// </summary>
    public UnityEvent onRhythm;
    
    /// <summary>
    /// 노트를 놓쳤다고 판정이 가능해지는 시점에 Callback됩니다.
    /// </summary>
    public UnityEvent onLate;
    
    /// <summary>
    /// 다음 노트까지 남은 시간입니다.
    /// </summary>
    public double RemainTime
    {
        get;
        private set;
    }

    /// <summary>
    /// 다음 노트까지 남은 시간입니다. fixedUpdate()에서 사용합니다.
    /// </summary>
    public double FixedRemainTime
    {
        get;
        private set;
    }

    /// <summary>
    /// RhythmCore가 시작하는 시점을 초단위로 조정합니다. 음수면 더 늦게 시작되며, 양수면 더 빨리 시작됩니다.
    /// </summary>
    public float StartOffset
    {
        get => startOffset;
        set => startOffset = value;
    }

    /// <summary>
    /// RemainTime, FixedRemainTime을 갱신하는 데에 사용되는 수식입니다.
    /// </summary>
    private double RemainFormula
    {
        get
        {
            var difference = Time.realtimeSinceStartupAsDouble - startTime;
            return difference < 0 ? rhythmDelay - difference : rhythmDelay - (difference % rhythmDelay);
        }
    }

    /// <summary>
    /// 분당 노트의 출현 횟수를 의미합니다.
    /// </summary>
    public double Bpm
    {
        get => bpm;
        set
        {
            bpm = value;
            RhythmStart(0);
            onBpmChanged?.Invoke();
        }
    }
    
    /// <summary>
    /// 현재 시점을 기준으로 노트를 판정합니다.
    /// </summary>
    public bool Judge() => RemainTime < judgeOffset || rhythmDelay - RemainTime < judgeOffset;

    private void RhythmStart(float offset)
    {
        rhythmDelay = 60 / Bpm;
        startTime = Time.realtimeSinceStartupAsDouble + offset;
        currentEventState = EventState.OnEarly;
    }

    private void Update()
    {
        //RemainTime Update
        RemainTime = RemainFormula;
    }

    private double prevTime;
    private void FixedUpdate()
    {
        //FixedRaminTime Update
        FixedRemainTime = RemainFormula;

        //이벤트 콜백을 위한 로직입니다.
        switch (currentEventState)
        {
            case EventState.OnEarly:
                if (FixedRemainTime < judgeOffset)
                {
                    onEarly?.Invoke();
                    currentEventState++;
                    prevTime = FixedRemainTime;
                }
                break;
            case EventState.OnRhythm:
                if (FixedRemainTime > prevTime)
                {
                    onRhythm?.Invoke();
                    currentEventState++;
                }
                else
                    prevTime = FixedRemainTime;
                break;
            case EventState.OnLate:
                if (FixedRemainTime < rhythmDelay - judgeOffset)
                {
                    onLate?.Invoke();
                    currentEventState = EventState.OnEarly;
                }
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    private void Start()
    {
        RhythmStart(startOffset);
    }

    private enum EventState
    {
        OnEarly,
        OnRhythm,
        OnLate
    }
}
