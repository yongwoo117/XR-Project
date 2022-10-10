using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// FSM을 추상화한 컴포넌트입니다.
/// </summary>
/// <typeparam name="T1">State를 구분할 enum 형식입니다.</typeparam>
/// <typeparam name="T2">IState를 상속하는 State입니다.</typeparam>
/// <typeparam name="T3">받아올 ScriptableObject 형식입니다.</typeparam>
public abstract class StateMachine<T1,T2,T3> : HealthModule<T3> where T1 : Enum where T2 : IState<T1,T2,T3> where T3 : HealthProfile
{
    [SerializeField] private T3 profile; //각 머신들이 사용할 Profile을 받아올수 있게 해주는 변수 추가
    [SerializeField] protected List<T1> List_e_States;
    protected T2 currentState;
    protected Dictionary<T1,T2> Dic_States = new();
    
    protected abstract T1 StartState { get; }
    public override T3 Profile => profile;

    /// <summary>
    /// 오버라이딩하는 경우 하위 클래스에서 반드시 base.Awake()를 호출해야 합니다.
    /// </summary>
    protected override void Awake()
    {
        base.Awake();
        if (List_e_States.Count <= 0) return;
        
        //Inspector에서 받아온 상태들을 추가합니다.
        foreach (var e_state in List_e_States)
        {
            //이미 추가된 키값이면 넘깁니다.
            if (Dic_States.ContainsKey(e_state)) continue;
            
            var type = e_state.GetStateType();
            
            //IState가 아닌 경우 넘깁니다.
            if(type is null) continue;
            if (!type.IsSubclassOf(typeof(T2))) continue;
                
            dynamic state = Activator.CreateInstance(type);
            state.StateMachine = this;
            state.Initialize();
            Dic_States.Add(e_state, (T2)state);
        }

        //기본 상태를 Idle로 지정합니다.
        if(Dic_States.ContainsKey(StartState))
            ChangeState(StartState);
    }

    protected virtual void OnEnable()
    {
        onDead.AddListener(OnDead);
        onHealthChanged.AddListener(OnHealthChanged);
        onHealthRatioChanged.AddListener(OnHealthRatioChanged);
    }

    private void OnDead() => currentState.Dead();
    private void OnHealthChanged(float value) => currentState.HealthChanged(value);
    private void OnHealthRatioChanged(float value) => currentState.HealthRatioChanged(value);
    protected virtual void Update() => currentState.LogicUpdate();
    protected virtual void FixedUpdate() => currentState.PhysicsUpdate();
    protected virtual void OnDrawGizmos() => currentState?.OnDrawGizmos();

    protected virtual void OnDisable()
    {
        onDead.AddListener(OnDead);
        onHealthChanged.AddListener(OnHealthChanged);
        onHealthRatioChanged.AddListener(OnHealthRatioChanged);
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
        if(currentState?.GetType() == state.GetType()) return;
        
        currentState?.Exit();
        currentState = state;
        currentState?.Enter();
    }
}
