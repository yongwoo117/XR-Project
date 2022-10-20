using System.Collections.Generic;

public abstract class CombatComboModule : RhythmComboModule
{
    public List<e_PlayerState> ComboList { get; } = new();
    protected abstract int CombatComboLimit { get; }
}