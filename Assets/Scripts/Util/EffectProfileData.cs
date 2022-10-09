using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectProfileData : Singleton<EffectProfileData>
{
    public EffectProfile effectProfil;

    public int effectPoolIndex;
    public Dictionary<GameObject, Stack<GameObject>> Dic_EffectPool = new Dictionary<GameObject, Stack<GameObject>>();
    public Dictionary<GameObject, Stack<GameObject>> Dic_EffectCloneData = new Dictionary<GameObject, Stack<GameObject>>();

    private void Awake()
    {
        if (effectProfil == null)
            effectProfil = Resources.Load<EffectProfile>("ScriptableObj/Util/Scr_EffectProfil");

    }

    public GameObject PopEffect(string key)
    {
        GameObject clone;

        if (!effectProfil.Dic_Effect.TryGetValue(key, out var effect))
        {
            Debug.LogError("존재 하지 않는 이펙트 키 호출" + key);
            return null;
        }

        if (Dic_EffectPool[effect].Count > 0)
        {
              clone = Dic_EffectPool[effect].Pop();
        }
        else
        {
            clone = Instantiate(effectProfil.Dic_Effect[key]);
            clone.AddComponent<EffectCallBack>();

            Dic_EffectPool[effect].Push(clone);
            Dic_EffectCloneData.Add(clone, Dic_EffectPool[effect]);
        }


        if(clone==null)
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