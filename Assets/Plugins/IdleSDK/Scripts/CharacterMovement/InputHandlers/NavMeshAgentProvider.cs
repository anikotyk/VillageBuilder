using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.AI;

public class NavMeshAgentProvider
{
    private NavMeshAgent _navMeshAgent;

    private float _startSpeed;
    private List<SpeedModifier> _modifiers = new ();
    
    public NavMeshAgent SourceAgent => _navMeshAgent;
    public bool enabled
    {
        set
        {
            if(_navMeshAgent != null)
                _navMeshAgent.enabled = value;
        }
    }

    public float speed
    {
        get => _navMeshAgent.speed;
        private set => _navMeshAgent.speed = value;
    }

    public NavMeshAgentProvider(NavMeshAgent navMesh)
    {
        _navMeshAgent = navMesh;
        _startSpeed = speed;
    }

    public void AddModifier(SpeedModifier modifier)
    {
        var existedModifier = _modifiers.Find(x => x.Sender == modifier.Sender);
        if (existedModifier != null)
        {
            if(existedModifier.Modifier == modifier.Modifier)
                return;
            _modifiers.Remove(existedModifier);
        }
        _modifiers.Add(modifier);
        ActualizeModifiers();
    }

    public void RemoveModifier(object sender)
    {
        var modifier = _modifiers.Find(x => x.Sender == sender);
        if (modifier == null)
            return;
        
        _modifiers.Remove(modifier);
        ActualizeModifiers();
    }

    private void ActualizeModifiers()
    {
        float modifiedSpeed = _startSpeed;
        
        foreach (var modifier in _modifiers)
        {
            modifiedSpeed = modifier.CalculateSpeed(modifiedSpeed);
        }

        speed = modifiedSpeed;
    }
}