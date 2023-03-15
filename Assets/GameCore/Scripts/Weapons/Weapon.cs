using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Upgrades;
using UnityEngine.Events;
using Zenject;
using IdleBasesSDK.Utilities;

public class Weapon : MonoBehaviour
{
    [SerializeField] private WeaponType _weaponType;
    [SerializeField] private UpgradeValue _damage;
    [SerializeField] private float _usingTime;
    [SerializeField] private float _reloadTime;
    [SerializeField] private float _endUseDelay;
    [SerializeField] private bool _autoReload;

    [Inject] private Timer _timer;

    private TimerDelay _reloadTimer = null;
    private TimerDelay _endUseTimer = null;

    public int Damage => _damage.ValueInt;
    public WeaponType Type => _weaponType;
    public float UseTime => _usingTime;
    public bool InUse;// { get; private set; } = false;

    public UnityAction<Weapon> StartUsing { get; set; }
    public UnityAction<Weapon> Used { get; set; }
    public UnityAction<Weapon> EndedUsing { get; set; }

    private void OnEnable()
    {
        Refresh();
    }

    private void OnDisable()
    {
        Refresh();
    }

    private void Refresh()
    {
        InUse = false;
        _reloadTimer?.Kill();
        _endUseTimer?.Kill();
    }

    public void Use()
    {
        if(InUse || enabled == false || gameObject.activeInHierarchy == false)
            return;

        InUse = true;
        if (_reloadTimer != null && _reloadTimer.Status != TimerStatus.Ended && _autoReload)
        {
            if (_reloadTimer.ActionsCount == 1)
                _reloadTimer.AddAction(StartUse);
            return;
        }
        StartUse();
        
    }

    public void AbortUse()
    {
        Refresh();
    }

    private void StartUse()
    {
        if(enabled == false || gameObject.activeInHierarchy == false)
            return;
        
        StartUsing?.Invoke(this);
        
        _endUseTimer?.Kill();
        _endUseTimer = null;

        _reloadTimer?.Kill();
        _reloadTimer = null;
        
        _timer.ExecuteWithDelay(EndIteration, _usingTime);
    }

    private void EndIteration()
    {
        if(enabled == false)
            return;
        if(_autoReload)
            InUse = false;
        _endUseTimer = _timer.ExecuteWithDelay(EndUse, _endUseDelay);
        if(_autoReload)
            _reloadTimer = _timer.ExecuteWithDelay(() => {  }, _reloadTime);
        Used?.Invoke(this);
    }

    private void EndUse()
    {
        Refresh();
        EndedUsing?.Invoke(this);
    }
}
