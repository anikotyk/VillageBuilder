using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK;

[System.Serializable]
public class MovementHandlerProvider : InterfaceProvider<IMovementHandler>
{
    [RequireInterface(typeof(IMovementHandler))]
    public GameObject GameObject;

    protected override GameObject ObjectWithInterface => GameObject;
}
