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
    }
    
    protected void UpdateComboUI(int combo)
    { 
        rhythmStreakText.text = combo.ToString();
        if (combo != 0) return;
        rhythmComboAnimator.SetTrigger(AnimationParameter.fail);
    }

    protected void PauseUI(bool isPaused)
    {
        pauseInterface.SetActive(isPaused);
        if (!isPaused)
            settingInterface.SetActive(false);
    }

    public void BeforeStageStart(int stage)
    {
        stageAnimator.SetTrigger(AnimationParameter.Active);
        stageImage.sprite = stageSpriteList[stage - 1];
    }

    public void OnTooEarly()
    {
        rhythmComboAnimator.SetTrigger(AnimationParameter.fail);
    }

    public void OnGameEnded()
    {
        
    }

    protected void DisplaySettingMenu() => settingInterface.SetActive(true);
}
