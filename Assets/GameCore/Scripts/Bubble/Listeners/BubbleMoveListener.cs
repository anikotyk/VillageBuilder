using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using Zenject;

public abstract class BubbleMoveListener : BubbleListener
{
    [SerializeField] private bool _listenPlayer = true;
    [SerializeField, HideIf(nameof(_listenPlayer))] private Transform _target;
    
    [Inject] protected Player Player;
    protected override Transform Target => _listenPlayer? Player.transform : _target;
    
    private void Update()
    {
        HandleLocation();
        InternalUpdate();
    }

    protected virtual void InternalUpdate()
    {
    }

    
}
