using System;
using FMODUnity;
using Serializable.Dictionary;
using UnityEngine;

[CreateAssetMenu(menuName = "SFX Profile", fileName = "SFX Profile", order = 10)]
[Serializable]
public class SFXProfile : ScriptableObject
{
    //TODO: Combat 브랜치에서 HealthProfile을 삭제했으므로 상속 문제가 없습니다. 따라서 Enemy, Player가 이 클래스를 상속하도록 해줍니다.
    public SerializableDictionary<SFXType, EventReference> SFXDictionary = new();
}