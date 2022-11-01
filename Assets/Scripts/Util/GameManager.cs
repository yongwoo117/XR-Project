using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class GameManager : SoundManager
{
    [SerializeField] private PlayerInput playerInput;
    
    private bool IsPaused
    {
        get => isPaused;
        set
        {
            isPaused = value;
            Time.timeScale = IsPaused ? 0 : 1.0f;
            playerInput.enabled = !isPaused;
            PauseRhythm(IsPaused);
            PauseSound(IsPaused);
            PauseUI(IsPaused);
        }
    }

    private bool IsDialogue
    {
        get => isDialogue;
        set
        {
            isDialogue = value;
            playerInput.enabled = !IsDialogue;
            PauseRhythm(IsDialogue);
            PauseSound(IsDialogue);

            if (IsDialogue)
                TimeLineManager.Instance.PlayTimeLine();
            else
                TimeLineManager.Instance.isDialogueSkip = false;
        }
    }

    private bool isPaused;
    private bool isDialogue;

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

    public void OnDialogueInteraction(InputAction.CallbackContext context)
    {
        if (!context.started) return;
        IsDialogue = true;
    }

    public void OnResumeButtonDown() => IsPaused = false;

    public void OnDialgoue(bool isActive)
    {
        IsDialogue = isActive;
    }
    public void OnOptionButtonDown()
    {
        DisplaySettingMenu();
    }

    public void OnExitButtonDown()
    {
        Time.timeScale = 1.0f;
        SceneManager.LoadScene("StartScene");
    }
}
