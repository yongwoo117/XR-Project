using FMODUnity;

public static class FMODExtension
{
    public static void PlayOnShot(this EventReference eventReference) => RuntimeManager.PlayOneShot(eventReference);
}