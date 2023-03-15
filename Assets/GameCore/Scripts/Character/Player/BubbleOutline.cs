using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using DG.Tweening.Core;

public class BubbleOutline : BubbleMoveListener
{
    [SerializeField] private Color _insideBubbleOutline;
    [SerializeField] private Color _outsideBubbleOutline;
    [SerializeField] private List<Outline> _outlines;
    [SerializeField] private float _outlineFadeDuration;

    private List<Tweener> _fadeTweeners = new List<Tweener>();
    
    protected override void OnInsideBubble()
    {
        ChangeColor(_insideBubbleOutline);
    }

    protected override void OnOutsideBubble()
    {
        ChangeColor(_outsideBubbleOutline);
    }
    
    private void ChangeColor(Color color)
    {
        foreach (var fadeTweener in _fadeTweeners)
            fadeTweener?.Kill();
        _fadeTweeners.Clear();
        
        foreach (var outline in _outlines)
        {
            var tweener = DOTween.To(() => outline.OutlineColor, x => outline.OutlineColor = x, color, _outlineFadeDuration);
            _fadeTweeners.Add(tweener);
        }
    }
}
