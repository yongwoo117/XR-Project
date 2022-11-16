using System.Collections.Generic;
using FMOD.Studio;
using FMODUnity;
using UnityEngine;

public class SoundManager : UIManger
{
    [SerializeField] private List<int> rhythmTrigger;
    [SerializeField] private EventReference buttonDownSound;
    [SerializeField] private EventReference pauseSound;
    [SerializeField] private List<EventReference> stageBgmList = new();
    private PARAMETER_ID eventParameter;

    private int rhythmIndex;
    private EventInstance currentBgm;
    
    protected override void Start()
    {
        base.Start();
        rhythmIndex = 0;
        currentBgm = RuntimeManager.CreateInstance(stageBgmList[0]);
        currentBgm.start();
    }
    
    protected void UpdateSound(int combo)
    {
        if (rhythmIndex < rhythmTrigger.Count && combo >= rhythmTrigger[rhythmIndex])
        {
            rhythmIndex++;
            currentBgm.setParameterByName("Battle", rhythmIndex);
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
            currentBgm.setParameterByName("Battle", rhythmIndex);
        }
    }

    protected void ButtonDownSound() => buttonDownSound.PlayOneShot();
    
    protected void PauseSound(bool pause)
    {
        pauseSound.PlayOneShot();
        currentBgm.setPaused(pause);
    }

    protected void ChangeBgm(int stage)
    {
        currentBgm.release();
        currentBgm = RuntimeManager.CreateInstance(stageBgmList[stage]);
        currentBgm.start();
        currentBgm.setParameterByName("Battle", rhythmIndex);
    }
}
