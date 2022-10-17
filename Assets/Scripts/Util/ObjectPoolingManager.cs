using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Pool;

public class ObjectPoolingManager: Singleton<ObjectPoolingManager> 
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

    protected override void Awake()
    {
        base.Awake();
    }

    public IObjectPool<GameObject> Pool<T>(string key) where T:ObjectPoolingCallBack
    {
        poolkey = key;
        if (m_Pool == null)
        {
            if (poolType == PoolType.Stack)
                m_Pool = new ObjectPool<GameObject>(CreatePooledItem<T>, OnTakeFromPool, OnReturnedToPool, OnDestroyPoolObject, collectionChecks, 10, maxPoolSize);
            else
                m_Pool = new LinkedPool<GameObject>(CreatePooledItem<T>, OnTakeFromPool, OnReturnedToPool, OnDestroyPoolObject, collectionChecks, maxPoolSize);
        }
        return m_Pool;
    }
    GameObject CreatePooledItem<T>() where T:ObjectPoolingCallBack
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