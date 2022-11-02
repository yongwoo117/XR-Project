using System;
using UnityEngine;

public class SpawnCallback : MonoBehaviour
{
    public Action<GameObject> ReturnAction { private get; set; }
    public void Return() => ReturnAction(gameObject);
}