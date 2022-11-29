using UnityEngine;
using TMPro;
using System.Collections.Generic;
using UnityEngine.Playables;
using System.Collections;

public class TutorialManager : TimeLineManager
{
    [SerializeField] private List<PlayableAsset> playableAssets;
    [SerializeField] private PlayerStateMachine player;
    [SerializeField] private Animator TurtorialPannel;
    [SerializeField] private Animator HelpBoard;
    [SerializeField] private TextMeshProUGUI cutText;
    [SerializeField] private DialogueManager TextBoard;
    [SerializeField] private GameObject Spike;


    [SerializeField] private int MaxRhythmCount;
    private RhythmInputModule rhythmInputModule;
    private int OnRhythmCount;
    private int TimelineCnt;
    private float SpikeTime = 10f;

    protected override void Start()
    {
        player ??= GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerStateMachine>();
        Spike ??= GameObject.FindGameObjectWithTag("Spike");

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
                cutText.text = "대쉬를 성공 시키세요.";
                break;
            case 3:
                cutText.text = "대쉬를(" + OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                break;
            case 4:
                player.AddDictionaryState(e_PlayerState.Cut);
                cutText.text = "자르기를(" + OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                break;
            case 5:
                player.onDamaged.AddListener(ResetSpikeTime);
                Spike.gameObject.SetActive(true);
                StartCoroutine(SpikeTimer());
                cutText.text = "찌르기를 통해서 가시를 회피하세요.";
                break;
        }

        rhythmInputModule.onRhythm.AddListener(Tutorial);
        TurtorialPannel?.SetTrigger("On");
    }

    public void HelpBoardOn() => TextBoard.SetHelpText();
    public void DialogueBoardOn() => TextBoard.SetDialgoueText();

    public void Tutorial(InteractionType interactionType)
    {
        if (RhythmCore.Instance.Judge())
        {
            switch (interactionType, TimelineCnt)
            {
                case (InteractionType.Ready, 0):
                    cutText.text = "박자를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
                case (InteractionType.Ready, 1):
                    cutText.text = "준비자세를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
                case (InteractionType.Dash, 3):
                    cutText.text = "대쉬를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
                case (InteractionType.Dash, 2):
                    OnRhythmCount = 3;
                    break;
                case (InteractionType.Cut, 4):
                    cutText.text = "자르기를(" + ++OnRhythmCount + "/" + MaxRhythmCount + ")번 성공 시키세요.";
                    break;
            }
        }

        if (OnRhythmCount < MaxRhythmCount) return;

        NextTutorial();
    }


    public void OnSkipButtonClick() => ((GameManager)GameManager.Instance).OnMainScene();

    private void NextTutorial()
    {
        OnRhythmCount = 0;
        TurtorialPannel?.SetTrigger("Off");
        TimelineCnt++;
        rhythmInputModule.onRhythm.RemoveListener(Tutorial);

        if (TimelineCnt < playableAssets.Count) PlayerTimeLine(playableAssets[TimelineCnt]);
    }

    private void ResetSpikeTime(float val)
    {
        SpikeTime = 10f;
    }
    IEnumerator SpikeTimer()
    {
        while(SpikeTime>0f)
        {
            SpikeTime -= Time.deltaTime;
            yield return new WaitForSeconds(Time.deltaTime);
        }
        Spike.gameObject.SetActive(false);
        player.onDamaged.RemoveListener(ResetSpikeTime);
        NextTutorial();
    }
}
