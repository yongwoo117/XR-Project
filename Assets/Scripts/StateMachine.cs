using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public abstract class StateMachine : MonoBehaviour
{
    [SerializeField] private List<Object> states;
    private State currentState;
    private Dictionary<string,State> Dic_States = new Dictionary<string, State>();

    private void Start()
    {
        if (states.Count > 0)
        {
            foreach (var obj in states)
            {
                Debug.Log(obj.GetType().ToString());
                if (StateDictionary.Dic_States.ContainsKey(obj.GetType()))
                {
                    State state = StateDictionary.Dic_States[obj.GetType()];
                    state.SetMachine(this);
                    Dic_States.Add(obj.GetType().ToString(), state);
                }
            }

            if(Dic_States.ContainsKey("IdleState"))
                ChangeState(Dic_States["IdleState"]);
        }
            
    }
    
    public virtual void ChangeState(State state)
    {
        currentState?.Exit();
        currentState = state;
        currentState?.Enter();
    }

    public virtual void ChangeState(string name)
    {
        if (Dic_States.ContainsKey(name))
        {
            State state = Dic_States[name];

            currentState?.Exit();
            currentState = state;
            currentState?.Enter();
        }
    }

}
