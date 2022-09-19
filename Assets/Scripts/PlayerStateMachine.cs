using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerStateMachine : StateMachine
{
    public void OnPrimaryInteraction(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            Debug.Log("Primary!");
        }
    }

    public void OnSecondaryInteraction(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            Debug.Log("Secondary!");
        }
    }
}