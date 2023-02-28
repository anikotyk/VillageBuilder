using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using Zenject;
using IdleBasesSDK.Utilities;

public class BubbleHider : MonoBehaviour
{
    [SerializeField] private float _hideDelay;
    [SerializeField] private View _view;
    [SerializeField] private bool _hide;

    [Inject] private Bubble _bubble;

    private void OnEnable()
    {
        _bubble.EndScale += OnEndScale;
    }

    private void OnDisable()
    {
        _bubble.EndScale -= OnEndScale;
    }

    private void OnEndScale()
    {
        if(_hide == false)
            return;

        if (_bubble.IsLocateInside(transform.position))
            DOVirtual.DelayedCall(_hideDelay, _view.Hide);
    }
    
}
