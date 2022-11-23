using System.Collections.Generic;
using FMOD.Studio;
using FMODUnity;
using UnityEngine;
using STOP_MODE = FMOD.Studio.STOP_MODE;

public class SoundManager : UIManger
{
    [SerializeField] private List<int> rhythmTrigger;
    [SerializeField] private EventReference buttonDownSound;
    [SerializeField] private EventReference pauseSound;
    [SerializeField] private List<EventReference> stageBgmList = new();

    private int rhythmIndex;
    private EventInstance? currentBgm;
    
    protected override void Start()
    {
        base.Start();
        rhythmIndex = 0;
    }
    
    protected void UpdateSound(int combo)
    {
        if (rhythmIndex < rhythmTrigger.Count && combo >= rhythmTrigger[rhythmIndex])
        {
            rhythmIndex++;
            currentBgm?.setParameterByName("Battle", rhythmIndex);
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
            currentBgm?.setParameterByName("Battle", rhythmIndex);
        }
    }

    protected void ButtonDownSound() => buttonDownSound.PlayOneShot();
    
    protected void PauseSound(bool pause)
    {
        pauseSound.PlayOneShot();
        currentBgm?.setPaused(pause);
    }

    protected void ChangeBgm(int stage)
    {
        currentBgm?.stop(STOP_MODE.ALLOWFADEOUT);
        currentBgm?.release();
        currentBgm = RuntimeManager.CreateInstance(stageBgmList[stage - 1]);
        currentBgm.Value.start();
        currentBgm.Value.setParameterByName("Battle", rhythmIndex);
    }

    protected virtual void OnDestroy()
    {
        currentBgm?.stop(STOP_MODE.IMMEDIATE);
        currentBgm?.release();
    }
}
