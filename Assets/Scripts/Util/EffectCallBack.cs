using UnityEngine;

public class EffectCallBack : MonoBehaviour
{
    private void OnParticleSystemStopped()
    {
        EffectProfileData.Instance.PushEffect(gameObject);
    }

}