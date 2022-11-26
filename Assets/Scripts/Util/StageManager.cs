using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

[Serializable]
public struct StageInfo
{
    public int maximumExistEnemy;
    public float respawnDelay;
    public List<SpawnArea> spawnAreaList;

    public int OverallEnemyCount => spawnAreaList.Sum(spawnArea => spawnArea.ReSpawnCount);
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
    private double pausedTime;

    public static double ElapsedTime => Time.realtimeSinceStartupAsDouble - startTime;
    public static int Stage => stageIndex + 1;

    private StageInfo CurrentStage => stageList[stageIndex];
    
    private void Start()
    {
        spawnManager = GetComponent<SpawnManager>();
        StartCoroutine(DelayStart());
        GameManager.OnPause.AddListener(OnPaused);
    }

    private IEnumerator DelayStart()
    {
        beforeStageStart?.Invoke();
        yield return new WaitForSeconds(startDelay);
        spawnManager.CurrentStage = CurrentStage;
        // GameManager.OnPause.AddListener();
        startTime = Time.realtimeSinceStartupAsDouble;
    }

    private void OnPaused(bool isPaused)
    {
        if (isPaused) pausedTime = Time.realtimeSinceStartupAsDouble;
        else startTime += Time.realtimeSinceStartupAsDouble - pausedTime;
    }

    public void OnStageClear()
    {
        onStageCleared?.Invoke();
        if (++stageIndex != stageList.Count) return;
        onGameEnded?.Invoke();
        stageIndex = 0;
    }
}
