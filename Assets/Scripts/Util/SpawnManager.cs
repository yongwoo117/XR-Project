using System;
using System.Collections.Generic;
using UnityEngine;
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
    public bool isCanSpawn; //스폰 영역을 사용할지
}


public class SpawnManager : MonoBehaviour
{ 
    [SerializeField] private List<SpawnArea> List_SpawnArea = new List<SpawnArea>();
    [SerializeField] private EnemySpawnProfile enemySpawnProfile;
    [SerializeField] private int SpawnCount;

    private Dictionary<e_EnemyType, ObjectPool<GameObject>> poolDictionary;

    private void OnDrawGizmos()
    {
        if (List_SpawnArea.Count > 0)
        {
            foreach (var point in List_SpawnArea)
            {
                Gizmos.DrawWireCube(point.SpawnTransform.position, new Vector3(point.AreaSize.x,0f, point.AreaSize.y));
            }
        }
    }
    
    private void Start()
    {
        CreateEnemyClone();
        for (int count = 0; count < SpawnCount; count++)
            SpawnObject();
    }

    /// <summary>
    /// 스폰 영역을 렌덤으로 받아온 후 스폰하는 적 타입을 랜덤으로 풀링
    /// 풀링된 적 위치는 영역 내 랜덤으로 배치 
    /// 추가적인 예외처리 필요
    /// </summary>
    private void SpawnObject()
    {
        if (RandomAreaIndex() is not { } randIndex) return;
        SpawnArea area = List_SpawnArea[randIndex];

        var spawnObj = poolDictionary[area.List_EnemyType[UnityEngine.Random.Range(0, area.List_EnemyType.Count)]]
            .Get();

        float randX = UnityEngine.Random.Range(area.AreaSize.x * -0.5f, area.AreaSize.x * 0.5f);
        float randZ = UnityEngine.Random.Range(area.AreaSize.y * -0.5f, area.AreaSize.y * 0.5f);

        spawnObj.transform.position = area.SpawnTransform.position + new Vector3(randX, 0f, randZ);

        if (--area.ReSpawnCount <= 0) area.isCanSpawn = false;

        List_SpawnArea[randIndex] = area;
    }

    private int? RandomAreaIndex()
    {
        List<int> RandIndexPool = new List<int>();
        int? PlayerAreaIndex = null;

        for (int i = 0; i < List_SpawnArea.Count; i++)
        {
            SpawnArea area = List_SpawnArea[i];

            if (!Physics.CheckBox(area.SpawnTransform.position,
                    new Vector3(area.AreaSize.x * 0.5f, 10f, area.AreaSize.y * 0.5f), Quaternion.identity,
                    GetLayerMasks.Player))
            {
                if (area.isCanSpawn)
                {
                    RandIndexPool.Add(i);
                }
            }
            else
            {
                PlayerAreaIndex = i;
            }

          
        }

        if (RandIndexPool.Count == 0)
        {
            if (PlayerAreaIndex != null)
            {
                for (int i = 0; i < List_SpawnArea.Count; i++)
                {
                    if (i != PlayerAreaIndex)
                        RandIndexPool.Add(i);
                }
            }

            if (RandIndexPool.Count == 0)
                return null;
        }
        
        return RandIndexPool[UnityEngine.Random.Range(0, RandIndexPool.Count)];
    }

    //오브젝트 풀링
    private void CreateEnemyClone()
    {
        poolDictionary = new Dictionary<e_EnemyType, ObjectPool<GameObject>>();
        foreach (var obj in enemySpawnProfile.Dic_Spawn)
        {
            if (poolDictionary.ContainsKey(obj.Key)) continue;
            var pool = new ObjectPool<GameObject>(
                () => InstantiatePrefab(obj),
                instance => instance.SetActive(true), 
                OnRelease,
                null, true, SpawnCount);
            poolDictionary.Add(obj.Key, pool);
        }
    }

    /// <summary>
    /// 적 생성 후 DieState에 CallBack을 추가해줌 
    /// DieState.Enter()일때 CallBack 호출
    /// </summary>
    /// <param name="pair">적 타입(e_EnemyType)을 통해 Prefab으로 만들어 놓은 적을 받아와서 사용 할 수 있도록 함</param>
    /// <returns></returns>
    private GameObject InstantiatePrefab(KeyValuePair<e_EnemyType, GameObject> pair)
    {
        var instance = Instantiate(pair.Value,transform);
        instance.AddComponent<SpawnCallback>().ReturnAction = value => poolDictionary[pair.Key].Release(value);
        instance.SetActive(false);
        return instance;
    }

    private void OnRelease(GameObject instance)
    {
        instance.SetActive(false);
        SpawnObject();
    }
}
