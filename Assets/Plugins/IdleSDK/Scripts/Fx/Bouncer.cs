using System;
using UnityEngine;
using System.Linq;
using System.Collections.Generic;
using NaughtyAttributes;

public class Bouncer : MonoBehaviour
{
    [SerializeField, HideIf(nameof(_rect))] private Transform _targetTransform;
    [SerializeField, ShowIf(nameof(_rect))] private RectTransform _rectTransform;
    [SerializeField] private bool _rect = false;
    [SerializeField] private float _iterationScale;
    [SerializeField] private float _maxScale;
    [SerializeField] private float _zoomOutSpeed;
    [SerializeField] private List<Bouncer> _linkedBouncer;

    private float _additionalScale = 0.0f;
    private Vector3 _startScale = Vector3.one;


    public void Bounce()
    {
        _additionalScale += _iterationScale;
        _additionalScale = Mathf.Clamp(_additionalScale, 0, _maxScale);
        SetScale(_startScale + Vector3.one * _additionalScale);
        foreach (var bouncer in _linkedBouncer)
        {
            bouncer.Bounce();
        }
    }

    private void Update()
    {
        if (_additionalScale <= 0)
            return;

        SetScale(Vector3.Lerp(GetScale(), _startScale, Time.deltaTime * _zoomOutSpeed));
        _additionalScale -= Time.deltaTime * _zoomOutSpeed * _iterationScale;
        _additionalScale = Mathf.Clamp(_additionalScale, 0, _maxScale);
    }

    private void SetScale(Vector3 scale)
    {
        if (_rect)
            _rectTransform.localScale = scale;
        else
            _targetTransform.localScale = scale;
    }

    private Vector3 GetScale()
    {
        if (_rect)
            return _rectTransform.localScale;
        
        return _targetTransform.localScale;
    }
    
}
