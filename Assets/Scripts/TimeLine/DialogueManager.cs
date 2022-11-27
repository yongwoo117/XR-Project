using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System;
using UnityEngine.UI;
using UnityEngine.Playables;
using UnityEngine.Events;

public class DialogueManager : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI NameText;
    [SerializeField] private TextMeshProUGUI DialogueText;
    [SerializeField] private Image PlayerImg;
    [SerializeField] private Image NpcImg;
    [SerializeField] private float TextLoopingTime;
    [SerializeField] private GameObject Dialogue;
    [SerializeField] private GameObject Help;

    public void SetDialogue(Sprite playerspr,Sprite Npcspr, string nameText, Color nameColor, string dialogueText, TMP_FontAsset font)
    {
        if(PlayerImg!=null)
            PlayerImg.sprite = playerspr;

        if (NpcImg != null)
            NpcImg.sprite = Npcspr;

        if (NameText != null)
        {
            NameText.text = nameText;
            NameText.color = nameColor;
            NameText.font = font;
        }

        if (DialogueText != null)
        {
            DialogueText.text = dialogueText;
            DialogueText.font = font;
        }
    }

    public void SetActive(bool isActive)
    {
        gameObject.SetActive(isActive);
    }

    public void SetHelpText(TextMeshProUGUI text)
    {
        Dialogue.SetActive(false);
        Help.SetActive(true);
        DialogueText = text;
    }

    public void EndDialogue()
    {
        SetActive(false);
        TimeLineManager.Instance.EndTimeLine();
    }

}
