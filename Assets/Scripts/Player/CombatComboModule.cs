using System.Collections.Generic;

public abstract class CombatComboModule : RhythmFeedbackModule
{
    private List<e_PlayerState> comboList = new();
    protected abstract int CombatComboLimit { get; }

    public void AddCombatCombo(e_PlayerState combo)
    {
        if (comboList.Count == CombatComboLimit - 1) comboList.Clear();
        else comboList.Add(combo);
    }

    public void CombatComboBreak() => comboList.Clear();

    public e_PlayerState[] CombatCombo => comboList.ToArray();
}