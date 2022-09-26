using System.Collections;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(AudioSource))]
public class UIManager : MonoBehaviour
{
    private AudioSource audioSource;

    /// <summary>
    /// 박자에 맞춘 이펙트가 끝나는 시점에 Callback됩니다.
    /// </summary>
    public UnityEvent onRhythmEffectEnd;

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    public void InvokeRhythmEffect()
    {
        audioSource.Play();
        StartCoroutine(WaitForAudioEnding());
    }

    private IEnumerator WaitForAudioEnding()
    {
        yield return new WaitUntil(() => audioSource.isPlaying == false);
        
        onRhythmEffectEnd?.Invoke();
    }
}
