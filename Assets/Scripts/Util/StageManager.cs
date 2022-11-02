using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public struct StageInfo
{
    public int maximumExistEnemy;
    public float respawnDelay;
    public List<SpawnArea> spawnAreaList;
}

public class StageManager : MonoBehaviour
{
    [SerializeField] private List<StageInfo> stageList = new();
    private int currentIndex;
    private StageInfo CurrentStage => stageList[currentIndex];
    
    private void Start()
    {
        
    }
}
