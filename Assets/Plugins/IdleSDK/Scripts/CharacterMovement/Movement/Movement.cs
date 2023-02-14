using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.Events;

namespace IdleBasesSDK
{
    public abstract class Movement : MonoBehaviour
    {
        [SerializeField] private MovementHandler _handler;

        private const float Tolerance = 0.1f;
       
        protected abstract float CurrentSpeed { get; }

        public abstract bool IsMoving { get; }
        public abstract float ActualSpeed { get; }
        
        public MovementHandler Handler => _handler;

    } 
}

