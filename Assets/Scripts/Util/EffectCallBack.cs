using System;
using UnityEngine;

public class EffectCallBack : MonoBehaviour
{
    public Action<GameObject> ReturnAction { private get; set; }
    private void OnParticleSystemStopped()
    {
        ReturnAction(gameObject);
    }
}