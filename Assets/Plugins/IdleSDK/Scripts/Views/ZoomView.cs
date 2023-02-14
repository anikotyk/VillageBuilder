using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Utilities;
using Zenject;

public class ZoomView : View
{
    [SerializeField] private Transform _objectToZoom;
    [SerializeField] private float _showZoom;
    [SerializeField] private float _hideZoom;
    [SerializeField] private float _duration;
    [SerializeField] private bool _showOnStart;
    [SerializeField] private bool _hideOnStart;
    [SerializeField] private bool _changeActive;
    [SerializeField] private Ease _ease = Ease.InSine;
    [SerializeField] private bool _differentHideEase;
    [SerializeField, ShowIf(nameof(_differentHideEase))] private Ease _hideEase = Ease.InSine;

    [SerializeField] private bool _autoHide;
    [SerializeField, ShowIf(nameof(_autoHide))] private float _autoHideDelay;

    [Inject] private Timer _timer;
    
    private bool _isHidden;
    private Tweener _currentTweener;
    private TimerDelay _currentHidedDelay = null;

    public override bool IsHidden => _isHidden;

    private void OnEnable()
    {
        if (_hideOnStart)
            Hide();
        if (_showOnStart)
            Show();
    }

    public override void Show()
    {
        if(_isHidden == false)
            return;
        if(_changeActive)
            _objectToZoom.gameObject.SetActive(true);
        if (_currentHidedDelay != null)
        {
            _currentHidedDelay.Kill();
            _currentHidedDelay = null;
        }

        _isHidden = false;
        _currentTweener.Kill();
        _currentTweener = _objectToZoom.DOScale(Vector3.one*_showZoom, _duration).SetEase(_ease);
        if (_autoHide)
        {
            _currentHidedDelay = _timer.ExecuteWithDelay(Hide, _autoHideDelay);
        }
    }

    public override void Hide()
    {
        _isHidden = true;
        _currentTweener?.Kill();
        if(_currentHidedDelay != null)
            return;
        
        _currentHidedDelay?.Kill();
        if (_objectToZoom != null && _objectToZoom.gameObject.activeSelf)
        {
            Ease ease = _differentHideEase ? _hideEase : _ease;
            _currentTweener = _objectToZoom.DOScale(Vector3.one * _hideZoom, _duration).SetEase(ease).OnComplete(Disable);
        }
    }

    private void Disable()
    {
        if (_changeActive)
        {
            _currentTweener?.Kill();
            _objectToZoom.gameObject.SetActive(false);
        }
    }

}
