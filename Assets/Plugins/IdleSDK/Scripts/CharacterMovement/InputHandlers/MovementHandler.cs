using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;

namespace IdleBasesSDK
{
    public abstract class MovementHandler : MonoBehaviour, IMovementHandler, IMovementEvents
    {
        public UnityAction OnStartMove { get; set; }
        public UnityAction OnStopMove { get; set; }
        public UnityAction<Vector3> OnMove { get; set; }
        public abstract Vector3 GetInput();

        public abstract void DisableHandle(object sender);
        public abstract void EnableHandle(object sender);
    }
}

