using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Utilities;
using Zenject;

public class HealthPresenter : MonoBehaviour
{
    [SerializeField] private View _view;
    [SerializeField] private float _hideDelay;
    [SerializeField] private Health _health;

    [Inject] private Timer _timer;
    private TimerDelay _hideTimerDelay;
    
    private void OnEnable()
    {
        _health.Damaged += OnDamaged;
    }

    private void OnDisable()
    {
        _health.Damaged -= OnDamaged;
    }

    private void OnDamaged(int damage)
    {
        _view.Show();
        _hideTimerDelay?.Kill();
        _hideTimerDelay = _timer.ExecuteWithDelay(_view.Hide, _hideDelay);
    }
}
