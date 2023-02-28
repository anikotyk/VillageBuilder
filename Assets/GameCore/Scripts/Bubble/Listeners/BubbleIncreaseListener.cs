using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public abstract class BubbleIncreaseListener : BubbleListener
{ 
    private void OnEnable()
    {
        HandleLocation();
        Bubble.Scaled += OnBubbleScaled;
    }

    private void OnDisable()
    {
        Bubble.Scaled -= OnBubbleScaled;
    }

    private void OnBubbleScaled(float scale)
    {
        HandleLocation();
    }
}
