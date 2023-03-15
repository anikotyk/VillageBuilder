using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using IdleBasesSDK;

public class PulseAnimation : MonoBehaviour
{
    [SerializeField] private float _duration;
    [SerializeField] private float _fromScale;
    [SerializeField] private float _toScale;

    private void OnEnable()
    {
        DOTween.Kill(this);
        transform.localScale = _fromScale * Vector3.one;
        transform.DOPulse(_fromScale, _toScale, _duration).SetLoops(-1).SetId(this);
    }

    private void OnDisable()
    {
        DOTween.Kill(this);
    }
}
