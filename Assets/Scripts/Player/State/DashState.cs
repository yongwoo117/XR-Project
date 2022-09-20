using System;
using UnityEngine;

public class DashState : State
{
    private float physicsCurveArea;
    private float dashingTime;
    private float dashTime;
    private AnimationCurve dashGraph;
    private Rigidbody rigid;
    private Vector3 pointDir;

    #region StateFunction
    public override void Enter()
    {
        Debug.Log("Dash Enter");

        Reset(); //초기 변수 초기화
        IntegralPhysicsGraph(); //물리 그래프 적분 함수
    }

    public override void PhysicsUpdate()
    {
        ApplyDashPhysics();
    }

    public override void HandleInput(InteractionType interactionType)
    {
        switch (interactionType)
        {
            case InteractionType.Primary:
                break;
            case InteractionType.Secondary:
                m_stateMachine.ChangeState(e_State.Idle);
                break;
            case InteractionType.Wrong:
                //m_stateMachine.ChangeState(e_State.Idle);
                break;
            default:
                throw new ArgumentOutOfRangeException(nameof(interactionType), interactionType, null);
        }
    }

    public override void Exit()
    {
        Debug.Log("Dash Exit");

        rigid.velocity = Vector3.zero; //대쉬 시간이 끝났으면 플레이어를 멈춰줌
        base.Exit();
    }
    #endregion


    /// <summary>
    /// 초기 변수들 초기화
    /// </summary>
    private void Reset()
    {
        PlayerStateMachine playerStateMachine = m_stateMachine as PlayerStateMachine;

        physicsCurveArea = 0f;

        dashGraph = playerStateMachine.playerProfil.dashPhyscisGrph;
        dashTime = playerStateMachine.playerProfil.f_dashTime;
        pointDir = playerStateMachine.PointDir;
        rigid = playerStateMachine.rigid;

        dashingTime = dashTime;

        Debug.DrawRay(playerStateMachine.transform.position, pointDir, Color.green, 1f);
    }

    /// <summary>
    /// 초기에 애니메이션 그래프를 fixedDeltaTime 주기에 맞게 적분하여 그래프 전체 영역을 구함
    /// </summary>
    private void IntegralPhysicsGraph()
    {
        for (float i = 0; i < dashTime; i += Time.fixedDeltaTime)
        {
            physicsCurveArea += dashGraph.Evaluate(i);
        }
    }

    /// <summary>
    /// 그래프를 통해서 목표 지점 까지 물리 적용
    /// 목표지점 까지의 속력: pointDir / dashTime 
    /// 물리 이동 시 전체 영역: (dashTime / Time.fixedDeltaTime)
    /// 사용할 그래프의 전체 영역: physicsCurveArea
    /// 현제 시간에서의 그래프 값: dashGraph.Evaluate(dashTime - dashingTime)
    /// 요약: 목표지점 까지의 속력값이 1이고 사용할 그래프 값이 1로 고정됐을때, 전체 이동 거리는 대쉬시간에 프레임 수와 같다.
    /// 그렇기 때문에 사용할 그래프의 영역을 대쉬시간 프레임으로 나눠주면 그래프 값에 1에 대한 변경된 속도 계산이 가능해진다.
    /// </summary>
    private void ApplyDashPhysics()
    {
        if (dashingTime <= 0f)
        {
            m_stateMachine.ChangeState(e_State.Idle); //대쉬 시간이 끝이면 Idle로 상태 변환
        }
        else
            rigid.velocity = pointDir / dashTime * ((dashTime / Time.fixedDeltaTime) / physicsCurveArea) * dashGraph.Evaluate(dashTime - dashingTime); //대쉬 시간이 끝이 아니면 그래프에 값 만큼 물리 적용

        dashingTime -= Time.deltaTime; 
    }
}


