using UnityEngine;
using IdleBasesSDK;

[System.Serializable]
public class MovementEventsProvider : InterfaceProvider<IMovementEvents>
{
    [RequireInterface(typeof(IMovementEvents))]
    public GameObject Object;

    protected override GameObject ObjectWithInterface => Object;
}
