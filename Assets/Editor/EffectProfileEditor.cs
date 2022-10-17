using UnityEditor;
using UnityEngine;


[CustomEditor(typeof(PoolingData))]
public class PoolingDataEdtior : Editor
{
    SerializedProperty m_Dic;
    void OnEnable()
    {
        m_Dic = serializedObject.FindProperty("Dic_Pooling");
    }

    public override void OnInspectorGUI()
    {
        PoolingData epd = (PoolingData)target;

        EditorGUILayout.PropertyField(m_Dic, new GUIContent("풀링 리시트"));
        
        serializedObject.ApplyModifiedProperties();
        EditorUtility.SetDirty(epd);
    }

}