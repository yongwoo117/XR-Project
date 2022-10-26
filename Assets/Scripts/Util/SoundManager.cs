using System.Collections.Generic;
using FMODUnity;
using UnityEngine;

public class SoundManager : UIManger
{
    [SerializeField] private List<int> rhythmTrigger;
    private StudioEventEmitter eventEmitter;
    private int rhythmIndex;
    
    protected override void Start()
    {
        base.Start();
        eventEmitter = GetComponent<StudioEventEmitter>();
        rhythmIndex = 0;
    }
    
    protected void UpdateSound(int combo)
    {
        if (rhythmIndex < rhythmTrigger.Count && combo >= rhythmTrigger[rhythmIndex])
        {
            rhythmIndex++;
            eventEmitter.SetParameter("Battle", rhythmIndex);
        }
        else if (rhythmIndex > 0)
        {
            if (combo >= rhythmTrigger[rhythmIndex - 1]) return;
            for (var index = 0; index < rhythmTrigger.Count; index++)
            {
                if (combo >= rhythmTrigger[index]) continue;
                rhythmIndex = index;
                break;
            }
            eventEmitter.SetParameter("Battle", rhythmIndex);
        }
    }

    protected void PauseSound(bool pause) => RuntimeManager.PauseAllEvents(pause);
}
