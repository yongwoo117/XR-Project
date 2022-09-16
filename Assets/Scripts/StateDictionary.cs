using System.Collections.Generic;
using System;

public enum e_State
{
    Idle,Attack,Move,Skill
}
public static class StateDictionary
{
    public static Dictionary<e_State, State> Dic_States = new Dictionary<e_State, State>(){
        {e_State.Idle, new IdleState()},
        {e_State.Move, new MoveState()},
        {e_State.Attack, new AttackState()},
        {e_State.Skill, new SkillState()},
    };
}