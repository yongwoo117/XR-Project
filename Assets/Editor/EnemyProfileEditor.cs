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

            ep.f_maximumHealth = EditorGUILayout.FloatField("최대 체력", ep.f_maximumHealth);
            ep.f_damage = EditorGUILayout.FloatField("피해량", ep.f_damage);
            ep.f_hitTime = EditorGUILayout.FloatField("피격 시 경직 시간", ep.f_hitTime);
            ep.f_attackTime = EditorGUILayout.FloatField("공격 시 경직 시간", ep.f_attackTime);

            GUILayout.Space(15);

            ep.f_AttackRange = EditorGUILayout.FloatField("공격 범위", ep.f_AttackRange);
            ep.f_ChaseRange = EditorGUILayout.FloatField("추격 범위", ep.f_ChaseRange);
            ep.f_CheckRange = EditorGUILayout.FloatField("탐색 범위", ep.f_CheckRange);

            GUILayout.Space(15);

            ep.f_ChaseSpeed = EditorGUILayout.FloatField("추격 속도", ep.f_ChaseSpeed);

            EditorUtility.SetDirty(target);
        }
    }
}