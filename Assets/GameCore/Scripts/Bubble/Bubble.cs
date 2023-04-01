using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Utilities;
using UnityEngine.Events;
using Zenject;

public class Bubble : MonoBehaviour
{
    [SerializeField] private float _startSize;
    [SerializeField] private SphereSize _size;
    [SerializeField] private float _zoomTime;
    [SerializeField] private float _zoomDelay;
    [SerializeField] private Ease _zoomEase;
    [Header("Debug")] 
    [SerializeField] private float _sizeToIncrease = 1f;

    [Inject] private Timer _timer;
    private TimerDelay _timerDelay;
    
    
    private float _additionalScale = 0.0f;
    private float _targetScale = 0.0f;

    
    private TimerDelay _zoomTimerDelay;
    private Tweener _zoomTweener;
    
    public UnityAction<float> Scaled { get; set; }
    public UnityAction<float> StartScaling { get; set; }
    public UnityAction EndScale { get; set; }
    
    public float TargetScale => _targetScale;
    public bool IsScaling { get; private set; }
    
    private void Start()
    {
        Increase(_startSize, false);
        _timerDelay = _timer.ExecuteWithDelay(() =>
        {
            Debug.Log($"Start with bubble size {_targetScale}");
        }, 5f);
    }

    public void Increase(float targetScale, bool enableAnalysis = true)
    {
        if (_targetScale > targetScale)
            return;

        _targetScale = targetScale;
        
        IsScaling = true;
        StartScaling?.Invoke(_targetScale);
        
        _zoomTimerDelay?.Kill();
        _zoomTimerDelay =_timer.ExecuteWithDelay(Zoom, _zoomDelay);
        if (_timerDelay is { Status: TimerStatus.Ended })
        {
            Debug.Log($"Bubble size {_targetScale}");
        }

    }

    private void Zoom()
    {
        _zoomTweener?.Kill();
        _zoomTweener = DOTween.To(() => _additionalScale, value =>
        {
            _additionalScale = value;
            Scaled?.Invoke(_additionalScale);
        }, 
        _targetScale, _zoomTime)
        .SetEase(_zoomEase)
        .OnComplete(()=>
        {
            IsScaling = false;
            EndScale?.Invoke();
        });
    }
    
    

    public bool IsLocateInside(Vector3 position)
    {
        return IsLocateInside(position, _additionalScale);
    }
    
    public bool IsLocateInside(Vector3 position, float bubbleCoefficient)
    {
        return GetSquaredDistanceFromCenter(position) <= Mathf.Pow(_size.RawRadius * bubbleCoefficient, 2);
    }

    public float GetSquaredDistanceToBubble(Vector3 position)
    {
        return GetSquaredDistanceFromCenter(position) - Mathf.Pow(_size.RawRadius * _additionalScale, 2);
    }
    
    private float GetSquaredDistanceFromCenter(Vector3 position)
    {
        float x = Mathf.Pow(position.x - _size.Center.x, 2);
        float z = Mathf.Pow(position.z - _size.Center.z, 2);
        return x + z;
    }

    [Button("Increase")]
    private void Increase()
    {
        Increase(_sizeToIncrease);
    }
}
