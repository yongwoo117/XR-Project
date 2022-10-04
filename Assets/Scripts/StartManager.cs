using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartManager : MonoBehaviour
{
    [SerializeField] private TMP_Dropdown resolutionDropdown;
    [SerializeField] private TMP_Dropdown screenModeDropdown;
    private AsyncOperation gameScene;
    private List<Resolution> resolutions;

    private void Start()
    {
        gameScene = SceneManager.LoadSceneAsync("Scenes/SampleScene");
        gameScene.allowSceneActivation = false;
        SetupResolutionDropdown();
        SetupScreenModeDropdown();
    }

    private void SetupResolutionDropdown()
    {
        resolutions = new List<Resolution>();
        resolutions.AddRange(Screen.resolutions);
        resolutionDropdown.options.Clear();
        foreach (var resolution in resolutions)
            resolutionDropdown.options.Add(new TMP_Dropdown.OptionData(resolution.ToString()));
        resolutionDropdown.onValueChanged.AddListener(index =>
            Screen.SetResolution(resolutions[index].width, resolutions[index].height, Screen.fullScreenMode));
    }

    private void SetupScreenModeDropdown()
    {
        var screenModeList = Enum.GetNames(typeof(FullScreenMode));
        screenModeDropdown.options.Clear();
        foreach (var screenMode in screenModeList)
            screenModeDropdown.options.Add(new TMP_Dropdown.OptionData(screenMode));
        screenModeDropdown.onValueChanged.AddListener(index =>
        {
            if(!Enum.TryParse(screenModeList[index], out FullScreenMode result)) return;
            Screen.fullScreenMode = result;
        });
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
