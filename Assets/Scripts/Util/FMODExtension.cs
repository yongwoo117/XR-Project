using FMOD.Studio;
using FMODUnity;
using UnityEngine;

public static class FMODExtension
{
    public static void AttachedOneShot(this EventReference eventReference, GameObject gameObject) =>
        RuntimeManager.PlayOneShotAttached(eventReference, gameObject);

    public static EventInstance CreateAttach(this EventReference eventReference, Transform transform)
    {
        var instance = RuntimeManager.CreateInstance(eventReference);
        RuntimeManager.AttachInstanceToGameObject(instance, transform);
        return instance;
    }
}