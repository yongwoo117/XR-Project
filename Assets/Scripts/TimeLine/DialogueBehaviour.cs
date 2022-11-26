using System;
using TMPro;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class DialogueBehaviour : PlayableBehaviour
{
    public string NameText;
    public Color NameColor;
    public string DialogueText;
    public TMP_FontAsset Font;
    public Sprite PlayerSprite;
    public Sprite NpcSprite;
    public bool isCanInteractive;

    public bool toLoad { get; set; }
    [NonSerialized] public DialogueManager dialogueManager;
    [NonSerialized] public TimelineClip Clip;
}
