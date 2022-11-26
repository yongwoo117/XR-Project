using UnityEngine;

public enum FeedbackState
{
    Idle, //일반 이펙트
    Direction, //화살표 이펙트
    Off
}

public struct FeedbackStruct
{
    public GameObject effect;
    public Renderer renderer;
    public MaterialPropertyBlock material;
    public float? activationTime;
    public float? targetTime;
    
    public FeedbackStruct(GameObject effect)
    {
        this.effect = effect;
        renderer = effect.GetComponent<Renderer>();
        material = new MaterialPropertyBlock();
        activationTime = targetTime = null;
    }

    public float? EffectValue(float? value = null)
    {
        if (activationTime == null || targetTime == null) return null;
        return Mathf.InverseLerp((float)activationTime, (float)targetTime, value ?? Time.time);
    }

    public void Synchronize(string name = "Fill")
    {
        var effectValue = EffectValue();
        if (effectValue != null)
            material.SetFloat(name, (float)effectValue);
        renderer.SetPropertyBlock(material);
    }

    public void Clear(string name = "Fill")
    {
        if (material == null) return;
        material.SetFloat(name, 0);
        renderer.SetPropertyBlock(material);
    }
}

public abstract class RhythmFeedbackModule : RhythmComboModule
{
    [SerializeField] private GameObject idleEffect;
    [SerializeField] private GameObject idleDirectionEffect;
    [SerializeField] private GameObject directionEffect;

    private FeedbackStruct idleCircleStruct;
    private FeedbackStruct idleDirectionStruct;
    private FeedbackStruct directionStruct;

    private FeedbackState effectState;
    private bool effectFlag;
    private IControl control;
    private Vector3 direction;
    private Transform GFX;

    private RhythmCore rhythmCore;
    protected bool isFlip;

    public FeedbackState EffectState
    {
        get => effectState;
        set
        {
            effectState = value;
            switch (effectState)
            {
                case FeedbackState.Idle:
                    ActiveToggle(true);
                    idleCircleStruct.Clear();
                    idleDirectionStruct.Clear();
                    effectFlag = false;
                    break;
                case FeedbackState.Direction:
                    if (rhythmCore.RemainTime(EventState.OnEarly) is not { } remainTime) return;
                    directionStruct.activationTime = Time.time;
                    directionStruct.targetTime =
                        directionStruct.activationTime + (float)remainTime;
                    ActiveToggle(false);
                    effectFlag = true;
                    break;
                case FeedbackState.Off:
                    idleEffect.SetActive(false);
                    idleDirectionEffect.SetActive(false);
                    directionEffect.SetActive(false);
                    break;
            }
        }
    }
    
    private void ActiveToggle(bool idleActive)
    {
        idleEffect.SetActive(idleActive);
        directionEffect.SetActive(!idleActive);
    }
    
    protected virtual void Start()
    {
        idleCircleStruct = new FeedbackStruct(idleEffect);
        idleDirectionStruct = new FeedbackStruct(idleDirectionEffect);
        if (idleDirectionStruct.renderer is SpriteRenderer render)
            idleDirectionStruct.material.SetTexture("_MainTex", render.sprite.texture);
        directionStruct = new FeedbackStruct(directionEffect);

        GFX = transform.GetChild(0);

        rhythmCore = RhythmCore.Instance;
        control = GetComponent<IControl>();
        EffectState = FeedbackState.Idle;
    }

    protected override void Update()
    {
        base.Update();

        if(GameManager.IsPaused||GameManager.IsDialogue) return;
        if (control.Direction is { } dir) direction = dir;
        
        switch (EffectState)
        {
            case FeedbackState.Idle:
                if (effectFlag)
                {
                    idleCircleStruct.Synchronize();
                    idleDirectionStruct.Synchronize();
                }
                RotateIdle();
                break;
            case FeedbackState.Direction:
                if (effectFlag) directionStruct.Synchronize();
                RotateDirection();
                break;
            default:
                return;
        }
        
        FlipToMouseDir();
    }

    private void FlipToMouseDir()
    {
        if (control.Direction == null || !control.IsActive) return;
        Vector3 GFXScale = GFX.transform.localScale;

        isFlip = direction.x > 0;
        GFXScale.x = Mathf.Abs(GFXScale.x) * (isFlip ? -1 : 1);

        GFX.transform.localScale = GFXScale;
    }

    private void RotateIdle()
    {
        Vector3 NormalDir = direction.normalized;
        var rotation = idleEffect.transform.eulerAngles;
        rotation.y = Mathf.Atan2(NormalDir.z, NormalDir.x) * -Mathf.Rad2Deg;
        idleEffect.transform.eulerAngles = rotation;
    }

    private void RotateDirection()
    {
        if (directionStruct.renderer is not LineRenderer render) return;
        render.SetPosition(1, new Vector3(direction.x, direction.z, 0));
    }

    public override void OnRhythmLate()
    {
        base.OnRhythmLate();

        if (EffectState != FeedbackState.Idle) return;
        if (rhythmCore.RemainTime(EventState.OnEarly) is not { } remainTime) return;
        idleCircleStruct.activationTime = Time.time;
        idleDirectionStruct.activationTime = idleCircleStruct.targetTime
            = idleCircleStruct.activationTime + (float)remainTime;
        idleDirectionStruct.targetTime
            = idleDirectionStruct.activationTime + (float)rhythmCore.JudgeOffset * 2;
        effectFlag = true;
    }
}