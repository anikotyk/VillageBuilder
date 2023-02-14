using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace IdleBasesSDK.Stack
{
    public class TakeData
    {
        public StackItem Target { get; }
        public Transform DestinationPoint { get; }
        public Vector3 Delta { get; private set;}
        public float Progress { get; private set;}
        public bool NeedToRotate { get; private set; } = false;

        public TakeData(StackItem targetItem, Transform destinationPoint, Vector3 delta = new Vector3(), float progress = 0.0f)
        {
            Target = targetItem;
            DestinationPoint = destinationPoint;
            Delta = delta;
            Progress = progress;
        }

    }
}

