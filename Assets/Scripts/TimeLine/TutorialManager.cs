using UnityEngine;
using UnityEditor.UI;
using TMPro;
using System.Collections.Generic;
using UnityEngine.Playables;

public class TutorialManager:TimeLineManager
{
    [SerializeField] private List<PlayableAsset> playableAssets; 
    [SerializeField] private PlayerStateMachine player;
    [SerializeField] private GameObject TurtorialPannel;
    [SerializeField] private TextMeshProUGUI cutText;

    [SerializeField] private int MaxRhythmCount;
    private RhythmInputModule rhythmInputModule;
    private int OnRhythmCount;
    private int TimelineCnt;

    protected override void Start()
    {
        if (player == null)
        {
            player = GameObject.FindGameObjectWithTag("Pllayer").GetComponent < PlayerStateMachine>() ;
        }

        rhythmInputModule = player.GetComponent<RhythmInputModule>();
        TimelineCnt = 0;

        base.Start();
    }
    public void StartTutorial()
    {
        switch (TimelineCnt)
        {
            case 1:
                player.AddDictionaryState(e_PlayerState.Ready);
                cutText.text = "준비자세를(" + OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                break;
            case 2:
                player.AddDictionaryState(e_PlayerState.Dash);
                cutText.text = "대쉬를(" + OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                break;
            case 3:
                player.AddDictionaryState(e_PlayerState.Cut);
                cutText.text = "자르기를(" + OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                break;
        }

        rhythmInputModule.onRhythm.AddListener(Tutorial);
        TurtorialPannel?.SetActive(true);

    }


    public void Tutorial(InteractionType interactionType)
    {
        if (RhythmCore.Instance.Judge())
        {            
            switch (interactionType)
            {
                case InteractionType.Ready:
                    if (TimelineCnt==0)
                        cutText.text = "박자를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    else if(TimelineCnt==1)
                        cutText.text = "준비자세를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
                case InteractionType.Dash:
                    if (TimelineCnt == 2)
                        cutText.text = "대쉬를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
                case InteractionType.Cut:
                    if (TimelineCnt == 3)
                        cutText.text = "자르기를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
                default:
                    break;
            }
        }

        if(OnRhythmCount>=MaxRhythmCount)
        {
            OnRhythmCount = 0;
            TurtorialPannel?.SetActive(false);
            TimelineCnt++;
            rhythmInputModule.onRhythm.RemoveListener(Tutorial);

            if(TimelineCnt<playableAssets.Count)
            PlayerTimeLine(playableAssets[TimelineCnt]);
        }
    }

   

}
