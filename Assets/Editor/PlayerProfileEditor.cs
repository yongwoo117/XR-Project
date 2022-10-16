using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(PlayerProfile))]
public class PlayerProfileEditor : Editor
{
    public override void OnInspectorGUI()
    {
        PlayerProfile pmf = (PlayerProfile)target;

        GUILayout.Space(15);

        pmf.dashPhysicsGraph = EditorGUILayout.CurveField("대쉬 물리 그래프", pmf.dashPhysicsGraph);
        pmf.f_dashDistance = EditorGUILayout.FloatField("대쉬 최대 거리", pmf.f_dashDistance);
        pmf.f_dashTime = EditorGUILayout.FloatField("대쉬 이동 시간", pmf.f_dashTime);
        pmf.f_cutTime = EditorGUILayout.FloatField("베기 모션 시간", pmf.f_cutTime);
        pmf.i_cutCount = EditorGUILayout.IntField("연속 베기 횟수 제한", pmf.i_cutCount);
        pmf.v3_dashRange = EditorGUILayout.Vector3Field("대쉬 공격 범위", pmf.v3_dashRange);
        pmf.f_maximumHealth = EditorGUILayout.FloatField("최대 체력", pmf.f_maximumHealth);

        EditorUtility.SetDirty(target);
    }
}
