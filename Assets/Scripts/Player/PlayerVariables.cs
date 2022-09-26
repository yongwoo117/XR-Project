using UnityEngine;

/// <summary>
/// 플레이어와 관련된 변수들을 제공합니다.
/// </summary>
public class PlayerVariables : Singleton<PlayerVariables>
{
    public PlayerProfile Profile => playerProfile;

    [SerializeField] private PlayerProfile playerProfile;
}
