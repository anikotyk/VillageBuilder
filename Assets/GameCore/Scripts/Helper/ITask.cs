using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;

public interface ITask
{
    public bool AvailableToHelp { get; }
    public bool Active { get; }
    
    public Transform TaskPoint { get; }
    
    public UnityAction Finished { get; set; }

    public void UseTask();
}
