using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class ZoomAnimation : TweenAnimation<Transform>
{
    [SerializeField] private Vector3 _startScale = Vector3.zero;
    [SerializeField] private Vector3 _endScale = Vector3.one;
    [SerializeField] private Ease _ease = Ease.OutBack;
    [SerializeField] private float _duration = 1;
    protected override Tweener Animate()
    {
        Restore();
        return Animate(transform);
    }

    protected override void OnRestore()
    {
        transform.localScale = _startScale;
    }

    public override void Prepare(Transform source)
    {
        source.transform.localScale = _startScale;
    }

    public override Tweener Animate(Transform source)
    {
        return source.DOScale(_endScale, _duration).SetEase(_ease);
    }
}
