using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Utilities;
using Zenject;

public class Enabler : MonoBehaviour
{
    [SerializeField] private List<GameObject> _objectsToEnable;
    [SerializeField] private float _enableDelay;

    [Inject] private Timer _timer;

    private void OnEnable()
    {
        foreach (var objectToEnable in _objectsToEnable)
            objectToEnable.SetActive(false);
            
        _timer.ExecuteWithDelay(() =>
        {
            foreach (var objectToEnable in _objectsToEnable)
                objectToEnable.SetActive(true);
        }, _enableDelay);
    }
}
