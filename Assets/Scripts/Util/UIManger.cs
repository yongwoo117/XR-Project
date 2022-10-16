using TMPro;
using UnityEngine;

public class UIManger : MonoBehaviour
{
    [SerializeField] private TMP_Text rhythmStreakText;

    protected virtual void Start()
    {
        rhythmStreakText.text = "0";
    }
    
    protected void UpdateComboUI(int combo) => rhythmStreakText.text = combo.ToString();
}
