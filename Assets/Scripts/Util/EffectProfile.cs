using UnityEngine;

using SerializableDictionary;


[CreateAssetMenu(fileName = "EffectScriptableObject", menuName = "EffectScriptableObject", order = 4)]
public class EffectProfile : ScriptableObject
{
    public SerializableDictionary<string, GameObject> Dic_Effect = new SerializableDictionary<string, GameObject>();
}
