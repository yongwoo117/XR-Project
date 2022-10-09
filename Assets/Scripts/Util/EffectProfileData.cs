using System.Collections;
using System.Collections.Generic;
using UnityEngine;



/// <summary>
/// 사용 하는 모든 이펙트들을 관리하는 매니저 오브젝트 풀링을 관리함
/// 사용할 이펙트들은 각 클래스에서 Pop을 통해 호출
/// 다쓴 이펙트들은 콜백을 통해 Push
/// </summary>
public class EffectProfileData : Singleton<EffectProfileData>
{
    [SerializeField]private EffectProfile effectProfil;

    public int effectPoolIndex;

    [SerializeField]private Dictionary<GameObject, Stack<GameObject>> Dic_EffectPool = new Dictionary<GameObject, Stack<GameObject>>();
    [SerializeField]private Dictionary<GameObject, Stack<GameObject>> Dic_EffectCloneData = new Dictionary<GameObject, Stack<GameObject>>();

    protected override void Awake()
    {
        base.Awake();
        if (effectProfil == null)
            effectProfil = Resources.Load<EffectProfile>("ScriptableObject/EffectProfile");
        CreateEffectClone();
    }

    //오브젝트 풀링
    private void CreateEffectClone()
    {
        foreach (var obj in effectProfil.Dic_Effect)
        {
            if (!Dic_EffectPool.ContainsKey(obj.Value))
            {

                Stack<GameObject> clonePool = new Stack<GameObject>();

                for (int i = 0; i < effectPoolIndex; i++)
                {
                    GameObject clone = Instantiate(obj.Value, transform);
                    clone.SetActive(false);
                    clone.AddComponent<EffectCallBack>();
                    clonePool.Push(clone);

                    Dic_EffectCloneData.Add(clone, clonePool);
                }

                Dic_EffectPool.Add(obj.Value, clonePool);
            }
        }
    }


    //키 값을 통해 해당하는 오브젝트가 있을 경우 Pop 풀링된 오브젝트보다 많을 경우 재생성
    public GameObject PopEffect(string key)
    {
        GameObject clone=null;

        if (!effectProfil.Dic_Effect.TryGetValue(key, out var effect))
        {
            Debug.LogError("존재 하지 않는 이펙트 키 호출" + key);
            return null;
        }


        if (Dic_EffectPool[effect].Count > 0)
            clone = Dic_EffectPool[effect].Pop();
        else
        {
            clone = Instantiate(effectProfil.Dic_Effect[key]);
            clone.AddComponent<EffectCallBack>();

            Dic_EffectPool[effect].Push(clone);
            Dic_EffectCloneData.Add(clone, Dic_EffectPool[effect]);
        }

        clone.transform.parent = null;
        clone.SetActive(true);

        return clone;
    }

    //사용된 오브젝트들은 Push해서 다시 넣어줌 (콜백)
    public void PushEffect(GameObject obj)
    {
        if (!Dic_EffectCloneData.TryGetValue(obj, out var pool))
        {
            Destroy(obj);
            return;
        }

        obj.SetActive(false);
        obj.transform.parent = transform;

        pool.Push(obj);
    }
}