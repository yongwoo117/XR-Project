using TMPro;
using UnityEngine;

public class UIManger : RhythmCore
{
    [SerializeField] private TMP_Text rhythmStreakText;
    [SerializeField] private GameObject pauseInterface;

    protected override void Start()
    {
        base.Start();
        rhythmStreakText.text = "0";
        pauseInterface.SetActive(false);
    }
    
    protected void UpdateComboUI(int combo) => rhythmStreakText.text = combo.ToString();
    protected void PauseUI(bool isPaused) => pauseInterface.SetActive(isPaused);
}
