using UnityEngine;
using Serializable.Dictionary;
using Enemy.Profile;

[CreateAssetMenu(fileName = "EnemySpawnScriptableObject", menuName = "EnemySpawnScriptableObject", order = 5)]
public class EnemySpawnProfile : ScriptableObject
{
    public SerializableDictionary<e_EnemyType, GameObject> Dic_Spawn = new SerializableDictionary<e_EnemyType, GameObject>();
}