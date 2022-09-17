using System.Collections.Generic;
using System;
using JetBrains.Annotations;

public enum e_State
{
    Idle,Attack,Move,Skill
}

/// <summary>
/// e_State와 실제 State객체와의 관계를 나타냅니다.
/// </summary>
public static class StateDictionary
{
    private static Dictionary<e_State, State> Dic_States = new(){
        {e_State.Idle, new IdleState()},
        {e_State.Move, new MoveState()},
        {e_State.Attack, new AttackState()},
        {e_State.Skill, new SkillState()},
    };

    [CanBeNull]
    public static State GetState(e_State e_state)
    {
        return Dic_States.ContainsKey(e_state) ? Dic_States[e_state] : null;
    }

    public static bool ContainsState(e_State e_state)
    {
        return Dic_States.ContainsKey(e_state);
    }
}