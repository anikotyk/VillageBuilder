using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using DG.Tweening;
using IdleBasesSDK.Utilities;
using Zenject;

public class BubbleCameraFx : MonoBehaviour
{
    [SerializeField] private Transform _cameraWrapper;
    [SerializeField] private CinemachineVirtualCamera _camera;
    [SerializeField] private float _showDelay;
    [SerializeField] private float _showTime;

    [Inject] private Bubble _bubble;
    [Inject] private Timer _timer;

    private TimerDelay _showTimerDelay;
    private TimerDelay _hideTimerDelay;
    
    private void OnEnable()
    {
        _bubble.StartScaling += OnScaled;
    }

    private void Start()
    {
        Kill();
        Hide();
    }
    private void OnDisable()
    {
        _bubble.StartScaling -= OnScaled;
    }

    private void OnScaled(float targetScale)
    {
        _cameraWrapper.localScale = Vector3.one * targetScale;
        Kill();
        DOVirtual.DelayedCall(_showDelay, Show).SetId(_showDelay);
        DOVirtual.DelayedCall(_showDelay + _showTime, Hide).SetId(_showTime);
    }

    private void Kill()
    {
        DOTween.Kill(_showDelay);
        DOTween.Kill(_showTime);
    }

    private void Show() => _camera.gameObject.SetActive(true);
    private void Hide() => _camera.gameObject.SetActive(false);
}
