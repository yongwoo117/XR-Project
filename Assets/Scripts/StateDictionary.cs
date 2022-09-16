using System.Collections.Generic;
using System;
public static class StateDictionary
{
    public static Dictionary<Type, State> Dic_States = new Dictionary<Type, State>(){
        {typeof(IdleState), new IdleState()},
        {typeof(MoveState), new MoveState()},
        {typeof(AttackState), new AttackState()},
        {typeof(SkillState), new SkillState()},
    };
}