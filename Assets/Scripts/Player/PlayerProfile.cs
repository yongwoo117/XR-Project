using System;
using UnityEngine;

/// <summary>
/// Player의 정보를 저장하고 있는 ScriptableObject입니다.
/// </summary>
[CreateAssetMenu(fileName = "PlayerProfile", menuName = "PlayerProfile", order = 1)]
[Serializable]
public class PlayerProfile : ScriptableObject
{
    public AnimationCurve dashPhysicsGraph; //대쉬 물리 그래프
    public float f_dashTime; //대쉬 시간
    public float f_dashDistance; //대쉬 거리
    public float f_cutTime; //베기 시간
    public int i_cutCount; //연속 베기 횟수
    public Vector3 v3_dashRange;
}
