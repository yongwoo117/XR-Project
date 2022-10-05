using System;
using UnityEngine;

namespace Enemy.State
{
    public class ChaseState : EnemyState
    {
        //Profile 변수
        float chaseRange;
        float chaseSpeed;
        int rhythmCnt;

        //상태 변수
        PlayerStateMachine player;
        bool isRhythm;
        int rhythmIndex;

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

        public override void PhysicsUpdate()
        {
            if (isRhythm)
                ApplyPhysics();
            else
                rigid.velocity = Vector3.zero;
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
            Vector3 Dir = (player.transform.position - StateMachine.transform.position).normalized;
            Dir *= chaseSpeed;
            

            rigid.velocity = new Vector3(Dir.x,0f,Dir.z);
        }

        private void SetupProfile()
        {
            var profile = StateMachine.Profile;

            chaseSpeed = profile.f_ChaseSpeed;
            chaseRange = profile.f_ChaseRange;
            rhythmCnt = profile.i_ChaseRhythmCount;
        }

        /// <summary>
        /// 상태 변수 초기화
        /// </summary>
        private void Reset()
        {
            rhythmIndex = 1;
            isRhythm = false;
        }
        /// <summary>
        /// RhythmCore 이벤트를 통해 박자 체크
        /// </summary>
        public override void OnRhythm()
        {
            if (!isRhythm)
            {
                if (rhythmIndex == rhythmCnt)
                {
                    rhythmIndex = 1;
                    isRhythm = true;
                }
                else
                    rhythmIndex++;
            }
            else
            {
                isRhythm = false;
            }
        }
    }
}