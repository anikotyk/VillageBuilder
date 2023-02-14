using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine.Scripting;

namespace IdleBasesSDK.Stack
{
    [System.Serializable]
    public class StackProvider : InterfaceProvider<IStack>
    {
        [RequireInterface(typeof(IStack))] public GameObject GameObject;
        protected override GameObject ObjectWithInterface => GameObject;
    }
 
}
