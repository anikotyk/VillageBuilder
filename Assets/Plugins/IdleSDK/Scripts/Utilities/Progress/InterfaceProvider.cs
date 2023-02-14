using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

[System.Serializable]
public class ProgressibleProvider : InterfaceProvider<IProgressible>
{
    [SerializeField, RequireInterface(typeof(IProgressible))] public GameObject _progressibleObject;
    protected override GameObject ObjectWithInterface => _progressibleObject;
}
