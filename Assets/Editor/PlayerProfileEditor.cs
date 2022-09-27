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
        EditorUtility.SetDirty(target);
    }
}
