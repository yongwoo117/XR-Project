using UnityEngine;
using UnityEngine.Events;

public class RhythmCore : Singleton<RhythmCore>
{
    [SerializeField] private double bpm;
    [SerializeField] [Range(0.0f, 0.5f)] private double judgeOffsetRatio;
    [SerializeField] private double startOffset;
    
    private double startTime;
    private EventState? currentEventState;
    private double earlyRemainTime;
    private double earlyFixedRemainTime;
    private double judgeOffset;
    private double judgeOffset2;

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
    /// 다음 리듬까지 남은 시간에 관한 정보를 반환합니다.
    /// </summary>
    /// <param name="earlyLate">true이면 Judge()가 true가 되는 시점, null이면 리듬 시점, false이면 Judge()가 false가 되는 시점까지 남은 시간을 반환합니다.</param>
    /// <param name="isInverse">true를 넘겨서 남은 시간이 아닌 이전 이벤트로부터 지난 시간을 얻을 수 있습니다.</param>
    /// <param name="normalizeOption">true를 넘겨서 BPM에 독립적인 시간 정보를 얻을 수 있습니다.</param>
    /// <param name="isFixed">true를 넘겨서 FixedUpdate()에서 사용하는 시간 정보를 얻을 수 있습니다.</param>
    /// <returns></returns>
    public double RemainTime(bool? earlyLate = null, bool isInverse = false, bool normalizeOption = false,
        bool isFixed = false)
    {
        var time = isFixed ? earlyFixedRemainTime : earlyRemainTime;
        var isBig = time > RhythmDelay;
        time += judgeOffset * earlyLate switch { true => 0, null => 1, false => 2 };
        if (!isBig) time %= RhythmDelay;
        if (isInverse) time = isBig ? 0 : RhythmDelay - time;
        if (normalizeOption) time /= RhythmDelay;
        return time;
    }

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
    /// 판정 범위를 나타냅니다. 이 값 만큼 위, 아래에 범위를 적용하여 노트를 판정합니다.
    /// </summary>
    public double JudgeOffset => judgeOffset;

    /// <summary>
    /// 판정 범위를 노트 간격 시간에 대한 비례로 나타냅니다.
    /// </summary>
    public double JudgeOffsetRatio => judgeOffset / RhythmDelay;

    /// <summary>
    /// earlyRemainTime, earlyFixedRemainTime을 갱신하는 데에 사용되는 수식입니다.
    /// </summary>
    private double RemainFormula
    {
        get
        {
            var difference = Time.realtimeSinceStartupAsDouble - startTime;
            return RhythmDelay - (difference < 0 ? difference : difference % RhythmDelay);
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
    public bool Judge() => currentEventState != EventState.OnEarly;

    private void RhythmStart(double offset)
    {
        RhythmDelay = 60 / Bpm;
        judgeOffset = judgeOffsetRatio * RhythmDelay;
        judgeOffset2 = judgeOffset * 2;
        startTime = Time.realtimeSinceStartupAsDouble + offset;
        currentEventState ??= EventState.OnEarly;
        earlyRemainTime = earlyFixedRemainTime = prevTime = RemainFormula;
    }

    protected virtual void Update()
    {
        //RemainTime Update
        earlyRemainTime = RemainFormula;
    }

    private double prevTime;
    protected virtual void FixedUpdate()
    {
        //FixedRaminTime Update
        earlyFixedRemainTime = RemainFormula;

        //이벤트 콜백을 위한 로직입니다.
        switch (currentEventState)
        {
            case EventState.OnEarly:
                if (earlyFixedRemainTime > prevTime)
                {
                    onEarly?.Invoke();
                    currentEventState++;
                }
                else
                    prevTime = earlyFixedRemainTime;
                break;
            case EventState.OnRhythm:
                if (earlyFixedRemainTime < RhythmDelay - judgeOffset)
                {
                    onRhythm?.Invoke();
                    currentEventState++;
                }
                break;
            case EventState.OnLate:
                if (earlyFixedRemainTime < RhythmDelay - judgeOffset2)
                {
                    onLate?.Invoke();
                    currentEventState = EventState.OnEarly;
                    prevTime = earlyFixedRemainTime;
                }
                break;
        }
    }

    protected virtual void Start()
    {
        RhythmStart(startOffset);
    }

    private double pausedTime;
    protected void PauseRhythm(bool isPaused)
    {
        if (isPaused)
            pausedTime = RemainFormula;
        else
            RhythmStart(pausedTime - RhythmDelay);
    }

    private enum EventState
    {
        OnEarly,
        OnRhythm,
        OnLate
    }
}
