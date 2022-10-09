using System;
using UnityEngine;

namespace Enemy.State
{
    public class DieState : EnemyState
    {
        public override void Enter()
        {


            StateMachine.gameObject.SetActive(false);
        }
    }
}