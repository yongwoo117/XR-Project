
using UnityEngine;

namespace Player.State
{
    public class MoveState : PlayerState
    {
        public override void Enter()
        {
            Debug.Log("Move Enter");
            StateMachine.ChangeState(e_PlayerState.Dash);
        }
    }
}
