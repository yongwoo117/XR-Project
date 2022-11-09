using System;
using JetBrains.Annotations;

public enum e_PlayerState
{
    Idle, Dash, Ready, Cut, Die, Miss, Hit
}

public enum e_EnemyState
{
    Idle, Chase, Die, Hit, Alert, Attack
}

public enum e_EnemyType
{
    Basic, Speed, Heavy
}

public static class EnumExtensions
{
    [CanBeNull]
    public static Type GetStateType(this Enum value) =>
        value switch
        {
            //Player
            e_PlayerState.Idle => typeof(Player.State.IdleState),
            e_PlayerState.Ready => typeof(Player.State.ReadyState),
            e_PlayerState.Dash => typeof(Player.State.DashState),
            e_PlayerState.Cut => typeof(Player.State.CutState),
            e_PlayerState.Die => typeof(Player.State.DieState),
            e_PlayerState.Miss => typeof(Player.State.MissState),
            e_PlayerState.Hit => typeof(Player.State.HitState),

            //Enemy
            e_EnemyState.Idle => typeof(Enemy.State.IdleState),
            e_EnemyState.Alert => typeof(Enemy.State.AlertState),
            e_EnemyState.Chase => typeof(Enemy.State.ChaseState),
            e_EnemyState.Attack => typeof(Enemy.State.AttackState),
            e_EnemyState.Hit => typeof(Enemy.State.HitState),
            e_EnemyState.Die => typeof(Enemy.State.DieState),
            
            _ => null
        };
}
