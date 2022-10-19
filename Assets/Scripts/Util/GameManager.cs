using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class GameManager : SoundManager
{
    private bool IsPaused
    {
        get => isPaused;
        set
        {
            isPaused = value;
            Time.timeScale = IsPaused ? 0 : 1.0f;
            //TODO: 퍼즈 상태에서 클릭시에 콤보가 깨져버리는 문제 발생. 인풋을 안받게끔 처리해야함
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
        SceneManager.LoadScene("StartScene");
    }
}
