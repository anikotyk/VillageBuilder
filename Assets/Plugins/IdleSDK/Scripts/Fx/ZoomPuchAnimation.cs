using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class ZoomPuchAnimation : TweenAnimation<Transform>
{
    [SerializeField] private Vector3 _punch;
    [SerializeField] private float _duration = 1;
    protected override Tweener Animate()
    {
        Restore();
        return Animate(transform);
    }

    protected override void OnRestore()
    {
        Prepare(transform);
    }

    public override void Prepare(Transform source)
    {
        source.transform.localScale = Vector3.one;
    }

    public override Tweener Animate(Transform source)
    {
        return source.DOPunchScale(_punch, _duration, 2);
    }
}
