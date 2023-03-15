using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using UnityEngine.Polybrush;
using Zenject;

public class PlayerDeath : MonoBehaviour
{
    [SerializeField, Range(0, 100)] private float _deathLoseItemPercent;
    [SerializeField] private int _minResourceLose;
    [SerializeField] private float _lossApplyDelay;
    [Space]
    [SerializeField] private Health _health;
    
    [Inject] private Player _player;
    [Inject] private Timer _timer;
    
    private void OnEnable()
    {
        _health.Died += OnDied;
    }

    private void OnDisable()
    {
        _health.Died -= OnDied;
    }

    private void OnDied()
    {
        _timer.ExecuteWithDelay(ApplyDeathLoss, _lossApplyDelay, TimeScale.Scaled);
    }

    public Dictionary<ItemType, int> GetDeathLoss()
    {
        Dictionary<ItemType, int> loss = new Dictionary<ItemType, int>();
        foreach (var itemsPair in _player.Stack.MainStack.Items)
        {
            int itemCount = itemsPair.Value.Value;
            if(itemCount <= 0)
                continue;
            
            if (itemCount <= _minResourceLose)
            {
                loss.Add(itemsPair.Key, itemCount);
                continue;
            }

            int takeValue = (int)(itemCount * (_deathLoseItemPercent/100));
            loss.Add(itemsPair.Key, Mathf.Max(takeValue, _minResourceLose));
        }

        return loss;
    }

    private void ApplyDeathLoss()
    {
        var losses = GetDeathLoss();
        foreach (var loss in losses)
        {
            _player.Stack.MainStack.TrySpend(loss.Key, loss.Value);
        }
    }
    
}
