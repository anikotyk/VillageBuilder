using UnityEngine;
using System.Collections;
using System.Collections.Generic;


public abstract class InterfaceProvider<TInterface> where TInterface : class
{
    protected abstract GameObject ObjectWithInterface { get; }

    private TInterface _interface = null;

    public TInterface Interface
    {
        get
        {
            if (_interface == null)
                _interface = ObjectWithInterface.GetComponent<TInterface>();
            return _interface;
        }
    }
}
