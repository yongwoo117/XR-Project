using UnityEngine;

namespace Player.State
{
    public class IdleState : PlayerState
    {
        private IControl control;
        private GameObject RhythmRange;
        private SpriteRenderer RhythmSprite;
        private SpriteRenderer RhythmDirSprite;

        private MaterialPropertyBlock RhythmMat;
        private MaterialPropertyBlock RhythmDirMat;

        private bool isRhythmEaly;
        public override void Initialize()
        {
            control = StateMachine.GetComponent<IControl>();
            RhythmRange = StateMachine.transform.GetChild(1).gameObject;

            RhythmSprite = RhythmRange.GetComponent<SpriteRenderer>();
            RhythmDirSprite = RhythmRange.transform.GetChild(0).GetComponent<SpriteRenderer>();

            RhythmMat = new MaterialPropertyBlock();
            RhythmDirMat = new MaterialPropertyBlock();
            RhythmDirMat.SetTexture("_MainTex", RhythmDirSprite.sprite.texture);
        }
        public override void Enter()
        {
            Debug.Log("Idle Enter");
            StateMachine.Combo = 0;

            RhythmDirSprite.gameObject.SetActive(true);
        }

        public override void Exit()
        {
            base.Exit();
        }

        public override void LogicUpdate()
        {
            FillRhyRange();
            RotationRhyRange();
        }

        private void FillRhyRange()
        {
            float JudgeOffset = RhythmCore.Instance.JudgeOffset;
            float RemainTime = 1f - (float)RhythmCore.Instance.RemainTime;

            float Fill;

            if (RemainTime > (1f - JudgeOffset))
            {
                Fill = Mathf.Lerp(0f, 1f, 1f - (1f - RemainTime) / JudgeOffset);
                RhythmDirMat.SetFloat("Fill", Fill);
                RhythmDirSprite.SetPropertyBlock(RhythmDirMat);
            }
            else if(!isRhythmEaly)
            {
                Fill = Mathf.Lerp(0f, 1f, RemainTime / (1f - JudgeOffset));

                Debug.Log(Fill);
                RhythmMat.SetFloat("Fill", Fill);
                RhythmSprite.SetPropertyBlock(RhythmMat);
            }
        }

        private void RotationRhyRange()
        {
            if (control.Direction == null) return;
            var mousePoint = (Vector3)control.Direction;
            mousePoint.Normalize();


            Vector3 curRot = RhythmRange.transform.eulerAngles;
            curRot.y = Mathf.Atan2(mousePoint.z, mousePoint.x) * -Mathf.Rad2Deg;


            RhythmRange.transform.eulerAngles = curRot;
        }

        public override void HandleInput(InteractionType interactionType)
        {
            switch (interactionType)
            {
                case InteractionType.DashEnter:
                       RhythmDirSprite.gameObject.SetActive(false);
                    StateMachine.ChangeState(e_PlayerState.Dash);
                    break;
                case InteractionType.CutEnter:
                    StateMachine.ChangeState(e_PlayerState.Cut);
                    break;
                case InteractionType.RhythmLate:
                    RhythmDirMat.SetFloat("Fill", 0f);
                    RhythmDirSprite.SetPropertyBlock(RhythmDirMat);
                    isRhythmEaly = false;
                    break;
                case InteractionType.RhythmEarly:
                    isRhythmEaly = true;
                    break;
                default:
                    StateMachine.Combo = 0;
                    break;
            }
        }
    }
}