using UnityEngine.Events;

public abstract class RhythmComboModule : RhythmInputModule
{
    public UnityEvent<int> onRhythmComboChanged;
    
    public int RhythmCombo
    {
        get => rhythmCombo;
        set
        {
            if (rhythmCombo == value) return;
            rhythmCombo = value;
            onRhythmComboChanged?.Invoke(rhythmCombo);
        }
    }
    private int rhythmCombo;
}
