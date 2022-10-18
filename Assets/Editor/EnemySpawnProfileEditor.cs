using UnityEditor;
using UnityEngine;


[CustomEditor(typeof(EnemySpawnProfile))]
public class EnemySpawnProfileEditor : Editor
{
    SerializedProperty m_Dic;
    void OnEnable()
    {
        m_Dic = serializedObject.FindProperty("Dic_Spawn");
    }

    public override void OnInspectorGUI()
    {
        EnemySpawnProfile epd = (EnemySpawnProfile)target;

        EditorGUILayout.PropertyField(m_Dic, new GUIContent("스폰 리시트"));

        serializedObject.ApplyModifiedProperties();
        EditorUtility.SetDirty(epd);
    }

}