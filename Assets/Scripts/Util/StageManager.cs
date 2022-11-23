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

    private static double startTime;
    
    public UnityEvent beforeStageStart;
    public UnityEvent onStageCleared;
    public UnityEvent onGameEnded;

    private static int stageIndex;
    private SpawnManager spawnManager;

    public static double ElapsedTime => startTime - Time.realtimeSinceStartupAsDouble;
    public static int Stage => stageIndex + 1;

    private StageInfo CurrentStage => stageList[stageIndex];
    
    private void Start()
    {
        spawnManager = GetComponent<SpawnManager>();
        StartCoroutine(DelayStart());
    }

    private IEnumerator DelayStart()
    {
        beforeStageStart?.Invoke();
        yield return new WaitForSeconds(startDelay);
        spawnManager.CurrentStage = CurrentStage;
        startTime = Time.realtimeSinceStartupAsDouble;
    }

    public void OnStageClear()
    {
        onStageCleared?.Invoke();
        if (stageIndex == stageList.Count) onGameEnded?.Invoke();
    }
}
