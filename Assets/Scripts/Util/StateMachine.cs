using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// FSM을 추상화한 컴포넌트입니다.
/// </summary>
/// <typeparam name="T1">State를 구분할 enum 형식입니다.</typeparam>
/// <typeparam name="T2">IState를 상속하는 State입니다.</typeparam>
public abstract class StateMachine<T1, T2, T3> : HealthModule where T1 : Enum
    where T2 : IState<T1, T2, T3>
    where T3 : StateMachine<T1, T2, T3>
{
    [SerializeField] protected List<T1> List_e_States;
    protected T2 currentState;
    protected Dictionary<T1, T2> Dic_States = new();

    protected abstract T1 StartState { get; }

    /// <summary>
    /// 오버라이딩하는 경우 하위 클래스에서 반드시 base.Awake()를 호출해야 합니다.
    /// </summary>
    protected virtual void Awake()
    {
        if (List_e_States.Count <= 0) return;

        //Inspector에서 받아온 상태들을 추가합니다.
        foreach (var e_state in List_e_States)
        {
            //이미 추가된 키값이면 넘깁니다.
            if (Dic_States.ContainsKey(e_state)) continue;

            var type = e_state.GetStateType();

            //IState가 아닌 경우 넘깁니다.
            if (type is null) continue;
            if (!type.IsSubclassOf(typeof(T2))) continue;

            var state = (T2)Activator.CreateInstance(type);
            OnBeforeStateInitialize(state);
            state.Initialize();
            Dic_States.Add(e_state, state);
        }
    }

    protected override void OnEnable()
    {
        base.OnEnable();
        //기본 상태를 Idle로 지정합니다.
        if (Dic_States.ContainsKey(StartState))
            ChangeState(StartState);
        
        onDead.AddListener(OnDead);
        onHealthChanged.AddListener(OnHealthChanged);
        onHealthRatioChanged.AddListener(OnHealthRatioChanged);
        onDamaged.AddListener(OnDamaged);
    }

    protected virtual void OnDead() => currentState.Dead();
    private void OnHealthChanged(float value) => currentState.HealthChanged(value);
    private void OnHealthRatioChanged(float value) => currentState.HealthRatioChanged(value);
    protected override bool AcceptHealthChange(ref float value) => currentState.AcceptHealthChange(ref value);
    protected virtual void OnDamaged(float value) => currentState.OnDamaged(value);
    protected virtual void Update() => currentState.LogicUpdate();
    protected virtual void FixedUpdate() => currentState.PhysicsUpdate();
    protected virtual void OnDrawGizmos() => currentState?.OnDrawGizmos();
    protected virtual void OnDestroy() => currentState?.Release();

    protected virtual void OnBeforeStateInitialize(T2 state)
    {
        state.StateMachine = (T3)this;
    }

    protected virtual void OnDisable()
    {
        onDead.RemoveListener(OnDead);
        onHealthChanged.RemoveListener(OnHealthChanged);
        onHealthRatioChanged.RemoveListener(OnHealthRatioChanged);
        onDamaged.RemoveListener(OnDamaged);
    }

    /// <summary>
    /// 캐릭터의 상태를 변경합니다. 이 과정에서 Exit()와 Enter()가 Callback됩니다.
    /// </summary>
    /// <param name="e_state">변경할 상태입니다. 기존과 같은 상태인 경우 무시됩니다.</param>
    public void ChangeState(T1 e_state)
    {
        //캐릭터가 해당 상태를 보유하지 않은 경우
        if (!Dic_States.ContainsKey(e_state)) return;

        var state = Dic_States[e_state];

        //같은 상태로의 변경인 경우
        //if (currentState?.GetType() == state.GetType()) return;

        currentState?.Exit();
        currentState = state;
        currentState?.Enter();
    }
}
