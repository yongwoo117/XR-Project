using FMODUnity;

public static class FMODExtension
{
    public static void PlayOneShot(this EventReference eventReference) => RuntimeManager.PlayOneShot(eventReference);
}