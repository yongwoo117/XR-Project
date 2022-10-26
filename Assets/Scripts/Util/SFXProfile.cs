using System;
using FMODUnity;
using Serializable.Dictionary;
using UnityEngine;

[CreateAssetMenu(menuName = "SFX Profile", fileName = "SFX Profile", order = 10)]
[Serializable]
public class SFXProfile : ScriptableObject
{
    public SerializableDictionary<SFXType, EventReference> SFXDictionary = new();
}