using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class MoveTween
{
    private Transform _target;
    private Transform _destinationPoint;
    private MoveFx _moveFx;

    private Vector3 _destinationDelta = Vector3.zero;
    private bool _changeParent = false;
    private float _yProgress = 0.0f;
    private bool _localMove = false;

    private bool _enableOffsets = true;

    private TweenCallback _onComplete;
    
    public MoveTween(Transform target, Transform destinationPoint, MoveFx moveFx)
    {
        _target = target;
        _destinationPoint = destinationPoint;
        _moveFx = moveFx;
        Start();
    }

    public MoveTween SetDestinationDelta(Vector3 destinationDelta)
    {
        _destinationDelta = destinationDelta;
        return this;
    }

    public MoveTween SetLocalMove(bool localMove)
    {
        _localMove = localMove;
        return this;
    }

    public MoveTween SetProgress(float progress)
    {
        _yProgress = progress;
        return this;
    }

    public MoveTween SetChangeParent(bool changeParent)
    {
        _changeParent = changeParent;
        return this;
    }

    public MoveTween OnComplete(TweenCallback callback)
    {
        _onComplete = callback;
        return this;
    }

    public MoveTween DisableOffsets()
    {
        _enableOffsets = false;
        return this;
    }

    public MoveTween Start()
    {
        Vector3 startPosition = _target.position;
        Quaternion startRotation = _target.rotation;
        var tweener =  DOVirtual.Float(0, 1, _moveFx.Duration, progress =>
        {
            float slideEvaluate = Mathf.Clamp(_moveFx.SlideCurve.Evaluate(progress), 0f, 1f);
            
            Vector3 destination = _destinationPoint.rotation * _destinationDelta + _destinationPoint.position;
            Vector3 slideFrameDelta = Vector3.Lerp(startPosition, destination, slideEvaluate);
            
            Quaternion frameRotation = Quaternion.Lerp(startRotation, _destinationPoint.rotation, slideEvaluate);
            
            Vector3 yFrameOffset = new Vector3(0, _moveFx.YCurve.Evaluate(progress) * (_moveFx.YDecreaseCurve.Evaluate(_yProgress) * _moveFx.YOffset), 0);
            Vector3 xFrameOffset = new Vector3((_moveFx.YCurve.Evaluate(progress)) * _moveFx.XOffset, 0, 0);
            
            if (_target != null)
            {
                Vector3 offsets = _enableOffsets ? xFrameOffset + yFrameOffset : Vector3.zero;
                var tempPoint = offsets + slideFrameDelta;
                if (float.IsNaN(tempPoint.y)) tempPoint.y = 0.0f;
                _target.position = tempPoint;
                if(_moveFx.Rotate)
                    _target.rotation = frameRotation;
            }
        }).SetEase(Ease.Linear).SetId(_target);

        tweener.onComplete += () =>
        {
            if (_changeParent && _target != null)
            {
                _target.SetParent(_destinationPoint);
                _target.localPosition = _destinationDelta;
                if (_localMove)
                {
                    _target.localPosition = _destinationDelta;
                    if(_moveFx.Rotate)
                        _target.localRotation = Quaternion.identity;
                }
            }

            _onComplete?.Invoke();
        };

        return this;
    }
}
