using System.Collections.Generic;
using FMOD.Studio;
using FMODUnity;
using UnityEngine;
using STOP_MODE = FMOD.Studio.STOP_MODE;

public class SoundManager : UIManger
{
    [SerializeField] private EventReference buttonDownSound;
    [SerializeField] private EventReference pauseSound;
    [SerializeField] private List<EventReference> stageBgmList = new();
    [SerializeField] private EventReference winBgm;
    [SerializeField] private EventReference defeatBgm;

    private EventInstance? currentBgm;
    
    protected void ButtonDownSound() => buttonDownSound.PlayOneShot();
    
    protected void PauseSound(bool pause)
    {
        pauseSound.PlayOneShot();
        currentBgm?.setPaused(pause);
    }

    private void ChangeBgm(EventReference eventReference)
    {
        currentBgm?.stop(STOP_MODE.ALLOWFADEOUT);
        currentBgm?.release();
        currentBgm = RuntimeManager.CreateInstance(eventReference);
        currentBgm.Value.start();
    }
    
    protected virtual void OnDestroy()
    {
        currentBgm?.stop(STOP_MODE.IMMEDIATE);
        currentBgm?.release();
    }
    
    protected void SetBgmByStage(int stage) => ChangeBgm(stageBgmList[stage - 1]);
    protected void PlayWinBgm() => ChangeBgm(winBgm);
    protected void PlayDefeatBgm() => ChangeBgm(defeatBgm);
}
