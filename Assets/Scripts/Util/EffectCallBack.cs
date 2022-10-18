using UnityEngine;
using UnityEngine.Pool;

public class EffectCallBack : ObjectPoolingCallBack
{
    public ParticleSystem system;
    void Start()
    {
        system = GetComponent<ParticleSystem>();
        var main = system.main;
        main.stopAction = ParticleSystemStopAction.Callback;
    }
    private void OnParticleSystemStopped()
    {
        Pool.Release(gameObject);
    }
  
}