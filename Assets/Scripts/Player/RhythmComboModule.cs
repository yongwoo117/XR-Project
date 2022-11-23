using UnityEngine.Events;

public abstract class RhythmComboModule : RhythmInputModule
{
    public UnityEvent<int> onRhythmComboChanged;
    
    public static int MaximumCombo { get; private set; }

    public int RhythmCombo
    {
        get => rhythmCombo;
        set
        {
            if (rhythmCombo == value) return;
            rhythmCombo = value;
            if (MaximumCombo < rhythmCombo) MaximumCombo = rhythmCombo;
            onRhythmComboChanged?.Invoke(rhythmCombo);
        }
    }
    private int rhythmCombo;
}
