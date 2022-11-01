using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class TimeLineManager : Singleton<TimeLineManager>
{
    private PlayableDirector playableDirector;
    private GameManager gameManager;

    private bool isTimeLinePause;
    private double StartTime;
    public bool isDialogueSkip { get; set; }

    private void Start()
    {
        if (playableDirector == null)
            playableDirector = GetComponent<PlayableDirector>();

        gameManager = GetComponent<GameManager>();
        PlayerTimeLine(playableDirector.playableAsset);
    }
    public void PlayerTimeLine(PlayableAsset timeline)
    {
        playableDirector.playOnAwake = true;
        playableDirector.Play(timeline);
    }

    public void OnDialogue()
    {
        gameManager.OnDialgoue(true);
    }

    public void PlayTimeLine()
    {
        if (isTimeLinePause)
        {
            playableDirector.playableGraph.GetRootPlayable(0).SetSpeed(1d);
            playableDirector.time = StartTime;
            isTimeLinePause = false;
            isDialogueSkip = false;
        }
        else
        {
            isDialogueSkip = true;
        }
    }

    public void PauseTimeLine(PlayableDirector whichone, DialogueBehaviour behaviour)
    {
        playableDirector = whichone;
        playableDirector.playableGraph.GetRootPlayable(0).SetSpeed(0d);

        StartTime = behaviour.Clip.end;

        isTimeLinePause = true;
    }

}
