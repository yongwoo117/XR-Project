using FMODUnity;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartManager : MonoBehaviour
{
    [SerializeField] private EventReference buttonDownSound;
    private AsyncOperation gameScene;

    private void Start()
    {
        gameScene = SceneManager.LoadSceneAsync("Scenes/SampleScene");
        gameScene.allowSceneActivation = false;
    }

    public void OnStartButtonClick()
    {
        buttonDownSound.PlayOneShot();
        gameScene.allowSceneActivation = true;
    }

    public void OnSettingButtonClick() => buttonDownSound.PlayOneShot();
    
    public void OnGameExitButtonClick()
    {
        buttonDownSound.PlayOneShot();
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }
}
