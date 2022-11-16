using UnityEngine;
using UnityEditor.UI;
using TMPro;
using System.Collections.Generic;
using UnityEngine.Playables;

public class TutorialManager:TimeLineManager
{
    [SerializeField] private List<PlayableAsset> playableAssets; 
    [SerializeField] private GameObject player;
    [SerializeField] private GameObject TurtorialPannel;
    [SerializeField] private TextMeshProUGUI cutText;

    [SerializeField] private int MaxRhythmCount;
    private RhythmInputModule rhythmInputModule;
    private int OnRhythmCount;

    protected override void Start()
    {
        if (player == null)
        {
            player = GameObject.FindGameObjectWithTag("Player");
        }

        rhythmInputModule = player.GetComponent<RhythmInputModule>();

        base.Start();
    }
    public void StartCutTutorial()
    {
        rhythmInputModule.onRhythm.AddListener(CutTutorial);
        TurtorialPannel?.SetActive(true);
    }

    public void CutTutorial(InteractionType interactionType)
    {
        if (RhythmCore.Instance.Judge())
        {
            switch (interactionType)
            {
                case InteractionType.Ready:
                    OnRhythmCount++;
                    cutText.text = "박자를(" + OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
                default:
                    break;
            }
        }

        if(OnRhythmCount>=MaxRhythmCount)
        {
            OnRhythmCount = 0;
            TurtorialPannel?.SetActive(false);
            PlayerTimeLine(playableAssets[1]);
        }
    }

}
