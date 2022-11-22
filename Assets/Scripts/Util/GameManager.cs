using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public sealed class GameManager : SoundManager
{
    [SerializeField] private PlayerInput playerInput;
    [SerializeField] private List<float> stageBpmList;

    public static readonly UnityEvent<bool> OnPause = new();

    private bool IsPaused
    {
        get => isPaused;
        set
        {
            isPaused = value;
            Time.timeScale = IsPaused ? 0 : 1.0f;
            playerInput.enabled = !IsPaused;
            PauseRhythm(IsPaused);
            PauseSound(IsPaused);
            PauseUI(IsPaused);
            OnPause?.Invoke(IsPaused);
        }
    }
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
        IsPaused = !IsPaused;
    }

    public void OnPauseButtonDown()
    {
        ButtonDownSound();
        IsPaused = true;
    }

    public void OnResumeButtonDown()
    {
        ButtonDownSound();
        IsPaused = false;
    }

    public void OnOptionButtonDown()
    {
        ButtonDownSound();
        DisplaySettingMenu();
    }

    public void OnExitButtonDown()
    {
        ButtonDownSound();
        Time.timeScale = 1.0f;
        SceneManager.LoadScene("StartScene");
    }

    public void OnBeforeStageStart(int stage)
    {
        ChangeBgm(stage);
        Bpm = stageBpmList[stage - 1];
        ShowStageTransition(stage);
    }
}
