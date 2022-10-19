using UnityEngine;
using UnityEngine.InputSystem;

public class GameManager : SoundManager
{
    private bool isPaused;

    protected override void Start()
    {
        base.Start();
        isPaused = false;
    }

    public void OnRhythmComboChanged(int combo)
    {
        UpdateComboUI(combo);
        UpdateSound(combo);
    }

    public void OnInterrupt(InputAction.CallbackContext context)
    {
        if (!context.started) return;
        isPaused = !isPaused;
        if (isPaused)
        {
            Time.timeScale = 0;
            PauseRhythm();
        }
        else
        {
            Time.timeScale = 1.0f;
            ResumeRhythm();
        }
        SetSoundPause(isPaused);
    }
}
