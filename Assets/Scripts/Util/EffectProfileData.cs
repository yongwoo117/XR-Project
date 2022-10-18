using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEngine;
using UnityEngine.Pool;


/// <summary>
/// 사용 하는 모든 이펙트들을 관리하는 매니저 오브젝트 풀링을 관리함
/// 사용할 이펙트들은 각 클래스에서 Pop을 통해 호출
/// 다쓴 이펙트들은 콜백을 통해 Push
/// </summary>
public class EffectProfileData : Singleton<EffectProfileData>
{
    [SerializeField]private EffectProfile effectProfile;

    public int effectPoolIndex;

    private Dictionary<string, ObjectPool<GameObject>> poolDictionary;

    protected override void Awake()
    {
        base.Awake();
        if (effectProfile == null)
            effectProfile = Resources.Load<EffectProfile>("ScriptableObject/EffectProfile");
        CreateEffectClone();
    }

    //오브젝트 풀링
    private void CreateEffectClone()
    {
        poolDictionary = new Dictionary<string, ObjectPool<GameObject>>();
        foreach (var obj in effectProfile.Dic_Effect)
        {
            var pool = new ObjectPool<GameObject>(
                () => InstantiatePrefab(obj),
                instance => instance.SetActive(true),
                instance => instance.SetActive(false),
                null, true, effectPoolIndex);
            poolDictionary.Add(obj.Key, pool);
        }
    }

    private GameObject InstantiatePrefab(KeyValuePair<string, GameObject> pair)
    {
        var instance = Instantiate(pair.Value);
        instance.AddComponent<EffectCallBack>().ReturnAction = value => PushEffect(pair.Key, value);
        instance.SetActive(false);
        return instance;
    }

    //키 값을 통해 해당하는 오브젝트가 있을 경우 Pop 풀링된 오브젝트보다 많을 경우 재생성
    [CanBeNull]
    public GameObject PopEffect(string key)
    {
        if (poolDictionary.ContainsKey(key)) return poolDictionary[key].Get();
        
        Debug.LogError("존재 하지 않는 이펙트 키 호출" + key);
        return null;
    }

    //사용된 오브젝트들은 Push해서 다시 넣어줌 (콜백)
    private void PushEffect(string key, GameObject obj)
    {
        if (!poolDictionary.ContainsKey(key)) return;
        poolDictionary[key].Release(obj);
    }
}