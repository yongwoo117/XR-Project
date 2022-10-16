using System;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class StartManager : MonoBehaviour
{
    [SerializeField] private TMP_Dropdown resolutionDropdown;
    [SerializeField] private TMP_Dropdown screenModeDropdown;
    [SerializeField] private Slider masterVolumeSlider;
    [SerializeField] private Slider bgmVolumeSlider;
    [SerializeField] private Slider sfxVolumeSlider;
    private AsyncOperation gameScene;

    private void Start()
    {
        gameScene = SceneManager.LoadSceneAsync("Scenes/SampleScene");
        gameScene.allowSceneActivation = false;
        SetupResolutionDropdown();
        SetupScreenModeDropdown();
        SetupMasterVolumeSlider();
        SetupBGMVolumeSlier();
        SetupSFXVolumeSlider();
    }

    private void SetupDropdown(Array array, TMP_Dropdown dropdown, Action<int> onValueChanged, PrefsKey prefsKey,
        int initialValue)
    {
        //드롭다운에 아이템 추가
        dropdown.options.Clear();
        foreach (var member in array)
            dropdown.options.Add(new TMP_Dropdown.OptionData(member.ToString()));

        //드롭다운 기본값 세팅
        dropdown.value = Prefs.HasKey(prefsKey) ? Prefs.GetInt(prefsKey) : initialValue;
        onValueChanged(dropdown.value);
        
        //이벤트 등록
        dropdown.onValueChanged.AddListener(index =>
        {
            Prefs.SetInt(prefsKey, index);
            onValueChanged(index);
        });
        
    }

    private void SetupResolutionDropdown()
    {
        var resolutions = Screen.resolutions;

        SetupDropdown(resolutions, resolutionDropdown, index =>
                Screen.SetResolution(resolutions[index].width, resolutions[index].height, Screen.fullScreenMode),
            PrefsKey.ResolutionIndex, resolutions.Length - 1);
    }

    private void SetupScreenModeDropdown()
    {
        if (Enum.GetValues(typeof(FullScreenMode)) is not FullScreenMode[] screenModeList) return;

        SetupDropdown(screenModeList, screenModeDropdown, index =>
            Screen.fullScreenMode = screenModeList[index], PrefsKey.ScreenModeIndex, 0);
    }

    private void SetupSlider(string path, Slider slider, PrefsKey prefsKey)
    {
        //버스 받아오기
        var bus = FMODUnity.RuntimeManager.GetBus(path);
        
        //슬라이더 기본값 세팅
        slider.value = Prefs.HasKey(prefsKey) ? Prefs.GetFloat(prefsKey) : slider.maxValue / 2;
        bus.setVolume(slider.value);

        //이벤트 등록
        slider.onValueChanged.AddListener(value =>
        {
            Prefs.SetFloat(prefsKey, value);
            bus.setVolume(value);
        });

    }

    private void SetupMasterVolumeSlider() => SetupSlider("bus:/MasterBus", masterVolumeSlider, PrefsKey.MasterVolume);
    private void SetupBGMVolumeSlier() => SetupSlider("bus:/MasterBus/BGM", bgmVolumeSlider, PrefsKey.BGMVolume);
    private void SetupSFXVolumeSlider() => SetupSlider("bus:/MasterBus/SFX", sfxVolumeSlider, PrefsKey.SFXVolume);

    public void OnStartButtonClick()
    {
        gameScene.allowSceneActivation = true;
    }

    public void OnGameExitButtonClick()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}
