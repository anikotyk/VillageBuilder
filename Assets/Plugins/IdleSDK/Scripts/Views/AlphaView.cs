using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Utilities;
using Zenject;

public class AlphaView : View
{
    [SerializeField] private CanvasGroup _canvasGroup;
    [SerializeField] private float _duration;
    [SerializeField] private bool _hideOnStart;
    [SerializeField] private bool _changeActive;
    [SerializeField] private bool _autoHide;
    [SerializeField, ShowIf(nameof(_autoHide))] private float _hideDelay;
    [SerializeField] private bool _pause;
    
    
    private bool _isHidden;
    private Tweener _currentTweener;
    public override bool IsHidden => _isHidden;

    private void OnEnable()
    {
        if (_hideOnStart)
            Hide();
    }

    [Button("Show")]
    public override void Show()
    {
        _isHidden = false;
        DOTween.Kill(this);
        _currentTweener.Kill();
        if(_changeActive)
            _canvasGroup.gameObject.SetActive(true);
        _currentTweener = _canvasGroup.DOFade(1, _duration).SetUpdate(true);
        if (_autoHide)
            DOVirtual.DelayedCall(_hideDelay, Hide).SetId(this);
        if (_pause)
        {
            Time.timeScale = 0;
        }
    }

    [Button("Hide")]
    public override void Hide()
    {
        if (_pause)
        {
            Time.timeScale = 1;
        }
        _isHidden = true;
        _currentTweener.Kill();
        DOTween.Kill(this);
        _currentTweener = _canvasGroup.DOFade(0, _duration).SetUpdate(true).OnComplete(() =>
        {
            if(_changeActive == false)
                return;
            _canvasGroup.gameObject.SetActive(false);
        });
    }

    public void ForceHide()
    {
        _isHidden = true;
        _currentTweener.Kill();
        _canvasGroup.alpha = 0.0f;
    }
}
