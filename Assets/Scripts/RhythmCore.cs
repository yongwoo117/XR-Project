using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;

public class RhythmCore : Singleton<RhythmCore>
{
    [SerializeField] private double bpm;
    [SerializeField] private float judgeOffset;
    
    private double startTime;
    private double rhythmDelay;
    private double bpmCheck;

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
    /// BPM 발생 시 Callback하는 이벤트
    /// </summary>
    public UnityEvent onBPMStart;

    /// <summary>
    /// BPM 발생 후 Callback하는 이벤트
    /// </summary>
    public UnityEvent onBPMEnd;

    /// <summary>
    /// 비트를 위한 기본 오디오 소스
    /// </summary>
    private AudioSource audioSource;

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
            onBpmChanged?.Invoke();
        }
    }
    
    /// <summary>
    /// 현재 시점을 기준으로 노트를 판정합니다.
    /// </summary>
    public bool Judge() => RemainTime < judgeOffset || rhythmDelay - RemainTime < judgeOffset;

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

        //Check BPM & Play Sound
        CheckBPM();

    }

    private void CheckBPM()
    {
        if (bpmCheck >= rhythmDelay)
        {
            bpmCheck = 0d;


            //BPM 출력 및 시작 이벤트 호출
            onBPMStart?.Invoke();
            audioSource?.Play();

            StartCoroutine(WaitBPMSound());
        }
        else
            bpmCheck += Time.deltaTime;
    }

    /// <summary>
    /// BPM 사운드가 끝났을때 이벤트 호출
    /// </summary>
    private IEnumerator WaitBPMSound()
    {
        yield return new WaitUntil(() => audioSource.isPlaying == false);

        onBPMEnd?.Invoke();
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
                    onEarly?.Invoke();
                    currentEventState++;
                    prevTime = FixedRemainTime;
                }
                break;
            case EventState.Right:
                if (FixedRemainTime > prevTime)
                {
                    onRhythm?.Invoke();
                    currentEventState++;
                }
                else
                    prevTime = FixedRemainTime;
                break;
            case EventState.Late:
                if (FixedRemainTime < rhythmDelay - judgeOffset)
                {
                    onLate?.Invoke();
                    currentEventState = EventState.Early;
                }
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();

        onBpmChanged.AddListener(RhythmStart);
        RhythmStart();
    }

    private enum EventState
    {
        Early,
        Right, //TODO: 적절한 다른 이름으로 대체
        Late
    }
}
