using UnityEngine;
using UnityEngine.Events;

public class RhythmCombo : MonoBehaviour
{
    public UnityEvent<int> onComboChanged;
    
    public int Combo
    {
        get => combo;
        set
        {
            if (combo == value) return;
            combo = value;
            onComboChanged?.Invoke(combo);
        }
    }
    private int combo;
}
