using System;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartManager : MonoBehaviour
{
    [SerializeField] private TMP_Dropdown resolutionDropdown;
    [SerializeField] private TMP_Dropdown screenModeDropdown;
    private AsyncOperation gameScene;

    private void Start()
    {
        gameScene = SceneManager.LoadSceneAsync("Scenes/SampleScene");
        gameScene.allowSceneActivation = false;
        SetupResolutionDropdown();
        SetupScreenModeDropdown();
    }

    private void SetupResolutionDropdown()
    {
        var resolutions = Screen.resolutions;
        
        //드롭다운에 아이템 추가
        resolutionDropdown.options.Clear();
        foreach (var resolution in resolutions)
            resolutionDropdown.options.Add(new TMP_Dropdown.OptionData(resolution.ToString()));
        
        //이벤트 등록
        resolutionDropdown.onValueChanged.AddListener(index =>
        {
            PlayerPrefs.SetInt("ResolutionIndex", index);
            Screen.SetResolution(resolutions[index].width, resolutions[index].height, Screen.fullScreenMode);
        });

        //드롭다운 기본값 세팅
        resolutionDropdown.value = PlayerPrefs.HasKey("ResolutionIndex")
            ? PlayerPrefs.GetInt("ResolutionIndex")
            : resolutions.Length - 1;
    }

    private void SetupScreenModeDropdown()
    {
        if (Enum.GetValues(typeof(FullScreenMode)) is not FullScreenMode[] screenModeList) return;
        
        //드롭다운에 아이템 추가
        screenModeDropdown.options.Clear();
        foreach (var screenMode in screenModeList)
            screenModeDropdown.options.Add(new TMP_Dropdown.OptionData(screenMode.ToString()));
        
        //이벤트 등록
        screenModeDropdown.onValueChanged.AddListener(index =>
        {
            PlayerPrefs.SetInt("ScreenModeIndex", index);
            Screen.fullScreenMode = screenModeList[index];
        });
        
        //드롭다운 기본값 세팅
        screenModeDropdown.value = PlayerPrefs.HasKey("ScreenModeIndex") ? PlayerPrefs.GetInt("ScreenModeIndex") : 0;
    }

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
