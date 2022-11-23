using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[Serializable]
public struct StageInfo
{
    public int maximumExistEnemy;
    public float respawnDelay;
    public List<SpawnArea> spawnAreaList;
}

[RequireComponent(typeof(SpawnManager))]
public class StageManager : MonoBehaviour
{
    [SerializeField] private List<StageInfo> stageList = new();
    [SerializeField] private float startDelay;

    public UnityEvent<int> beforeStageStart;
    public UnityEvent<int> onStageCleared;
    public UnityEvent onGameEnded;

    private static int stageIndex;
    private SpawnManager spawnManager;

    private StageInfo CurrentStage => stageList[stageIndex];
    
    private void Start()
    {
        spawnManager = GetComponent<SpawnManager>();
        StartCoroutine(DelayStart());
    }

    private IEnumerator DelayStart()
    {
        beforeStageStart?.Invoke(stageIndex + 1);
        yield return new WaitForSeconds(startDelay);
        spawnManager.CurrentStage = CurrentStage;
    }

    public void OnStageClear()
    {
        onStageCleared?.Invoke(stageIndex++);
        if (stageIndex == stageList.Count) onGameEnded?.Invoke();
    }
}
