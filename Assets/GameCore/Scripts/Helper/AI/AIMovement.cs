using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK;
using IdleBasesSDK.Utilities;
using UnityEngine.AI;
using UnityEngine.Events;

public class AIMovement : MonoBehaviour, IMovementHandler, IMovementEvents
{
    [SerializeField] private float _startSpeed;
    [SerializeField] private float _rotateSpeed;
    [SerializeField] private float _stopAngle = 1f;
    [SerializeField] private float _stopDistance;
    [SerializeField] private float _nextCornerDistance;
    [SerializeField] private float _accelerationSpeed;
    [SerializeField] private float _samplePositionRadius = 1f;

    private AISpeed _aiSpeed;
    private NavMeshPath _path;

    private AISpeed AiSpeed
    {
        get
        {
            _aiSpeed ??= new AISpeed(_startSpeed);
            return _aiSpeed;
        }
    }

    private NavMeshPath Path
    {
        get
        {
            _path ??= new NavMeshPath();
            return _path;
        }
    }


    private Vector3 _destination;
    private AIMovementStatus _pathStatus = AIMovementStatus.NotSet;
    private List<Vector3> _corners = new List<Vector3>();
    private List<object> _blockers = new List<object>();

    private float _accelerationProgress = 0.0f;
    private float ActualSpeed => _accelerationProgress * Speed;
    public float Speed => AiSpeed.Speed;
    public float StopDistance => _stopDistance;

    public UnityAction ReceivedDestination;
    public UnityAction OnStartMove { get; set; }
    public UnityAction<Vector3> OnMove { get; set; }
    public UnityAction OnStopMove { get; set; }
    public UnityAction<Vector3> Rotated { get; set; }
    
    private void OnEnable(){}
    private void OnDisable(){}

    private void Update()
    {
        if(_pathStatus != AIMovementStatus.InProcess || _corners.Count <= 1)
            return;

        Rotate();
        Move();

        if (TryReceiveDestination())
            return;

        ActualizeCornerData();
    }

    private void Rotate()
    {
        var targetRotation = GetRotation();
        var currentRotation = transform.rotation;
        
        float angle = Quaternion.Angle(currentRotation, targetRotation);
        float normalizedRotateSpeed = _rotateSpeed*_accelerationProgress / angle;
        
        transform.rotation = Quaternion.Lerp(currentRotation, targetRotation, normalizedRotateSpeed);
        Rotated?.Invoke(transform.rotation.eulerAngles - currentRotation.eulerAngles);
    }
    
    private Quaternion GetRotation()
    {
        var startRotation = transform.rotation;
        Vector3 destination = _destination;
        if (_corners.Count > 1)
        {
            destination = _corners[1];
        }
        transform.LookAt(destination);
        var destinationRotation = transform.rotation;
        transform.rotation = startRotation;
        return destinationRotation;
    }

    private void Move()
    {
        if (ActualSpeed < Speed)
            _accelerationProgress = Mathf.Clamp01((ActualSpeed + _accelerationSpeed * Time.deltaTime)/Speed);
        
        Vector3 moveVector = transform.forward * (ActualSpeed * Time.deltaTime);
        transform.position += moveVector;

        OnMove?.Invoke(moveVector);
    }

    private bool TryReceiveDestination()
    {
        if (VectorExtentions.SqrDistance(transform.position, _destination) > _stopDistance * _stopDistance ||
            Quaternion.Angle(transform.rotation, GetRotation()) > _stopAngle)
            return false;
        _pathStatus = AIMovementStatus.Completed;
        _path = new NavMeshPath();
        _corners.Clear();
        ReceivedDestination?.Invoke();
        OnStopMove?.Invoke();
        return true;
    }

    private void ActualizeCornerData()
    {
        if(VectorExtentions.SqrDistance(transform.position, _corners[1]) <= _nextCornerDistance*_nextCornerDistance)
        {
            _corners.Remove(_corners[1]);
            if (_corners.Count <= 1)
            {
                _pathStatus = AIMovementStatus.Completed;
                OnStopMove?.Invoke();
            }
        }
    }

    public void SetDestination(Vector3 destination)
    {
        if (VectorExtentions.SqrDistance(transform.position, destination) <= _stopDistance * _stopDistance)
            return;
        
        if (NavMesh.SamplePosition(destination, out NavMeshHit hit, _samplePositionRadius, NavMesh.AllAreas))
            destination = hit.position;
        
        if (NavMesh.CalculatePath(transform.position, destination, NavMesh.AllAreas, Path) == false)
        {
            _pathStatus = AIMovementStatus.NotSet;
            return;
        }

        _pathStatus = AIMovementStatus.InProcess;
        _destination = destination;
        _corners.Clear();
        _corners.AddRange(Path.corners);
        OnStartMove?.Invoke();
    }

    public void AddSpeedModifier(SpeedModifier speedModifier)
    {
        AiSpeed.AddModifier(speedModifier);
    }

    public void RemoveSpeedModifier(object sender)
    {
        AiSpeed.RemoveModifier(sender);
    }

    public void StopMove()
    {
        _pathStatus = AIMovementStatus.Stopped;
        OnStopMove?.Invoke();
    }

    public void ResumeMove(float delay = 0.0f)
    {
        
    }

    public void DisableHandle(object sender)
    {
        if(_blockers.Contains(sender))
            return;
        _blockers.Add(sender);
        enabled = false;
    }

    public void EnableHandle(object sender)
    {
        _blockers.Remove(sender);
        if (_blockers.Count == 0)
            enabled = true;
    }
}
