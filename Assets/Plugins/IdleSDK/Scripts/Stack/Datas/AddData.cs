using UnityEngine;

namespace IdleBasesSDK.Stack
{
    public class AddData
    {
        public StackItem Target { get; }
        public Vector3 DestinationDelta { get; }

        public AddData(StackItem targetItem, Vector3 destinationDelta)
        {
            Target = targetItem;
            DestinationDelta = destinationDelta;
        }
    }
}
