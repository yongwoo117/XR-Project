using UnityEngine;
using UnityEngine.SceneManagement;

public class StartManager : MonoBehaviour
{
    private AsyncOperation gameScene;
    
    private void Start()
    {
        gameScene = SceneManager.LoadSceneAsync("Scenes/SampleScene");
        gameScene.allowSceneActivation = false;
    }

    public void OnStartButtonClick()
    {
        gameScene.allowSceneActivation = true;
    }

    public void OnSettingButtonClick()
    {
        //TODO: 옵션 창을 띄워줍니다.
    }

    public void OnExitButtonClick()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}
