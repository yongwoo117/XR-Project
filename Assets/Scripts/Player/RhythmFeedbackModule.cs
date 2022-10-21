using UnityEngine;

public enum FeedbackState
{
    Idle, //일반 이펙트
    Direction //화살표 이펙트
}

public struct FeedbackStruct
{
    public GameObject effect;
    public SpriteRenderer sprite;
    public MaterialPropertyBlock material;
    public float? activationTime;
    public float? targetTime;

    public FeedbackStruct(GameObject effect)
    {
        this.effect = effect;
        sprite = effect.GetComponent<SpriteRenderer>();
        material = new MaterialPropertyBlock();
        activationTime = targetTime = null;
    }

    public float? EffectValue(float? value = null)
    {
        if (activationTime == null || targetTime == null) return null;
        return Mathf.InverseLerp((float)activationTime, (float)targetTime, value ?? Time.realtimeSinceStartup);
    }

    public void Synchronize(string name = "Fill")
    {
        var effectValue = EffectValue();
        if (effectValue != null)
            material.SetFloat(name, (float)effectValue);
        sprite.SetPropertyBlock(material);
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

    private FeedbackState feedbackState;
    private bool effectFlag;
    private IControl control;
    
    protected virtual void Start()
    {
        idleCircleStruct = new FeedbackStruct(idleEffect);
        idleDirectionStruct = new FeedbackStruct(idleDirectionEffect);
        idleDirectionStruct.material.SetTexture("_MainTex", idleDirectionStruct.sprite.sprite.texture);

        idleDirectionStruct.targetTime = Time.realtimeSinceStartup + (float)RhythmCore.Instance.RemainTime(false);
        idleDirectionStruct.activationTime = idleCircleStruct.targetTime =
            idleDirectionStruct.targetTime - (float)RhythmCore.Instance.JudgeOffset * 2;
        idleCircleStruct.activationTime = idleDirectionStruct.targetTime - (float)RhythmCore.Instance.RhythmDelay;
        
        feedbackState = FeedbackState.Idle;
        effectFlag = false;
        control = GetComponent<IControl>();
    }

    protected override void Update()
    {
        base.Update();
        if (!effectFlag) return;
        switch (feedbackState)
        {
            case FeedbackState.Idle:
                idleCircleStruct.Synchronize();
                idleDirectionStruct.Synchronize();
                RotateIdleDirection();
                break;
            case FeedbackState.Direction:
                break;
        }
    }

    private void RotateIdleDirection()
    {
        if (control.Direction == null) return;
        var direction = (Vector3)control.Direction;
        direction.Normalize();

        var rotation = idleEffect.transform.eulerAngles;
        rotation.y = Mathf.Atan2(direction.z, direction.x) * -Mathf.Rad2Deg;
        idleEffect.transform.eulerAngles = rotation;
    }

    public override void OnRhythmLate()
    {
        base.OnRhythmLate();
        effectFlag = true;
        switch (feedbackState)
        {
            case FeedbackState.Idle:
                idleCircleStruct.activationTime = Time.realtimeSinceStartup;
                idleDirectionStruct.activationTime = idleCircleStruct.targetTime = idleCircleStruct.activationTime +
                    (float)RhythmCore.Instance.RemainTime(earlyLate: true, isFixed: true);
                idleDirectionStruct.targetTime =
                    idleDirectionStruct.activationTime + (float)RhythmCore.Instance.JudgeOffset * 2;
                break;
            case FeedbackState.Direction:
                break;
        }
    }
    
    public void ChangeFeedback(FeedbackState state)
    {
        
    }
}