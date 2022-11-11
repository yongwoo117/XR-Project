using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UIManger : RhythmCore
{
    [SerializeField] private TMP_Text rhythmStreakText;
    [SerializeField] private GameObject pauseInterface;
    [SerializeField] private GameObject settingInterface;
    [SerializeField] private GameObject stagePanel;
    [SerializeField] private Image stageImage;
    [SerializeField] private List<Sprite> stageSpriteList;
    [SerializeField] private float stageTransitionTime;

    protected override void Start()
    {
        base.Start();
        rhythmStreakText.text = "0";
        pauseInterface.SetActive(false);
    }
    
    protected void UpdateComboUI(int combo) => rhythmStreakText.text = combo.ToString();
    
    protected void PauseUI(bool isPaused)
    {
        pauseInterface.SetActive(isPaused);
        if (!isPaused)
            settingInterface.SetActive(false);
    }

    public void BeforeStageStart(int stage)
    {
        stagePanel.SetActive(true);
        stageImage.sprite = stageSpriteList[stage - 1];
    }

    public void OnGameEnded()
    {
        
    }

    protected void DisplaySettingMenu() => settingInterface.SetActive(true);
}
