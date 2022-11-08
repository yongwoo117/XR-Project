using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(PlayerProfile))]
public class PlayerProfileEditor : SFXProfileEditor
{
    public override void OnInspectorGUI()
    {
        PlayerProfile pmf = (PlayerProfile)target;

        GUILayout.Space(15);

        pmf.f_maximumHealth = EditorGUILayout.FloatField("최대 체력", pmf.f_maximumHealth);
        pmf.f_standardDamage = EditorGUILayout.FloatField("기준 피해량", pmf.f_standardDamage);
        pmf.i_maximumCombatCombo = EditorGUILayout.IntField("최대 전투 콤보", pmf.i_maximumCombatCombo);

        pmf.f_dashMultiplier = EditorGUILayout.FloatField("대쉬 피해 배율", pmf.f_dashMultiplier);
        pmf.dashPhysicsGraph = EditorGUILayout.CurveField("대쉬 물리 그래프", pmf.dashPhysicsGraph);
        pmf.f_dashDistance = EditorGUILayout.FloatField("대쉬 최대 거리", pmf.f_dashDistance);
        pmf.f_dashTime = EditorGUILayout.FloatField("대쉬 이동 시간", pmf.f_dashTime);

        pmf.f_cutMultipier = EditorGUILayout.FloatField("베기 피해 배율", pmf.f_cutMultipier);
        pmf.f_cutTime = EditorGUILayout.FloatField("베기 모션 시간", pmf.f_cutTime);
        pmf.f_cutRange = EditorGUILayout.FloatField("베기 거리", pmf.f_cutRange);
        pmf.v3_dashRange = EditorGUILayout.Vector3Field("대쉬 공격 범위", pmf.v3_dashRange);
        
        base.OnInspectorGUI();
        EditorUtility.SetDirty(target);
    }
}
