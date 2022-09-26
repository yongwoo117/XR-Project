/// <summary>
/// Unity내 LayerMask 정보를 받아옵니다.
/// </summary>
public static class GetLayerMasks
{
    public static readonly int Player = 1 << GetLayer.Player;
    public static readonly int Ground = 1 << GetLayer.Ground;
}


/// <summary>
/// Unity내 Layer 정보를 받아옵니다.
/// </summary>
public static class GetLayer
{
    public static readonly int Player = UnityEngine.LayerMask.NameToLayer("Player");
    public static readonly int Ground = UnityEngine.LayerMask.NameToLayer("Ground");
}