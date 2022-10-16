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
        //TODO: 일시정지를 해제한 후에 리듬 싱크가 틀어져버리는 문제가 발생. 수정 필요
        isPaused = !isPaused;
        Time.timeScale = isPaused ? 0 : 1.0f;
        SetSoundPause(isPaused);
    }
}
