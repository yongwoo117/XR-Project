using System;
using System.Collections;
using UnityEngine;

namespace Enemy.Profile
{
    [CreateAssetMenu(fileName = "EnemyProfile", menuName = "EnemyProfile", order = 2)]
    [Serializable]
    public class EnemyProfile : ScriptableObject
    {
        public float f_CheckRange; //Idle->Chase로 넘어가기 위한 범위
        public float f_AttackRange; //공격 범위
        public float f_ChaseRange; //추격 범위
        public float f_ChaseSpeed; //추격 속도

        public int i_ChaseRhythmCount; //추격 박자
        public int i_Hp;
        
    }
}
