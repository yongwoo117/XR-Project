using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

public class PlayerStateMachine : StateMachine<e_PlayerState,PlayerState>
{
    /// <summary>
    /// RhythmFlag의 값이 변경되면 RhythmFlag의 값과 함께 Callback됩니다.
    /// </summary>
    public UnityEvent<bool> onRhythmFlagChanged;
    
    private Plane rayCastPlane;
    
    //true면 노트를 칠 수 있고, false면 칠 수 없습니다.
    private bool RhythmFlag
    {
        get => rhythmFlag;
        set
        {
            rhythmFlag = value;
            onRhythmFlagChanged?.Invoke(rhythmFlag);
        }
    }
    private bool rhythmFlag;

    private Vector3 Direction;

    protected override e_PlayerState StartState => e_PlayerState.Idle;
    protected override IStateDictionary<e_PlayerState, PlayerState> StateDictionary => new PlayerStateDictionary();

    protected override void Start()
    {
        base.Start();
        rhythmFlag = true;
        rayCastPlane = new Plane(Vector3.up, -transform.position.y);
    }

    private void Update()
    {
        currentState?.LogicUpdate();
    }

    private void FixedUpdate()
    {
        currentState?.PhysicsUpdate();
    }

    private void OnDrawGizmos()
    {

        //대쉬 스테이트가 있으면 대쉬 범위 기즈모로 그려줌
        if(StateDictionary.ContainsState(e_PlayerState.Dash))
        {
            if(currentState==StateDictionary.GetState(e_PlayerState.Dash))
            {
                Vector3 dashAttackRange = new Vector3(Direction.magnitude, PlayerVariables.Instance.Profile.v3_dashRange.y, PlayerVariables.Instance.Profile.v3_dashRange.z);

                Gizmos.matrix = Matrix4x4.TRS(transform.position, Quaternion.Euler(0f, Mathf.Atan2(Direction.z, Direction.x)*-Mathf.Rad2Deg,0f), transform.localScale);
                Gizmos.DrawWireCube(Vector3.right * (Direction.magnitude * 0.5f), dashAttackRange);
            }
        }
    }

    public void OnRhythmLate()
    {
        //노트를 놓친 경우
        if (!RhythmFlag)
            currentState?.HandleInput(InteractionType.Wrong, null);
        
        //노트가 지나갔으므로 칠 수 있게 해둡니다.
        RhythmFlag = true;
    }


    #region Input
    //TODO: 인풋 로직 FSM 로직과 분리 필요
    private void OnInteraction(InteractionType interactionType, object arg)
    {
        //모든 조건식이 참인 경우 interactionType을 넘깁니다.
        //리듬에 맞지 않거나, 이미 한 번 처리했던 노트인 경우 Wrong을 넘깁니다.
        currentState?.HandleInput(RhythmFlag && RhythmCore.Instance.Judge() ? interactionType : InteractionType.Wrong,
            arg);
        RhythmFlag = false;
    }

    public void OnPrimaryInteraction(InputAction.CallbackContext context)
    {
        //필요 없는 이벤트를 걸러냅니다.
        if (!context.performed) return;
        
        OnInteraction(InteractionType.Primary, null);
    }

    public void OnSecondaryInteraction(InputAction.CallbackContext context)
    {
        //필요 없는 이벤트를 걸러냅니다.
        if (!context.performed) return;
        
        var ray = Camera.main.ScreenPointToRay(Mouse.current.position.ReadValue());
        
        if (!rayCastPlane.Raycast(ray, out float distance))
        {
            Debug.Log("Somethings wrong with rayCastPlane");
            return;
        }

        Direction = ray.GetPoint(distance) - transform.position;
        OnInteraction(InteractionType.Secondary, Direction);
    }
    #endregion
}