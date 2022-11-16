using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class DialogueController : PlayableBehaviour
{
    private DialogueManager dialogueManager;

    private PlayableDirector director;

    public override void OnPlayableCreate(Playable playable)
    {
        director = (playable.GetGraph().GetResolver() as PlayableDirector);

    }

    public override void OnGraphStart(Playable playable)
    {
        ScriptPlayable<DialogueBehaviour> inputPlayable = (ScriptPlayable<DialogueBehaviour>)playable.GetInput(0);
        DialogueBehaviour dialogueBehaviour = inputPlayable.GetBehaviour();

        if (dialogueBehaviour.toLoad)
        {
            dialogueManager = dialogueBehaviour.dialogueManager;
        }

    }

    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        if (dialogueManager == null)
            dialogueManager = playerData as DialogueManager;

        int inputCnt = playable.GetInputCount();
        bool isOn = false;

        for (int i = 0; i < inputCnt; i++)
        {
            ScriptPlayable<DialogueBehaviour> inputPlayable = (ScriptPlayable<DialogueBehaviour>)playable.GetInput(i);
            DialogueBehaviour dialogueBehaviour = inputPlayable.GetBehaviour();
            if (playable.GetTime() >= dialogueBehaviour.Clip.start && playable.GetTime() < dialogueBehaviour.Clip.end)
            {
                if (dialogueBehaviour.DialogueText.Length > 0)
                {
                    isOn = true;

                    string nowText = "";

                    int durationFrame = (int)(inputPlayable.GetDuration() * 60f);

                    int Length = dialogueBehaviour.DialogueText.Length;

                    int nowFrame = (int)(inputPlayable.GetTime() * 60f);

                    int indexFrame = durationFrame / Length;

                    for (int s = 0; s < nowFrame; s += indexFrame)
                    {
                        int index = s / indexFrame;

                        if (index == 0)
                            dialogueManager.SetActive(true);

                        if (index < Length)
                            nowText += dialogueBehaviour.DialogueText[index];

                        if (index == Length||TimeLineManager.Instance.isDialogueSkip)
                        {
                            if (TimeLineManager.Instance.isDialogueSkip)
                            {
                                nowText = dialogueBehaviour.DialogueText;
                                dialogueManager.SetDialogue(dialogueBehaviour.PlayerSprite,dialogueBehaviour.NpcSprite, dialogueBehaviour.NameText, dialogueBehaviour.NameColor, nowText, dialogueBehaviour.Font);
                            }

                            TimeLineManager.Instance.PauseTimeLine(director, dialogueBehaviour);
                            return;
                        }
                    }

                    dialogueManager.SetDialogue(dialogueBehaviour.PlayerSprite, dialogueBehaviour.NpcSprite, dialogueBehaviour.NameText, dialogueBehaviour.NameColor, nowText, dialogueBehaviour.Font);
                }
            }
            else if (!isOn)
            {
                dialogueManager.SetActive(false);
            }

        }


    }

    public override void OnPlayableDestroy(Playable playable)
    {
        if(dialogueManager!=null)
            dialogueManager.EndDialogue();
    }

}
