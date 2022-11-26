using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class DialogueClip : PlayableAsset, ITimelineClipAsset
{
    [SerializeField]
    private DialogueBehaviour template = new DialogueBehaviour();
    [NonSerialized] public TimelineClip clipPassthrough = null;
    public DialogueManager dialogueManager { get; set; }
    public ClipCaps clipCaps
    { get { return ClipCaps.Blending; } }

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        template.Clip = clipPassthrough;
        var playalbe = ScriptPlayable<DialogueBehaviour>.Create(graph, template);


        var scenePlayable = playalbe.GetBehaviour();
        scenePlayable.toLoad = true;
        scenePlayable.dialogueManager = dialogueManager;


        return playalbe;
    }


}
