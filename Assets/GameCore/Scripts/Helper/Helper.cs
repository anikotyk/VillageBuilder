using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using Zenject;

public class Helper : MonoBehaviour
{
    [Header("Movement")] 
    [SerializeField] private AIMovement _aiMovement;
    [Space]
    [SerializeField] private HelperHouse _helperHouse;
    [Header("Tasks")] 
    [SerializeField] private float _actualizeTasksDelay;
    
    [Header("Stack")]
    [SerializeField] private StackProvider _helperStack;
    [SerializeField] private int _maxStorageCount;

    [Inject] private HelperTasks _helperTasks;
    [Inject] private Bubble _bubble;
    [Inject] private Timer _timer;

    private Dictionary<ItemType, List<ITask>> _taskList;
    private ITask _currentTask;

    private Coroutine _actualizeRoutine = null;

    private Queue<ItemType> _collectTypesQueue;

    public AIMovement AIMovement => _aiMovement;
    public ITask CurrentTask => _currentTask;
    public Transform ReturnPoint => _helperHouse.ReturnBaseTask.TaskPoint;

    private void Awake()
    {
        _collectTypesQueue = new Queue<ItemType>(_helperTasks.TypesToCollect);
    }

    private void OnEnable()
    {
        _taskList = _helperTasks.GetNearestTasks(task => true, _helperHouse.transform.position);
        _actualizeRoutine = StartCoroutine(ActualizeRoutine());
        _bubble.EndScale += RefreshTask;
    }

    private void OnDisable()
    {
        _bubble.EndScale -= RefreshTask;
        if(_actualizeRoutine != null)
            StopCoroutine(_actualizeRoutine);
    }
    
    public void NextTask()
    {
        if (_helperStack.Interface.ItemsCount >= _maxStorageCount)
        {
            HandleTask(_helperHouse.ReturnBaseTask);
            return;
        }

        ItemType currentTypeToCollect = _collectTypesQueue.Dequeue();
        _collectTypesQueue.Enqueue(currentTypeToCollect);
        
        ITask task = _helperTasks.GetTask(_taskList, this, currentTypeToCollect, _helperHouse.GetTasksInExecution());
        if (_helperHouse.StorageStack.ItemsCount >= _helperHouse.StorageCapacity || task == null)
        {
            HandleTask(_helperHouse.WaitTask);
            return;
        }
        HandleTask(task);
        
    }
    
   
    public void HandleTask(ITask task)
    {
        if (_currentTask != null)
        {
            _currentTask.Finished -= OnTaskFinished;
            _aiMovement.OnStopMove -= UseTask;
        }
        
        _currentTask = task;
        _currentTask.Finished += OnTaskFinished;
        _aiMovement.OnStopMove += UseTask;
        if (VectorExtentions.SqrDistance(_currentTask.TaskPoint, _aiMovement.transform) <=
            _aiMovement.StopDistance * _aiMovement.StopDistance)

        {
            UseTask();
        }
        _aiMovement.SetDestination(task.TaskPoint.position);
       

    }

    private void OnTaskFinished()
    {
        _currentTask.Finished -= OnTaskFinished;
        _currentTask = null;
        NextTask();
    }

    
    private void UseTask()
    {
        _currentTask.UseTask();
        _aiMovement.OnStopMove -= UseTask;
    }

    private IEnumerator ActualizeRoutine()
    {
        while (gameObject.activeSelf)
        {
            RefreshTask();
            yield return new WaitForSeconds(_actualizeTasksDelay);
        }
    }
    
    public void RefreshTask()
    {
        if(_currentTask == null || _currentTask.AvailableToHelp == false)
            NextTask();
    }

    public void ForceReturnBase()
    {
        HandleTask(_helperHouse.ReturnBaseTask);
    }
}
