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

    public void OnGameExitButtonClick()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}
