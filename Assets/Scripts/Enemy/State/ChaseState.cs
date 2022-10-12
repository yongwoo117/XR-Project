using System;
using Enemy.Profile;
using UnityEngine;

namespace Enemy.State
{
    public class ChaseState : EnemyState
    {
        //Profile 변수
        private float chaseRange;
        private float chaseSpeed;

        //상태 변수
        private PlayerStateMachine player;

        //Machine 변수
        private Rigidbody rigid;
        private Transform transform;

        public override EnemyProfile Profile
        {
            set
            {
                chaseSpeed = value.f_ChaseSpeed;
                chaseRange = value.f_ChaseRange;
            }
        }

        public override void Initialize()
        {
            rigid = StateMachine.GetComponent<Rigidbody>();
            transform = StateMachine.transform;
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
            Collider[] chaseHit = Physics.OverlapSphere(transform.position,chaseRange,GetLayerMasks.Player);

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
            Gizmos.DrawWireSphere(transform.position, chaseRange);
        }

        private void ApplyPhysics()
        {
            Vector3 Dir = (player.transform.position - transform.position).normalized;
            Dir *= chaseSpeed;
            

            rigid.velocity = new Vector3(Dir.x,0f,Dir.z);
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
        
        public override void HealthChanged(float value)
        {
            StateMachine.ChangeState(e_EnemyState.Hit);
        }
    }
}