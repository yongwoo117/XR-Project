using System;
using UnityEngine;

/// <summary>
/// Player의 정보를 저장하고 있는 ScriptableObject입니다.
/// </summary>
[CreateAssetMenu(fileName = "PlayerProfile", menuName = "PlayerProfile", order = 1)]
[Serializable]
public class PlayerProfile : SFXProfile
{
    public float f_maximumHealth;
    public float f_standardDamage; //기준 피해량
    public int i_maximumCombatCombo;
    
    public float f_dashMultiplier; //대쉬 피해 배율
    public AnimationCurve dashPhysicsGraph; //대쉬 물리 그래프
    public float f_dashTime; //대쉬 시간
    public Vector3 v3_dashRange;
    public float f_dashDistance; //대쉬 거리
    
    public float f_cutTime; //베기 시간
    public float f_cutRange; //베기 거리
    public float f_cutMultipier; //베기 피해 배율
}
