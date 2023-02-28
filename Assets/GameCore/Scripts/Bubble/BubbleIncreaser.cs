using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Utilities;
using Zenject;

public class BubbleIncreaser : MonoBehaviour
{
    [SerializeField] private BuyZone _buyZone;
    [SerializeField] private float _targetScale;

    [Inject] private Bubble _bubble;
    
    private void OnEnable()
    {
        if (_buyZone.IsBought())
        {
            OnBought();
            return;
        }
        _buyZone.Bought += OnBought;
    }

    private void OnDisable()
    {
        _buyZone.Bought -= OnBought;
    }

    private void OnBought()
    {
        _bubble.Increase(_targetScale);
        _buyZone.Bought -= OnBought;
    }
}
