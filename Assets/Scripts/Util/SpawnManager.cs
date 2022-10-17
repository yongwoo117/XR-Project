using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnManager : MonoBehaviour
{
    [SerializeField] private List<Transform> List_SpawnPoints = new List<Transform>();
    [SerializeField] private int SpawnCount;

    private void Start()
    {
        SpawnObject();
    }
    private void SpawnObject()
    {
        GameObject clone = ObjectPoolingManager.Instance.Pool<ObjectPoolingCallBack>("Enemy").Get();

        EnemyStateMachine enemyStateMachine = clone.GetComponent<EnemyStateMachine>();

        enemyStateMachine.ChangeState(e_EnemyState.Idle);

        clone.transform.parent = transform;
        clone.transform.position = List_SpawnPoints[Random.Range(0, List_SpawnPoints.Count)].position;
    }
}
