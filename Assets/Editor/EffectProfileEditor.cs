using UnityEditor;
using UnityEngine;


[CustomEditor(typeof(EffectProfile))]
public class EffeProfileEdtior : Editor
{
    SerializedProperty m_Dic;
    void OnEnable()
    {
        m_Dic = serializedObject.FindProperty("Dic_Effect");
    }

    public override void OnInspectorGUI()
    {
        EffectProfile epd = (EffectProfile)target;

        EditorGUILayout.PropertyField(m_Dic, new GUIContent("이펙트 리시트"));
        
        serializedObject.ApplyModifiedProperties();
        EditorUtility.SetDirty(epd);
    }

}