using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using IdleBasesSDK;
using UnityEngine.AI;
using UnityEngine.Events;
using Zenject;

public class NavMeshAgentHandler : MovementHandler
{
    [SerializeField] private NavMeshAgent _agent;
    [SerializeField] private float _receiveDestinationDistance;
    [SerializeField] private float _samplePositionRange = 5.0f;
    [SerializeField] private float _updateTime = 0.1f;
    public Vector3 _currentDestination = Vector3.zero;
    public Vector3 _navmeshDestination;

    public List<string> _logs = new List<string>();
    public UnityAction OnReceiveDestination { get; set; }

    [Inject] private Updater _updater;

    private List<object> _blockers = new List<object>();
    private NavMeshAgentProvider _agentProvider;

    public NavMeshAgentProvider Agent
    {
        get
        {
            if(_agentProvider == null)
                _agentProvider = new NavMeshAgentProvider(_agent);
            return _agentProvider;
        }
    } 
    
    public bool IsMoving { get; private set; }
  

    private void OnEnable()
    {
        _updater.Add(this, OnUpdate, _updateTime);
    }

    private void OnDisable()
    {
        _updater.Remove(this);
    }

    public override Vector3 GetInput()
    {
        return _currentDestination;
    }

    public override void DisableHandle(object sender)
    {
        _blockers.Add(sender);
        _agent.enabled = false;
        IsMoving = false;
    }

    public override void EnableHandle(object sender)
    {
        _blockers.Remove(sender);
        if (_blockers.Count == 0)
        {
            _agent.enabled = true;
        }
    }

    private void Update()
    {
        _navmeshDestination = _agent.destination;
    }

    private void OnUpdate()
    {
        if (IsMoving == false)
            return;

        Vector3 destination = _agent.destination;
        Vector3 position = _agent.transform.position;


        if (VectorExtentions.SqrDistance(destination, position) <= _receiveDestinationDistance*_receiveDestinationDistance)
        {
            StopMove();
        }
        else
        {
            OnMove?.Invoke(_currentDestination);
        }
        

    }
    
    public void SetDestination(Vector3 destination)
    {
        _logs.Add($"Try Set Destination {destination}");
        if (NavMesh.SamplePosition(destination, out NavMeshHit hit, _samplePositionRange, NavMesh.AllAreas))
        {
            IsMoving = true;
            Agent.enabled = true;
            _agent.SetDestination(hit.position);
            _currentDestination = hit.position;
            
            _logs.Add($"Set {_currentDestination}");
            OnStartMove?.Invoke();
        }
    }

    public void StopMove()
    {
        IsMoving = false;
        if(_agent.enabled) 
            _agent.ResetPath();
        OnStopMove?.Invoke();
        OnReceiveDestination?.Invoke();
    }

    
}
