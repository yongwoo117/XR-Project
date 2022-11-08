using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
    }
}

namespace Enemy.Animation
{
    public static class AnimationParameter
    {
        public static readonly int Attack = Animator.StringToHash("Attack");
        public static readonly int Move = Animator.StringToHash("Move");
        public static readonly int Idle = Animator.StringToHash("Idle");
    }
}
