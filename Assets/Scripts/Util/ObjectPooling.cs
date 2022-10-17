using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPooling: MonoBehaviour 
{
    [SerializeField] public PoolingData poolingData;

    [SerializeField] private Dictionary<GameObject, Stack<GameObject>> Dic_Pool = new Dictionary<GameObject, Stack<GameObject>>();
    [SerializeField] private Dictionary<GameObject, Stack<GameObject>> Dic_PoolingObj = new Dictionary<GameObject, Stack<GameObject>>();

    public int PoolIndex;
    public Action<GameObject> onCreateObject;

    protected virtual void Start()
    {
        CreateEffectClone();
    }

    //오브젝트 풀링
    protected virtual void CreateEffectClone()
    {
        foreach (var obj in poolingData.Dic_Pooling)
        {
            if (!Dic_Pool.ContainsKey(obj.Value))
            {

                Stack<GameObject> clonePool = new Stack<GameObject>();

                for (int i = 0; i < PoolIndex; i++)
                {
                    GameObject clone = CreateObject(obj.Value);
                    clone.transform.parent = transform;
                    clone.SetActive(false);

                    clonePool.Push(clone);

                    Dic_PoolingObj.Add(clone, clonePool);
                }

                Dic_Pool.Add(obj.Value, clonePool);
            }
        }
    }

    protected virtual GameObject CreateObject(GameObject obj)
    {
        GameObject clone = Instantiate(obj);
        onCreateObject.Invoke(clone);


        return clone;
    }


    //키 값을 통해 해당하는 오브젝트가 있을 경우 Pop 풀링된 오브젝트보다 많을 경우 재생성
    public virtual GameObject PopObject(string key)
    {
        GameObject clone = null;

        if (!poolingData.Dic_Pooling.TryGetValue(key, out var poolData))
        {
            Debug.LogError("존재 하지 않는 이펙트 키 호출" + key);
            return null;
        }


        if (Dic_Pool[poolData].Count > 0)
        {
            clone = Dic_Pool[poolData].Pop();
        }
        else
        {
            clone = CreateObject(poolData);

            Dic_Pool[poolData].Push(clone);
            Dic_PoolingObj.Add(clone, Dic_Pool[poolData]);
        }

        clone.transform.parent = null;
        clone.SetActive(true);

        return clone;
    }

    //사용된 오브젝트들은 Push해서 다시 넣어줌 (콜백)
    public virtual void PushObject(GameObject obj)
    {
        if (!Dic_PoolingObj.TryGetValue(obj, out var pool))
        {
            Destroy(obj);
            return;
        }

        obj.SetActive(false);
        obj.transform.parent = transform;

        pool.Push(obj);
    }
}