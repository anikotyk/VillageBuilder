using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Utilities;
using Zenject;

public class DelayedEnabler : MonoBehaviour
{
    [SerializeField] private GameObject _target;
    [SerializeField] private float _delay;

    private float _timer = 0.0f;

    private void Update()
    {
        if(gameObject.activeSelf == false || _target.activeSelf)
            return;
        
        _timer += Time.unscaledDeltaTime;
        if(_timer >= _delay)
            _target.SetActive(true);
    }

    private void OnEnable()
    {
        _timer = 0.0f;
        _target.SetActive(false);
    }
    
    
}
