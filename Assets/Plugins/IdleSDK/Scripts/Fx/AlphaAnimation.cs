using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using NaughtyAttributes;

public class AlphaAnimation : TweenAnimation<CanvasGroup>
{
    [SerializeField, ShowIf(nameof(PlayOnEnable))] private CanvasGroup _canvasGroup;
    [SerializeField, Range(0, 1)] private float _startValue;
    [SerializeField, Range(0, 1)] private float _endValue;
    [SerializeField] private float _duration = 0.5f;
    protected override Tweener Animate()
    {
        return Animate(_canvasGroup);
    }

    public override void Prepare(CanvasGroup source)
    {
        source.alpha = _startValue;
    }

    public override Tweener Animate(CanvasGroup source)
    {
        Restore();
        return source.DOFade(_endValue, _duration).SetUpdate(true);
    }
    protected override void OnRestore()
    {
        _canvasGroup.alpha = _startValue;
    }

    
}
