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
        
        private float circleActivationTime;
        private float circleTargetTime;
        private float triangleActivationTime;
        private float triangleTargetTime;
        
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

            RhythmDirMat.SetFloat("Fill", 0f);
            RhythmDirSprite.SetPropertyBlock(RhythmDirMat);
            RhythmMat.SetFloat("Fill", 0f);
            RhythmSprite.SetPropertyBlock(RhythmMat);

            //TODO: 처음 씬이 실행되었을 때 RemainTime에 필요한 변수가 초기화되지 않았기 때문에 동작하지 않습니다.
            triangleTargetTime = Time.realtimeSinceStartup + (float)RhythmCore.Instance.RemainTime(false);
            triangleActivationTime = circleTargetTime = triangleTargetTime - (float)RhythmCore.Instance.JudgeOffset * 2;
            circleActivationTime = triangleTargetTime - (float)RhythmCore.Instance.RhythmDelay;
            FillRhyRange();
        }

        public override void LogicUpdate()
        {
            FillRhyRange();
            RotationRhyRange();
        }

        private void FillRhyRange()
        {
            RhythmDirMat.SetFloat("Fill",
                Mathf.InverseLerp(triangleActivationTime, triangleTargetTime, Time.realtimeSinceStartup));
            RhythmDirSprite.SetPropertyBlock(RhythmDirMat);
            RhythmMat.SetFloat("Fill",
                Mathf.InverseLerp(circleActivationTime, circleTargetTime, Time.realtimeSinceStartup));
            RhythmSprite.SetPropertyBlock(RhythmMat);
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
                default:
                    StateMachine.Combo = 0;
                    break;
            }
        }
        
        public override void OnRhythmLate()
        {
            RhythmDirMat.SetFloat("Fill", 0f);
            RhythmDirSprite.SetPropertyBlock(RhythmDirMat);

            circleActivationTime = Time.realtimeSinceStartup;
            triangleActivationTime = circleTargetTime =
                circleActivationTime + (float)RhythmCore.Instance.RemainTime(earlyLate: true, isFixed: true);
            triangleTargetTime = triangleActivationTime + (float)RhythmCore.Instance.JudgeOffset * 2;
        }
    }
}