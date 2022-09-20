using System;
using UnityEngine;


[CreateAssetMenu(fileName = "PlayerProfil", menuName = "PlayerProfil", order = 1)]

/// <summary>
/// Player의 정보를 저장하고 있는 ScripatbleObject입니다.
/// </summary>
[Serializable]
public class PlayerProfil : ScriptableObject
{
    public AnimationCurve dashPhyscisGrph; //대쉬 물리 그래프
    public float f_dashTime; //대쉬 시간
    public float f_dashDistace; //대쉬 거리
}
