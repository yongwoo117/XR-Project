using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SFXProfile))]
public class SFXProfileEditor : Editor
{
    private SerializedProperty dictionary;
    private void OnEnable()
    {
        dictionary = serializedObject.FindProperty("SFXDictionary");
    }

    public override void OnInspectorGUI()
    {
        if(target is not SFXProfile profile) return;
        EditorGUILayout.PropertyField(dictionary, new GUIContent("SFX 설정"));
        serializedObject.ApplyModifiedProperties();
        EditorUtility.SetDirty(profile);
    }
}