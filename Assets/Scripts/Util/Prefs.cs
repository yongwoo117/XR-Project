using UnityEngine;

public enum PrefsKey
{
    ResolutionIndex,
    ScreenModeIndex,
    MasterVolume,
    BGMVolume,
    SFXVolume
}

public static class Prefs
{
    public static bool HasKey(PrefsKey prefsKey) => PlayerPrefs.HasKey(prefsKey.ToString());
    public static void SetInt(PrefsKey prefsKey, int value) => PlayerPrefs.SetInt(prefsKey.ToString(), value);
    public static int GetInt(PrefsKey prefsKey) => PlayerPrefs.GetInt(prefsKey.ToString());
    public static void SetFloat(PrefsKey prefsKey, float value) => PlayerPrefs.SetFloat(prefsKey.ToString(), value);
    public static float GetFloat(PrefsKey prefsKey) => PlayerPrefs.GetFloat(prefsKey.ToString());
}