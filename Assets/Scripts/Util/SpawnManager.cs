using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Pool;

/// <summary>
/// 스폰지역에 대한 정보들을 구조체로 사용
/// </summary>
[Serializable]
public struct SpawnArea
{
    public Transform SpawnTransform; //Transform을 통해 스폰 영역 중심을 지정
    public Vector2 AreaSize; //스폰 영역의 크기
    public List<e_EnemyType> List_EnemyType; //스폰 영역 내 스폰 가능한 적 타입
    public int ReSpawnCount; //스폰 영역 내 리스폰 횟수
}

[Serializable]
public struct EnemyPoolingInfo
{
    public e_EnemyType enemyType;
    public GameObject prefab;
    public int poolingCount;
}

public class SpawnManager : MonoBehaviour
{
    [SerializeField] private List<EnemyPoolingInfo> poolingList;
    private Dictionary<e_EnemyType, ObjectPool<GameObject>> poolDictionary;
    private int objectCount;
    
    public UnityEvent onStageCleared;
    
    private StageInfo currentStage;
    public StageInfo CurrentStage
    {
        get => currentStage;
        set
        {
            currentStage = value;
            objectCount = 0;
            for (int count = 0; count < currentStage.maximumExistEnemy; count++)
                SpawnObject();
        }
    }
    
    private void OnDrawGizmos()
    {
        if (CurrentStage.spawnAreaList is null) return;
        foreach (var point in CurrentStage.spawnAreaList)
            Gizmos.DrawWireCube(point.SpawnTransform.position, new Vector3(point.AreaSize.x, 0f, point.AreaSize.y));
    }
    
    private void Start() => CreateEnemyClone();

    /// <summary>
    /// 스폰 영역을 렌덤으로 받아온 후 스폰하는 적 타입을 랜덤으로 풀링
    /// 풀링된 적 위치는 영역 내 랜덤으로 배치 
    /// 추가적인 예외처리 필요
    /// </summary>
    private void SpawnObject()
    {
        if (RandomAreaIndex() is not { } randIndex)
        {
            if (objectCount != 0) return;
            onStageCleared?.Invoke();
            objectCount = -1;
            return;
        }

        SpawnArea area = CurrentStage.spawnAreaList[randIndex];

        var spawnObj = poolDictionary[area.List_EnemyType[UnityEngine.Random.Range(0, area.List_EnemyType.Count)]]
            .Get();

        float randX = UnityEngine.Random.Range(area.AreaSize.x * -0.5f, area.AreaSize.x * 0.5f);
        float randZ = UnityEngine.Random.Range(area.AreaSize.y * -0.5f, area.AreaSize.y * 0.5f);

        spawnObj.transform.position = area.SpawnTransform.position + new Vector3(randX, 0f, randZ);
        area.ReSpawnCount--;
        CurrentStage.spawnAreaList[randIndex] = area;
        objectCount++;
    }

    private int? RandomAreaIndex()
    {
        List<int> RandIndexPool = new List<int>();
        int? PlayerAreaIndex = null;

        for (int i = 0; i < CurrentStage.spawnAreaList.Count; i++)
        {
            SpawnArea area = CurrentStage.spawnAreaList[i];

            if (Physics.CheckBox(area.SpawnTransform.position,
                    new Vector3(area.AreaSize.x * 0.5f, 10f, area.AreaSize.y * 0.5f),
                    Quaternion.identity, GetLayerMasks.Player))
                PlayerAreaIndex = i;
            else if (area.ReSpawnCount > 0) RandIndexPool.Add(i);
        }

        if (RandIndexPool.Count != 0) return RandIndexPool[UnityEngine.Random.Range(0, RandIndexPool.Count)];
        
        if (PlayerAreaIndex is not null)
        {
            if (CurrentStage.spawnAreaList[(int)PlayerAreaIndex].ReSpawnCount > 0)
                return PlayerAreaIndex;
        }
        return null;
    }

    //오브젝트 풀링
    private void CreateEnemyClone()
    {
        poolDictionary = new Dictionary<e_EnemyType, ObjectPool<GameObject>>();
        foreach (var obj in poolingList)
        {
            if (poolDictionary.ContainsKey(obj.enemyType)) continue;
            var pool = new ObjectPool<GameObject>(
                () => InstantiatePrefab(obj.enemyType, obj.prefab), 
                instance => instance.SetActive(true), 
                OnRelease, null, true, obj.poolingCount);
            poolDictionary.Add(obj.enemyType, pool);
        }
    }

    /// <summary>
    /// 적 생성 후 DieState에 CallBack을 추가해줌 
    /// DieState.Enter()일때 CallBack 호출
    /// </summary>
    private GameObject InstantiatePrefab(e_EnemyType key, GameObject prefab)
    {
        var instance = Instantiate(prefab,transform);
        instance.AddComponent<SpawnCallback>().ReturnAction = value => poolDictionary[key].Release(value);
        instance.SetActive(false);
        return instance;
    }

    private IEnumerator DelaySpawn(float delay)
    {
        yield return new WaitForSeconds(delay);
        SpawnObject();
    }

    private void OnRelease(GameObject instance)
    {
        instance.SetActive(false);
        objectCount--;
        StartCoroutine(DelaySpawn(currentStage.respawnDelay));
    }
}
