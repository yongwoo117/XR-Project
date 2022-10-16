using TMPro;
using UnityEngine;

public class UIManger : MonoBehaviour
{
    [SerializeField] private TMP_Text rhythmStreakText;

    private void Start()
    {
        rhythmStreakText.text = "0";
    }

    public void OnRhythmComboChanged(int combo)
    {
        rhythmStreakText.text = combo.ToString();
    }
}
