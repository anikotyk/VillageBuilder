using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[System.Serializable]
public class TaskProvider : InterfaceProvider<ITask>
{
    [RequireInterface(typeof(ITask))] public GameObject GameObject;
    protected override GameObject ObjectWithInterface => GameObject;
}
