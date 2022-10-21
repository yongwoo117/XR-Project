using System;
using UnityEngine;

public enum FeedbackState
{
    Idle, //일반 이펙트
    Direction //화살표 이펙트
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
        return Mathf.InverseLerp((float)activationTime, (float)targetTime, value ?? Time.realtimeSinceStartup);
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
                    directionStruct.activationTime = Time.realtimeSinceStartup;
                    directionStruct.targetTime =
                        directionStruct.activationTime + (float)RhythmCore.Instance.RemainTime(true);
                    ActiveToggle(false);
                    effectFlag = true;
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

        control = GetComponent<IControl>();
        EffectState = FeedbackState.Idle;
    }

    protected override void Update()
    {
        base.Update();
        if (!effectFlag) return;
        switch (EffectState)
        {
            case FeedbackState.Idle:
                idleCircleStruct.Synchronize();
                idleDirectionStruct.Synchronize();
                RotateIdle();
                break;
            case FeedbackState.Direction:
                directionStruct.Synchronize();
                RotateDirection();
                break;
        }
    }

    private void RotateIdle()
    {
        if (control.Direction == null) return;
        var direction = (Vector3)control.Direction;
        direction.Normalize();

        var rotation = idleEffect.transform.eulerAngles;
        rotation.y = Mathf.Atan2(direction.z, direction.x) * -Mathf.Rad2Deg;
        idleEffect.transform.eulerAngles = rotation;
    }

    private void RotateDirection()
    {
        if (control.Direction == null) return;
        var direction = (Vector3)control.Direction;
        if (directionStruct.renderer is LineRenderer render)
            render.SetPosition(1, new Vector3(direction.x, direction.z, 0));
    }

    public override void OnRhythmLate()
    {
        base.OnRhythmLate();
        switch (EffectState)
        {
            case FeedbackState.Idle:
                idleCircleStruct.activationTime = Time.realtimeSinceStartup;
                idleDirectionStruct.activationTime = idleCircleStruct.targetTime = idleCircleStruct.activationTime +
                    (float)RhythmCore.Instance.RemainTime(earlyLate: true, isFixed: true);
                idleDirectionStruct.targetTime =
                    idleDirectionStruct.activationTime + (float)RhythmCore.Instance.JudgeOffset * 2;
                effectFlag = true;
                break;
            case FeedbackState.Direction:
                break;
        }
    }
}