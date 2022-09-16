using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public abstract class StateMachine : MonoBehaviour
{
    [SerializeField] private List<e_State> List_e_States;
    private State currentState;
    private Dictionary<e_State,State> Dic_States = new Dictionary<e_State, State>();

    private void Start()
    {
        if (List_e_States.Count > 0)
        {
            foreach (var e_state in List_e_States)
            {
                if (StateDictionary.Dic_States.ContainsKey(e_state))
                {
                    State state = StateDictionary.Dic_States[e_state];
                    state.SetMachine(this);
                    Dic_States.Add(e_state, state);
                }
            }

            if(Dic_States.ContainsKey(e_State.Idle))
                ChangeState(Dic_States[e_State.Idle]);
        }
            
    }
    
    public virtual void ChangeState(State state)
    {
        currentState?.Exit();
        currentState = state;
        currentState?.Enter();
    }

    public virtual void ChangeState(e_State e_state)
    {
        if (Dic_States.ContainsKey(e_state))
        {
            State state = Dic_States[e_state];

            currentState?.Exit();
            currentState = state;
            currentState?.Enter();
        }
    }

}
