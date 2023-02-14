using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine.Events;

public class CustomUpdate
{
    public Action Action { get; set; }
    public float Delay { get; set; }
    public MonoBehaviour Sender { get; private set; }

    private float _timer = 0.0f;

    private bool _async;

    
    public void OnUpdate()
    {
        _timer += Time.deltaTime;
        if (_timer >= Delay)
        {
            _timer = 0.0f;
            Action();
        }
    }

    public CustomUpdate(MonoBehaviour sender, Action action, float delay, bool async = true)
    {
        Sender = sender;
        Action = action;
        Delay = delay;
        _async = async;
    }
        
}
