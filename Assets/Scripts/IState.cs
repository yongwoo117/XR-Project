

public interface IState 
{
    void Enter();
    void Exit();
    void RogicUpdate();
    void PhysicsUpdate();
    void HandleInput();

}
