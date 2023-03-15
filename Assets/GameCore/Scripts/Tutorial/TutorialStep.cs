using System;
using UnityEngine;
using NaughtyAttributes;
using UnityEngine.Events;
using Zenject;

public class TutorialStep : MonoBehaviour
{
    [SerializeField] private string _id;
    [SerializeField] private bool _activeSelf;
    [SerializeField] private Transform _targetPoint;
    [SerializeField, HideIf(nameof(_lastStep))] private TutorialStep _nextStep;
    [SerializeField] private TutorialEventProvider _tutorialEvent;
    [SerializeField] private bool _lastStep;

    [Inject] private TutorialPointer _tutorialPointer;

    public ITutorialEvent Event => _tutorialEvent.Interface;
    public event UnityAction<TutorialStep> Entered;
    public event UnityAction<TutorialStep> Exited;
    
    private void Start()
    {
        if(_activeSelf)
            Enter();
    }

    private void Enter()
    {
        if(_tutorialEvent == null)
            return;
        
        
        if (_tutorialEvent.Interface.IsFinished() || ES3.Load(_id, false))
        {
            NextStep();
            return;
        }

        _tutorialEvent.Interface.Finished += NextStep;
        if (_tutorialEvent.Interface.IsAvailable())
        {
            ApplyTarget();
        }
        else
        {
            _tutorialEvent.Interface.Available += ApplyTarget;
        }
        Entered?.Invoke(this);
        Debug.Log($"Tutorial step started {_id}");
        
    }
    
    
    private void ApplyTarget()
    {
        _tutorialEvent.Interface.Available -= ApplyTarget;
        _tutorialPointer.SetTarget(_targetPoint);
    }

    private void NextStep()
    {
        Exit();
        if (_lastStep == false)
            _nextStep.Enter();
    }
    
    
    private void Exit()
    {
        if (ES3.Load(_id, false) == false)
        {
            Debug.Log($"Tutorial step completed");
        }
        ES3.Save(_id, true);
        Exited?.Invoke(this);
        _tutorialEvent.Interface.Finished -= NextStep;
        _tutorialPointer.ReceiveDestination();
    }

   


}
