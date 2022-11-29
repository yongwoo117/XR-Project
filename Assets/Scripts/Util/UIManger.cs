using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using UI;

public class UIManger : RhythmCore
{
    [SerializeField] private TMP_Text rhythmStreakText;
    [SerializeField] private Animator pauseInterface;
    [SerializeField] private Animator settingInterface;
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
        if (rhythmComboAnimator.gameObject.activeSelf)
            onHalf.AddListener(() => rhythmComboAnimator?.SetTrigger(AnimationParameter.Idle));
    }

    protected void UpdateComboUI(int combo)
    {
        rhythmStreakText.text = combo.ToString();
        if (combo != 0) return;
        rhythmComboAnimator.SetTrigger(AnimationParameter.Fail);
    }

    protected void PauseUI(bool isPaused)
    {
        pauseInterface.SetTrigger(isPaused ? "Activate" : "Disable");
        if (!isPaused) settingInterface.SetTrigger("Disable");
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
        texts[5].text = SpawnManager.KilledDictionary[e_EnemyType.Speed].ToString();
        texts[6].text = SpawnManager.KilledDictionary[e_EnemyType.Heavy].ToString();
        texts[7].text = SpawnManager.KilledDictionary[e_EnemyType.Basic].ToString();
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

    public void OnRhythmMissed()
    {
        if (rhythmComboAnimator.gameObject.activeSelf) 
            rhythmComboAnimator.SetTrigger(AnimationParameter.Fail);
                
    }

    protected void DisplaySettingMenu()
    {
        settingInterface.SetTrigger("Activate");
        settingInterface.ResetTrigger("Disable");
    }

    public void OnStageProgressChanged(float progress) => stageProgressSlider.value = progress;
}
