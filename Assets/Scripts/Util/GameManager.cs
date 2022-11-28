using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class GameManager : SoundManager
{
    [SerializeField] private PlayerInput playerInput;
    [SerializeField] private List<float> stageBpmList;
    [SerializeField] private List<GameObject> stageBackGround;

    public static readonly UnityEvent<bool> OnPause = new();
    public static bool IsPaused { get; private set; }
    public static bool IsDialogue { get; private set; }

    private float TimeScale => (float)(stageBpmList[StageManager.Stage - 1] / Bpm);
    private bool IsTimeLine;

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

    private void SetDialogue(bool dialogue)
    {
        IsDialogue = dialogue;
        playerInput.enabled = !IsDialogue;
        PauseRhythm(IsDialogue);
        PauseSound(IsDialogue);

        if (IsDialogue) TimeLineManager.Instance.PlayTimeLine();
        else TimeLineManager.Instance.isDialogueSkip = false;
    }

    private void ChangeBackGround(int stage)
    {
        for(int i=0;i<stageBackGround.Count;i++)
        {
            if (stage-1 == i)
                stageBackGround[i].SetActive(true);
            else
                stageBackGround[i].SetActive(false);
        }
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

    public void OnDialogueInteraction(InputAction.CallbackContext context)
    {
        if (!context.started) return;
        if (IsTimeLine) SetDialogue(true);
    }

    public void OnDialogue(bool isActive)
    {
        IsTimeLine = isActive;
        SetDialogue(isActive);
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
        ChangeBackGround(StageManager.Stage);
        ShowStageTransition();
        Time.timeScale = TimeScale;
    }

    public void OnStageCleared()
    {
        playerInput.enabled = false;
        GetComponent<PlayerInput>().enabled = false;
        ShowGameClearMenu();
    }

    public void OnPlayerDead()
    {
        playerInput.enabled = false;
        GetComponent<PlayerInput>().enabled = false;
        ShowPlayerDeadMenu();
    }

    public void OnNextStageButtonDown()
    {
        ButtonDownSound();
        SceneManager.LoadScene("Scenes/SampleScene");
    }

    public void OnMainScene()
    {
        SetDialogue(false);
        SceneManager.LoadScene("Scenes/SampleScene");
    }

    public void OnGameEnded()
    {
        DisableRestartButton();
    }
}
