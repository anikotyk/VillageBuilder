using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Utilities;
using Zenject;

public class HelperTaskResolver : MonoBehaviour
{
    [SerializeField] private Helper _helper;
    [SerializeField] private float _afkTime;

    [Inject] private Timer _timer;

    private TimerDelay _afkTimer;
    
    private void OnEnable()
    {
        _helper.AIMovement.OnStartMove += OnStartMove;
        _helper.AIMovement.OnStopMove += OnStopMove;
    }

    private void OnDisable()
    {
        _helper.AIMovement.OnStartMove -= OnStartMove;
        _helper.AIMovement.OnStopMove -= OnStopMove;
        _afkTimer?.Kill();
    }

    private void OnStartMove()
    {
        _afkTimer?.Kill();
    }

    private void OnStopMove()
    {
        _afkTimer?.Kill();
        _afkTimer = _timer.ExecuteWithDelay(_helper.NextTask, _afkTime);
    }
}
