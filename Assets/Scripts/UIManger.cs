using TMPro;
using UnityEngine;

public class UIManger : MonoBehaviour
{
    [SerializeField] private TMP_Text rhythmStreakText;

    private void Start()
    {
        rhythmStreakText.text = "0";
        RhythmStreakModule.RhythmStreakChanged += OnRhythmStreakChanged;
    }

    public void OnRhythmStreakChanged(int streak)
    {
        rhythmStreakText.text = streak.ToString();
    }
}
