using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Upgrades;
using IdleBasesSDK.Utilities;
using UnityEngine.Events;
using Zenject;

public class OutsideTimer : IProgressible
{
    [SerializeField] private UpgradeValue _torchUpgrade;
    [SerializeField] private float _regenerationSpeed = 2;
    [SerializeField] private float _startRegenerationDelayTime;

    [Inject] private Timer _timer;

    private TimerDelay _startRegenerationDelay;
    
    private float _wastedTime = 0;
    private bool _insideBubble = true;
    private bool _disabled = false;
    
    private float WastedTime
    {
        get => _wastedTime;
        set
        {
            _wastedTime = value;
            ProgressChanged?.Invoke(Progress);
        }
    }

    private float OutsideSafeTime => _torchUpgrade.Value;
    
    public float Progress => _wastedTime / OutsideSafeTime;
    
    public UnityAction<float> ProgressChanged { get; set; }

    protected void InternalUpdate()
    {
        if (_insideBubble)
        {
            float newWastedTime = WastedTime - (Time.deltaTime * _regenerationSpeed);
            WastedTime = Mathf.Max(0, newWastedTime);
            if (newWastedTime < OutsideSafeTime && _disabled)
            {
                _disabled = false;
            }
        }
        else
        {
            float newWastedTime = WastedTime + Time.deltaTime;
            WastedTime = Mathf.Min(OutsideSafeTime, WastedTime + Time.deltaTime);
            if (newWastedTime >= OutsideSafeTime && _disabled == false)
            {
                _disabled = true;
            }
        }
    }

    protected void OnInsideBubble()
    {
        _startRegenerationDelay = _timer.ExecuteWithDelay(() => _insideBubble = true, _startRegenerationDelayTime);
    }

    protected void OnOutsideBubble()
    {
        _startRegenerationDelay?.Kill();
        _insideBubble = false;
    }
}
