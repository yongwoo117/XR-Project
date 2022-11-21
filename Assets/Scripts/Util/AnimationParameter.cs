using UnityEngine;

namespace Player.Animation
{
    public static class AnimationParameter
    {
        public static readonly int Dash = Animator.StringToHash("Dash");
        public static readonly int Charge = Animator.StringToHash("Charge");
        public static readonly int Idle = Animator.StringToHash("Idle");
        public static readonly int Cut = Animator.StringToHash("Cut");
        public static readonly int Miss = Animator.StringToHash("Miss");
        public static readonly int Dead = Animator.StringToHash("Dead");
        public static readonly int Hit = Animator.StringToHash("Hit");
        public static readonly int CutIndex = Animator.StringToHash("CutIndex");
    }
}

namespace Enemy.Animation
{
    public static class AnimationParameter
    {
        public static readonly int Ready = Animator.StringToHash("Ready");
        public static readonly int Attack = Animator.StringToHash("Attack");
        public static readonly int Move = Animator.StringToHash("Move");
        public static readonly int Idle = Animator.StringToHash("Idle");
    }
}

namespace UI
{
    public static class AnimationParameter
    {
        public static readonly int Active = Animator.StringToHash("Active");
        public static readonly int idle = Animator.StringToHash("idle");
        public static readonly int highlighted = Animator.StringToHash("highlighted");
        public static readonly int fail = Animator.StringToHash("fail");
    }
}
