using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(241f/255f,249f/255f,99f/255f)]
[TrackClipType(typeof(DialogueClip))]
[TrackBindingType(typeof(DialogueManager))]
public class DialogueTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
        foreach(var clip in GetClips())
        {
            var loopClip = clip.asset as DialogueClip;
            loopClip.clipPassthrough = clip;

            var binding = go.GetComponent<PlayableDirector>().GetGenericBinding(this) as DialogueManager;
            ((DialogueClip)(clip.asset)).dialogueManager = binding;
        }
       

        return ScriptPlayable<DialogueController>.Create(graph, inputCount);
    }

}
