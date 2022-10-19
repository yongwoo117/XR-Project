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

    public void OnResumeButtonDown() => IsPaused = false;

    public void OnOptionButtonDown()
    {
        //TODO: 옵션 창을 띄워줍니다.
    }

    public void OnExitButtonDown()
    {
        Time.timeScale = 1.0f;
        SceneManager.LoadScene("StartScene");
    }
}
