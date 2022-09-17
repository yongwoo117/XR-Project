using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Singleton<T> : MonoBehaviour
{
    public static T Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.Log($"{typeof(T)}is already exist!!");
            Destroy(gameObject);
            return;
        }
        Instance = GetComponent<T>();
    }
}
