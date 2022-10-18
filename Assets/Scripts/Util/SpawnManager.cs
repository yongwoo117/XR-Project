using Enemy.State;
using JetBrains.Annotations;
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
    [HideInInspector]public int CurrentReSpawnCount; //스폰 영역 내 리스폰 남은 횟수
}


public class SpawnManager : MonoBehaviour
{
    [SerializeField] private List<SpawnArea> List_SpawnArea = new List<SpawnArea>();
    [SerializeField] private EnemySpawnProfile enemySpawnProfile;
    [SerializeField] private int SpawnCount;

    private Dictionary<e_EnemyType, ObjectPool<GameObject>> poolDictionary;
    private int CurrentSpawnCount;

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

    private void Awake()
    {
        CreateEnemyClone();
        SpawnObject();
    }

    private void Start()
    {
       for(int i=0;i<SpawnCount;i++)
       {
            SpawnObject();
       }

    }

    /// <summary>
    /// 스폰 영역을 렌덤으로 받아온 후 스폰하는 적 타입을 랜덤으로 풀링
    /// 풀링된 적 위치는 영역 내 랜덤으로 배치 
    /// 추가적인 예외처리 필요
    /// </summary>
    private void SpawnObject()
    {
        if(CurrentSpawnCount<SpawnCount)
        {
            SpawnArea area = List_SpawnArea[UnityEngine.Random.Range(0, List_SpawnArea.Count)];

            if(area.CurrentReSpawnCount<area.ReSpawnCount)
            {
                GameObject spawnObj = PopEnemy(area.List_EnemyType[UnityEngine.Random.Range(0, area.List_EnemyType.Count)]);

                float randX = UnityEngine.Random.Range(area.AreaSize.x * -0.5f, area.AreaSize.x * 0.5f);
                float randZ = UnityEngine.Random.Range(area.AreaSize.y * -0.5f, area.AreaSize.y * 0.5f);

                spawnObj.transform.position = area.SpawnTransform.position + new Vector3(randX, 0f, randZ);

                area.CurrentReSpawnCount++;
            }
        }
    }
    //오브젝트 풀링
    private void CreateEnemyClone()
    {
        poolDictionary = new Dictionary<e_EnemyType, ObjectPool<GameObject>>();
        foreach (var obj in enemySpawnProfile.Dic_Spawn)
        {
            var pool = new ObjectPool<GameObject>(
                () => InstantiatePrefab(obj),
                instance => instance.SetActive(true),
                instance => instance.SetActive(false),
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

        DieState dieState = instance.GetComponent<EnemyStateMachine>().States[e_EnemyState.Die] as DieState;

        if(dieState==null)
        {
            Debug.LogError("적에 DieState가 없어 Pooling CallBack 추가 X");
        }
        else
        {
            dieState.DieAction = value => PushEnemy(pair.Key, value);
        }

        instance.SetActive(false);
        return instance;
    }

    [CanBeNull]
    public GameObject PopEnemy(e_EnemyType key)
    {
        if (poolDictionary.ContainsKey(key))
        {
            CurrentSpawnCount++; //CurrentSpawnCount 증가
            return poolDictionary[key].Get();
        }

        Debug.LogError("존재 하지 않는 스폰 타입 호출" + key);
        return null;
    }

    //사용된 오브젝트들은 Push해서 다시 넣어줌 (콜백) 후 CurrentSpawnCount 감소
    private void PushEnemy(e_EnemyType key, GameObject obj)
    {
        if (!poolDictionary.ContainsKey(key)) return;
        poolDictionary[key].Release(obj);
        CurrentSpawnCount--; //CurrentSpawnCount 감소
    }
}
