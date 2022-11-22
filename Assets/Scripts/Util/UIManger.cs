using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UI;

public class UIManger : RhythmCore
{
    [SerializeField] private TMP_Text rhythmStreakText;
    [SerializeField] private GameObject pauseInterface;
    [SerializeField] private GameObject settingInterface;
    [SerializeField] private Animator stageAnimator;
    [SerializeField] private Animator rhythmComboAnimator;
    [SerializeField] private Image stageImage;
    [SerializeField] private List<Sprite> stageSpriteList;

    protected override void Start()
    {
        base.Start();
        rhythmStreakText.text = "0";
        pauseInterface.SetActive(false);
        onHalf.AddListener(() => rhythmComboAnimator.SetTrigger(AnimationParameter.Idle));
        onBpmChanged.AddListener(() => 
            rhythmComboAnimator.SetFloat(AnimationParameter.Rhythm, (float)Bpm / 60.0f));
    }
    
    protected void UpdateComboUI(int combo)
    { 
        rhythmStreakText.text = combo.ToString();
        if (combo != 0) return;
        rhythmComboAnimator.SetTrigger(AnimationParameter.Fail);
    }

    protected void PauseUI(bool isPaused)
    {
        pauseInterface.SetActive(isPaused);
        if (!isPaused) settingInterface.SetActive(false);
    }

    protected void ShowStageTransition(int stage)
    {
        stageAnimator.SetTrigger(AnimationParameter.Active);
        stageImage.sprite = stageSpriteList[stage - 1];
    }

    public void OnRhythmMissed()
    {
        rhythmComboAnimator.SetTrigger(AnimationParameter.Fail);
    }

    public void OnGameEnded()
    {
        Debug.Log("끝");
    }

    protected void DisplaySettingMenu() => settingInterface.SetActive(true);
}
