using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectRotation : MonoBehaviour
{
    [SerializeField] private ParticleSystem[] mainModules;

    [System.Obsolete]
    private void OnEnable()
    {
        for (int i = 0; i < mainModules.Length; i++)
        {
            mainModules[i].startRotation = transform.localEulerAngles.z * Mathf.Deg2Rad;
        }
    }

}
