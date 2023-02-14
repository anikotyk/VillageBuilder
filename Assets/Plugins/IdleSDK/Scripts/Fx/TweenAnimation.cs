using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public abstract class TweenAnimation<T> : MonoBehaviour where T : Component
{
    [SerializeField] protected bool PlayOnEnable = true;
    private Tweener _animationTweener;
    
    private void OnEnable()
    {
        if(PlayOnEnable == false)
            return;
        
        Restore();
        _animationTweener = Animate();
    }

    private void OnDisable()
    {
        if(PlayOnEnable == false)
            return;
        Restore();
    }

    protected abstract Tweener Animate();

    protected void Restore()
    {
        _animationTweener?.Kill();
        OnRestore();
    }
    protected abstract void OnRestore();

    public abstract void Prepare(T source);
    public abstract Tweener Animate(T source);

}
