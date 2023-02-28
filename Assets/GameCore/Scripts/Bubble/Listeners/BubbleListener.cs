using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public abstract class BubbleListener : MonoBehaviour
{
    [Inject] protected Bubble Bubble;
    protected abstract Transform Target { get; }
    
    protected void HandleLocation()
    {
        if (Bubble.IsLocateInside(Target.position))
            OnInsideBubble();
        else
            OnOutsideBubble();
    }

    protected abstract void OnInsideBubble();
    protected abstract void OnOutsideBubble();
}
