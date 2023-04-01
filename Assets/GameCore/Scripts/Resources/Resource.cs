using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using UnityEngine.Events;
using Zenject;

public class Resource : StackItem, ISellable
{
    [SerializeField] private Sprite _icon;
    [SerializeField] private bool _isSellable;
    [SerializeField, ShowIf(nameof(_isSellable))] private int _sellPrice;
    [Space]
    [SerializeField] private Collider _collider;
    [SerializeField] private float _timeToEnableCollect;
    [SerializeField] private List<GameObject> _disableOnClaim;
    public Sprite Icon => _icon;
    public bool IsSellable => _isSellable;
    public int SellPrice => _sellPrice;
    
    [Inject] private Timer _timer;
    private TimerDelay _spawnTimer;

    private void OnEnable()
    {
        _collider.enabled = false;
        if(IsClaimed == false)
            _spawnTimer = _timer.ExecuteWithDelay(() =>
            {
                if(IsClaimed == false) 
                    _collider.enabled = true;
            }, _timeToEnableCollect);
    }

    public override void UnClaim()
    {
        Restore();
        _collider.enabled = true;
        UnClaimed?.Invoke(this);
    }

    public override void OnClaim()
    {
        IsClaimed = true;
        _collider.enabled = false;
        _disableOnClaim.ForEach(x=> x.SetActive(false));
    }

    public override void Restore()
    {
        IsClaimed = false;
        _disableOnClaim.ForEach(x=> x.SetActive(true));
    }
}
