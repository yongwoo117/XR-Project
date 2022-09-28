using System.Collections.Generic;
using JetBrains.Annotations;

public enum e_State
{
    Idle,Dash,Move,Cut
}

public enum e_EnemyState
{
    Idle, Move
}

public interface IStateDictionary<T1,T2>
{
    public T2 GetState(T1 state);
    public bool ContainsState(T1 state);
}

/// <summary>
/// e_State와 실제 State객체와의 관계를 나타냅니다.
/// </summary>
public class PlayerStateDictionary : IStateDictionary<e_State,State>
{
    private static Dictionary<e_State, State> Dic_States = new(){
        {e_State.Idle, new IdleState()},
        {e_State.Move, new MoveState()},
        {e_State.Dash, new DashState()},
        {e_State.Cut, new CutState()},
    };

    [CanBeNull]
    public State GetState(e_State e_state) => Dic_States.ContainsKey(e_state) ? Dic_States[e_state] : null;
    public bool ContainsState(e_State e_state) => Dic_States.ContainsKey(e_state);
}

public class EnemyStateDictionary : IStateDictionary<e_EnemyState, State>
{
    private static Dictionary<e_EnemyState, State> Dic_States = new()
    {
        { e_EnemyState.Idle, new IdleState() },
        { e_EnemyState.Move, new MoveState() },
    };

    [CanBeNull]
    public State GetState(e_EnemyState e_state) => Dic_States.ContainsKey(e_state) ? Dic_States[e_state] : null;
    public bool ContainsState(e_EnemyState e_state) => Dic_States.ContainsKey(e_state);
}