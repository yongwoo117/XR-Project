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
    [SerializeField] private Slider stageProgressSlider;

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

    protected void ShowStageTransition()
    {
        stageTransitionAnimator.SetTrigger(AnimationParameter.Active);
        stageImage.sprite = stageSpriteList[StageManager.Stage - 1];
    }

    private void SetupEndingStats(Component menuPanel)
    {
        var texts = menuPanel.GetComponentsInChildren<TextMeshProUGUI>();
        texts[1].text = $"S      {StageManager.Stage}";
        texts[3].text = $"{StageManager.ElapsedTime:F}초";
        texts[4].text = $"{RhythmComboModule.MaximumCombo}회";
        texts[5].text = SpawnManager.KilledDictionary[e_EnemyType.Heavy].ToString();
        texts[6].text = SpawnManager.KilledDictionary[e_EnemyType.Basic].ToString();
        texts[7].text = SpawnManager.KilledDictionary[e_EnemyType.Speed].ToString();
    }
    
    protected void ShowGameClearMenu()
    {
        stageEndingAnimator.gameObject.SetActive(true);
        stageEndingAnimator.SetTrigger(AnimationParameter.Clear);
        SetupEndingStats(stageEndingAnimator.transform.GetChild(0));
    }

    protected void ShowPlayerDeadMenu()
    {
        stageEndingAnimator.gameObject.SetActive(true);
        stageEndingAnimator.SetTrigger(AnimationParameter.Dead);
        SetupEndingStats(stageEndingAnimator.transform.GetChild(1));
    }

    protected void DisableRestartButton() =>
        stageEndingAnimator.transform.GetChild(0).GetChild(9).GetComponent<Button>().interactable = false;

    public void OnRhythmMissed() => rhythmComboAnimator.SetTrigger(AnimationParameter.Fail);
    protected void DisplaySettingMenu() => settingInterface.SetActive(true);
    public void OnStageProgressChanged(float progress) => stageProgressSlider.value = progress;
}
