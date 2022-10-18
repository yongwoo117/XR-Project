using System;
using JetBrains.Annotations;

public enum e_PlayerState
{
    Idle,Dash,Move,Cut
}

public enum e_EnemyState
{
    Idle, Chase, Die, Hit
}

public static class EnumExtensions
{
    [CanBeNull]
    public static Type GetStateType(this Enum value) =>
        value switch
        {
            //Player
            e_PlayerState.Idle => typeof(Player.State.IdleState),
            e_PlayerState.Dash => typeof(Player.State.DashState),
            e_PlayerState.Cut => typeof(Player.State.CutState),
            e_PlayerState.Move => typeof(Player.State.MoveState),
            
            //Enemy
            e_EnemyState.Idle => typeof(Enemy.State.IdleState),
            e_EnemyState.Chase => typeof(Enemy.State.ChaseState),
            e_EnemyState.Hit => typeof(Enemy.State.HitState),
            e_EnemyState.Die => typeof(Enemy.State.DieState),
            
            _ => null
        };
}