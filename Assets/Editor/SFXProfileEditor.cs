using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(SFXProfile))]
public class SFXProfileEditor : Editor
{
    //TODO: 여기 있는 코드는 Enemy와 Player로 옮기고 이 클래스는 삭제합니다.
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