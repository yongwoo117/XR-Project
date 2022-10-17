using System.Collections;
using System.Collections.Generic;
using UnityEngine;



/// <summary>
/// 사용 하는 모든 이펙트들을 관리하는 매니저 오브젝트 풀링을 관리함
/// 사용할 이펙트들은 각 클래스에서 Pop을 통해 호출
/// 다쓴 이펙트들은 콜백을 통해 Push
/// </summary>
public class EffectProfileData : Singleton<ObjectPooling>
{
    [SerializeField] private PoolingData poolingData;
    [SerializeField] private int effectPoolIndex;
    protected override void Awake()
    {
        base.Awake();
        Instance.onCreateObject += AddEffectCallBack;
        Instance.PoolIndex = effectPoolIndex;
        Instance.poolingData = poolingData;
    }



    private void AddEffectCallBack(GameObject clone)
    {
        clone.AddComponent<EffectCallBack>();
    }

}