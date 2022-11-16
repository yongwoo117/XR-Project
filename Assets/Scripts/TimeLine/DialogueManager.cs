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
    private bool isOn;

    public void SetDialogue(Sprite playerspr,Sprite Npcspr, string nameText, Color nameColor, string dialogueText, TMP_FontAsset font)
    {
        PlayerImg.sprite = playerspr;
        NpcImg.sprite = Npcspr;

        NameText.text = nameText;
        NameText.color = nameColor;

        DialogueText.text = dialogueText;

        NameText.font = font;
        DialogueText.font = font;
    }

    public void SetActive(bool isActive)
    {
        isOn = isActive;
        gameObject.SetActive(isActive);

    }

}
