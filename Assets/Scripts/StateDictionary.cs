using System.Collections.Generic;
using JetBrains.Annotations;

public enum e_PlayerState
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
public class PlayerStateDictionary : IStateDictionary<e_PlayerState,PlayerState>
{
    private static Dictionary<e_PlayerState, PlayerState> Dic_States = new(){
        {e_PlayerState.Idle, new Player.State.IdleState()},
        {e_PlayerState.Move, new Player.State.MoveState()},
        {e_PlayerState.Dash, new Player.State.DashState()},
        {e_PlayerState.Cut, new Player.State.CutState()},
    };

    [CanBeNull]
    public PlayerState GetState(e_PlayerState ePlayerState) => Dic_States.ContainsKey(ePlayerState) ? Dic_States[ePlayerState] : null;
    public bool ContainsState(e_PlayerState ePlayerState) => Dic_States.ContainsKey(ePlayerState);
}

public class EnemyStateDictionary : IStateDictionary<e_EnemyState, EnemyState>
{
    private static Dictionary<e_EnemyState, EnemyState> Dic_States = new()
    {
        { e_EnemyState.Idle, new Enemy.State.IdleState() },
        { e_EnemyState.Move, new Enemy.State.MoveState() },
    };

    [CanBeNull]
    public EnemyState GetState(e_EnemyState e_state) => Dic_States.ContainsKey(e_state) ? Dic_States[e_state] : null;
    public bool ContainsState(e_EnemyState e_state) => Dic_States.ContainsKey(e_state);
}