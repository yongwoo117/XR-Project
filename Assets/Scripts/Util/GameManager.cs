using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class GameManager : SoundManager
{
    [SerializeField] private PlayerInput playerInput;
    [SerializeField] private List<float> stageBpmList;

    public static readonly UnityEvent<bool> OnPause = new();
    public static bool IsPaused { get; private set; }
    
    private float TimeScale => (float)(stageBpmList[StageManager.Stage - 1] / Bpm);

    protected override void Start()
    {
        base.Start();
        IsPaused = false;
    }

    public void OnRhythmComboChanged(int combo)
    {
        UpdateComboUI(combo);
        UpdateSound(combo);
    }

    private void SetPause(bool pause)
    {
        IsPaused = pause;
        Time.timeScale = IsPaused ? 0 : TimeScale;
        playerInput.enabled = !IsPaused;
        PauseSound(IsPaused);
        PauseUI(IsPaused);
        OnPause?.Invoke(IsPaused);
    }

    public void OnInterrupt(InputAction.CallbackContext context)
    {
        if (!context.started) return;
        SetPause(!IsPaused);
    }

    public void OnPauseButtonDown()
    {
        ButtonDownSound();
        SetPause(true);
    }

    public void OnResumeButtonDown()
    {
        ButtonDownSound();
        SetPause(false);
    }

    public void OnOptionButtonDown()
    {
        ButtonDownSound();
        DisplaySettingMenu();
    }

    public void OnExitButtonDown()
    {
        ButtonDownSound();
        Time.timeScale = TimeScale;
        SceneManager.LoadScene("StartScene");
    }

    public void OnBeforeStageStart()
    {
        ChangeBgm(StageManager.Stage);
        ShowStageTransition();
        Time.timeScale = TimeScale;
    }

    public void OnStageCleared()
    {
        ShowGameClearMenu();
    }

    public void OnPlayerDead()
    {
        ShowPlayerDeadMenu();
    }

    public void OnNextStageButtonDown()
    {
        ButtonDownSound();
        SceneManager.LoadScene("Scenes/SampleScene");
    }

    public void OnGameEnded()
    {
        DisableRestartButton();
    }
}
