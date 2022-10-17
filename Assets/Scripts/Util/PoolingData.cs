using UnityEngine;

using Serializable.Dictionary;


[CreateAssetMenu(fileName = "PoolingScriptableObject", menuName = "PoolingScriptableObject", order = 4)]
public class PoolingData : ScriptableObject
{
    public SerializableDictionary<string, GameObject> Dic_Pooling = new SerializableDictionary<string, GameObject>();
}
