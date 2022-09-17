using System;
using UnityEngine;
using UnityEngine.Events;

public class RhythmCore : Singleton<RhythmCore>
{
    [SerializeField] private double bpm;
    [SerializeField] private float judgeOffset;
    
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
    /// 분당 노트의 출현 횟수를 의미합니다.
    /// </summary>
    public double Bpm
    {
        get => bpm;
        set
        {
            bpm = value;
            onBpmChanged.Invoke();
        }
    }
    
    /// <summary>
    /// 현재 시점을 기준으로 노트를 판정합니다.
    /// </summary>
    public bool Judge()
    {
        if (RemainTime < judgeOffset)
            return true;
        return rhythmDelay - RemainTime < judgeOffset;
    }
    
    private void RhythmStart()
    {
        rhythmDelay = 60 / Bpm;
        startTime = Time.realtimeSinceStartupAsDouble - rhythmDelay / 2;
        currentEventState = EventState.Early;
    }

    private void Update()
    {
        //RemainTime Update
        RemainTime = rhythmDelay - (Time.realtimeSinceStartupAsDouble - startTime) % rhythmDelay;
    }

    private double prevTime;
    private void FixedUpdate()
    {
        //FixedRaminTime Update
        FixedRemainTime = rhythmDelay - (Time.realtimeSinceStartupAsDouble - startTime) % rhythmDelay;

        //이벤트 콜백을 위한 로직입니다.
        switch (currentEventState)
        {
            case EventState.Early:
                if (FixedRemainTime < judgeOffset)
                {
                    onEarly.Invoke();
                    currentEventState++;
                    prevTime = FixedRemainTime;
                }
                break;
            case EventState.Right:
                if (FixedRemainTime > prevTime)
                {
                    onRhythm.Invoke();
                    currentEventState++;
                }
                else
                    prevTime = FixedRemainTime;
                break;
            case EventState.Late:
                if (FixedRemainTime < rhythmDelay - judgeOffset)
                {
                    onLate.Invoke();
                    currentEventState++;
                }
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    private void Start()
    {
        onBpmChanged.AddListener(RhythmStart);
        RhythmStart();
    }

    private enum EventState
    {
        Early,
        Right,
        Late
    }
}
