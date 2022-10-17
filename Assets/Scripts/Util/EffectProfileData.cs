using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class EffectProfileData : ObjectPooling<EffectCallBack>
{
    public static EffectProfileData Instance { get; private set; }

    protected virtual void Awake()
    {
        if (Instance != null)
        {
            Debug.Log($"{typeof(EffectProfileData)}is already exist!!");
            Destroy(gameObject);
            return;
        }
        Instance = GetComponent<EffectProfileData>();

    }

}