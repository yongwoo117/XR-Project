using TMPro;
using UnityEngine;

public class UIManger : RhythmCore
{
    [SerializeField] private TMP_Text rhythmStreakText;

    protected override void Start()
    {
        base.Start();
        rhythmStreakText.text = "0";
    }
    
    protected void UpdateComboUI(int combo) => rhythmStreakText.text = combo.ToString();
}
