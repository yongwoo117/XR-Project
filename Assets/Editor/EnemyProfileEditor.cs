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

            GUILayout.Space(15);

            ep.f_AttackRange = EditorGUILayout.FloatField("공격 범위", ep.f_AttackRange);
            ep.f_ChaseRange = EditorGUILayout.FloatField("추격 범위", ep.f_ChaseRange);
            ep.f_CheckRange = EditorGUILayout.FloatField("탐색 범위", ep.f_CheckRange);

            EditorUtility.SetDirty(target);
        }
    }
}