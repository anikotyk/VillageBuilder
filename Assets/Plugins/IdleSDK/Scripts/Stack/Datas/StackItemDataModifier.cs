using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace IdleBasesSDK.Stack
{
    public struct StackItemDataModifier
    {
        public Vector3 Delta { get; private set; }
        public float Progress { get; private set; }
        public bool OverrideRotation { get; private set; }

        public StackItemDataModifier(Vector3 delta = new Vector3(), float progress = 0.0f, bool overrideRotation = false)
        {
            Delta = delta;
            Progress = progress;
            OverrideRotation = overrideRotation;
        }


        public StackItemDataModifier SetOverrideRotation(bool needToRotate)
        {
            OverrideRotation = needToRotate;
            return this;
        }

        public StackItemDataModifier SetDelta(Vector3 delta = new Vector3())
        {
            Delta = delta;
            return this;
        }

        public StackItemDataModifier SetProgress(float progress)
        {
            Progress = progress;
            return this;
        }
    }
}
