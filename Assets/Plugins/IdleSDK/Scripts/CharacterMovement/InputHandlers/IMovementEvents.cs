using UnityEngine;
using UnityEngine.Events;

namespace IdleBasesSDK
{
    public interface IMovementEvents
    {
        public UnityAction OnStartMove { get; set; }
        public UnityAction OnStopMove { get; set; }
        public UnityAction<Vector3> OnMove { get; set; }
    }
}