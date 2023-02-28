using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Utilities;
using Zenject;

public class BuyZoneDeactivator : MonoBehaviour
{
    [SerializeField] private List<GameObject> _objectsToDeactivate;
    [SerializeField] private float _deactivateDelay;
    [SerializeField] private BuyZone _buyZone;

    [Inject] private Timer _timer;
    
    private void OnEnable()
    {
        _buyZone.Bought += OnBought;
    }

    private void OnDisable()
    {
        _buyZone.Bought -= OnBought;
    }

    private void OnBought()
    {
        _timer.ExecuteWithDelay(() =>
        {
            foreach (var objectToDeactivate in _objectsToDeactivate)
            {
                objectToDeactivate.SetActive(false);
            }
        }, _deactivateDelay);
    }
}

