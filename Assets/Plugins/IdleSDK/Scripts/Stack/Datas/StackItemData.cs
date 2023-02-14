using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace IdleBasesSDK.Stack
{
    public class StackItemData
    {
        public StackItem Target { get; }
        public Transform DestinationPoint { get; private set; }
        public Vector3 Delta => Modifier.Delta;
        public float Progress => Modifier.Progress;
        public bool OverrideRotation => Modifier.OverrideRotation;

        public StackItemDataModifier Modifier { get; private set; } = new StackItemDataModifier();

        public StackItemData(StackItem targetItem)
        {
            Target = targetItem;
        }

        public StackItemData AddDestination(Transform destination)
        {
            DestinationPoint = destination;
            return this;
        }

        public StackItemData ApplyModifier(StackItemDataModifier modifier)
        {
            Modifier = modifier;
            return this;
        }
    }
}