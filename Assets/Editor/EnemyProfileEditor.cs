using UnityEditor;
using UnityEngine;

namespace Enemy.Profile
{
    [CustomEditor(typeof(EnemyProfile))]
    public class EnemyProfileEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            EnemyProfile ep = (EnemyProfile)target;

            ep.i_Hp = EditorGUILayout.IntField("적 체력", ep.i_Hp);

            GUILayout.Space(15);

            ep.f_AttackRange = EditorGUILayout.FloatField("공격 범위", ep.f_AttackRange);
            ep.f_ChaseRange = EditorGUILayout.FloatField("추격 범위", ep.f_ChaseRange);
            ep.f_CheckRange = EditorGUILayout.FloatField("탐색 범위", ep.f_CheckRange);

            GUILayout.Space(15);

            ep.i_ChaseRhythmCount = EditorGUILayout.IntField("추격 박자", ep.i_ChaseRhythmCount);
            ep.f_ChaseSpeed = EditorGUILayout.FloatField("추격 속도", ep.f_AttackRange);

            EditorUtility.SetDirty(target);
        }
    }
}