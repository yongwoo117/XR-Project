using System;

public class RhythmStreakModule
{
    private static int _streak = 0;

    public static event Action<int> RhythmStreakChanged;

    protected void IncreaseStreak() => RhythmStreakChanged?.Invoke(++_streak);

    protected void BreakStreak()
    {
        _streak = 0;
        RhythmStreakChanged?.Invoke(_streak);
    }
}