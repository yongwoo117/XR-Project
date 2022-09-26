using System.Collections.Generic;
using UnityEngine;

public abstract class StateMachine : MonoBehaviour
{
    [SerializeField] protected List<e_State> List_e_States;
    protected State currentState;
    protected Dictionary<e_State,State> Dic_States = new();


    private void Awake()
    {
        if (List_e_States.Count <= 0) return;
        
        //Inspector에서 받아온 상태들을 추가합니다.
        foreach (var e_state in List_e_States)
        {
            if (StateDictionary.ContainsState(e_state) && !Dic_States.ContainsKey(e_state))
            {
                State state = StateDictionary.GetState(e_state);
                state.SetMachine(this);
                Dic_States.Add(e_state, state);
            }
        }

        //기본 상태를 Idle로 지정합니다.
        if(Dic_States.ContainsKey(e_State.Idle))
            ChangeState(Dic_States[e_State.Idle]);

    }
    
    /// <summary>
    /// 캐릭터의 상태를 변경합니다. 이 과정에서 Exit()와 Enter()가 Callback됩니다.
    /// </summary>
    /// <param name="state">변경할 상태입니다. 기존과 같은 상태인 경우 무시됩니다.</param>
    public virtual void ChangeState(State state)
    {
        //같은 상태로의 변경인 경우
        if(currentState?.GetType() == state.GetType()) return;
        
        currentState?.Exit();
        currentState = state;
        currentState?.Enter();
    }

    /// <summary>
    /// 캐릭터의 상태를 변경합니다. 이 과정에서 Exit()와 Enter()가 Callback됩니다.
    /// </summary>
    /// <param name="e_state">변경할 상태입니다. 기존과 같은 상태인 경우 무시됩니다.</param>
    public virtual void ChangeState(e_State e_state)
    {
        //캐릭터가 해당 상태를 보유하지 않은 경우
        if (!Dic_States.ContainsKey(e_state)) return;
        
        ChangeState(Dic_States[e_state]);
    }
}
