using System;
using UnityEngine;

namespace Enemy.State
{
    public class ChaseState : EnemyState
    {
        //Profile 변수
        float chaseRange;
        float chaseSpeed;

        //상태 변수
        PlayerStateMachine player;

        //Machine 변수
        Rigidbody rigid;

        public override void Initialize()
        {
            SetupProfile();
            rigid = StateMachine.GetComponent<Rigidbody>();
        }

        public override void Enter()
        {
            Reset();
        }

        public override void Exit()
        {
            rigid.velocity = Vector3.zero;
        }

        public override void PhysicsUpdate()
        {
            ApplyPhysics();
        }

        public override void LogicUpdate()
        {
            //추격 범위 안에 들어왔을 경우 추격, 범위 밖일 경우 대기 상태로 변경
            Collider[] chaseHit = Physics.OverlapSphere(StateMachine.transform.position,chaseRange,GetLayerMasks.Player);

            if (chaseHit.Length>0)
            {
                if (player == null)
                    player = chaseHit[0].GetComponent<PlayerStateMachine>();


            }
            else
            {
                StateMachine.ChangeState(e_EnemyState.Idle);
            }
        }

        public override void OnDrawGizmos()
        {
            Gizmos.DrawWireSphere(StateMachine.transform.position, chaseRange);
        }

        private void ApplyPhysics()
        {
            if(player == null) return;
            Vector3 Dir = (player.transform.position - StateMachine.transform.position).normalized;
            Dir *= chaseSpeed;
            

            rigid.velocity = new Vector3(Dir.x,0f,Dir.z);
        }

        private void SetupProfile()
        {
            var profile = StateMachine.Profile;

            chaseSpeed = profile.f_ChaseSpeed;
            chaseRange = profile.f_ChaseRange;
        }

        /// <summary>
        /// 상태 변수 초기화
        /// </summary>
        private void Reset()
        {
        }

        public override void OnRhythm()
        {
         
        }
    }
}