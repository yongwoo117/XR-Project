using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Pool;

public class ObjectPooling<T>: MonoBehaviour where T:ObjectPoolingCallBack
{
    public enum PoolType
    {
        Stack,
        LinkedList
    }

    public PoolType poolType;
    public PoolingData poolingData;

    public bool collectionChecks = true;
    public int maxPoolSize = 10;

    private string poolkey;

    private IObjectPool<GameObject> m_Pool;

    public IObjectPool<GameObject> Pool(string key)
    {
        poolkey = key;
        if (m_Pool == null)
        {
            if (poolType == PoolType.Stack)
                m_Pool = new ObjectPool<GameObject>(CreatePooledItem, OnTakeFromPool, OnReturnedToPool, OnDestroyPoolObject, collectionChecks, 10, maxPoolSize);
            else
                m_Pool = new LinkedPool<GameObject>(CreatePooledItem, OnTakeFromPool, OnReturnedToPool, OnDestroyPoolObject, collectionChecks, maxPoolSize);
        }
        return m_Pool;
    }
    GameObject CreatePooledItem()
    {
        var go = Instantiate(poolingData.Dic_Pooling[poolkey], transform);

        var returnToPool = go.AddComponent<T>();
        returnToPool.SetPool(m_Pool);


        return go;
    }
    void OnReturnedToPool(GameObject pool)
    {
        pool.SetActive(false);
    }

    void OnTakeFromPool(GameObject pool)
    {
        pool.SetActive(true);
    }


    void OnDestroyPoolObject(GameObject pool)
    {
        Destroy(pool.gameObject);
    }
}