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
    [SerializeField] private Animator stageTransitionAnimator;
    [SerializeField] private Animator rhythmComboAnimator;
    [SerializeField] private Animator stageEndingAnimator;
    [SerializeField] private Image stageImage;
    [SerializeField] private List<Sprite> stageSpriteList;

    protected override void Start()
    {
        base.Start();
        rhythmStreakText.text = "0";
        pauseInterface.SetActive(false);
        onHalf.AddListener(() => rhythmComboAnimator.SetTrigger(AnimationParameter.Idle));
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
        stageTransitionAnimator.SetTrigger(AnimationParameter.Active);
        stageImage.sprite = stageSpriteList[stage - 1];
    }

    protected void ActiveGameEndingMenu() => stageEndingAnimator.SetTrigger(AnimationParameter.Active);
    public void OnRhythmMissed() => rhythmComboAnimator.SetTrigger(AnimationParameter.Fail);
    protected void DisplaySettingMenu() => settingInterface.SetActive(true);
}
