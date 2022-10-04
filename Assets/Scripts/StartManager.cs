using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartManager : MonoBehaviour
{
    private AsyncOperation gameScene;
    [SerializeField] private GameObject settingPanel;
    [SerializeField] private List<GameObject> displaySettingUI;
    [SerializeField] private List<GameObject> soundSettingUI;

    private void SetUI(List<GameObject> uiList,bool enable)
    {
        foreach (var ui in uiList)
            ui.SetActive(enable);
    }
    
    private void Start()
    {
        gameScene = SceneManager.LoadSceneAsync("Scenes/SampleScene");
        gameScene.allowSceneActivation = false;
        settingPanel.SetActive(false);

        SetUI(displaySettingUI, false);
        SetUI(soundSettingUI, false);
    }

    public void OnStartButtonClick()
    {
        gameScene.allowSceneActivation = true;
    }

    public void OnSettingButtonClick()
    {
        settingPanel.SetActive(true);
    }

    public void OnGameExitButtonClick()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    public void OnSettingExitButtonClick()
    {
        settingPanel.SetActive(false);
    }

    public void OnDisplaySettingButtonClick()
    {
        SetUI(soundSettingUI, false);
        SetUI(displaySettingUI, true);
    }

    public void OnSoundSettingButtonClick()
    {
        SetUI(displaySettingUI,false);
        SetUI(soundSettingUI, true);
    }
}
