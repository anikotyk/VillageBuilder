using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;

public class OutsideTaskHandler : MonoBehaviour, ITask
{
    [SerializeField] private OutsideTimer _outsideTimer;
    [SerializeField] private Helper _helper;
    public bool AvailableToHelp => true;
    public bool Active => true;
    public Transform TaskPoint => _helper.ReturnPoint;
    public UnityAction Finished { get; set; }
    private void OnEnable()
    {
        _outsideTimer.ProgressChanged += OnProgressChanged;
    }

    private void OnDisable()
    {
        _outsideTimer.ProgressChanged -= OnProgressChanged;
    }

    private void OnProgressChanged(float progress)
    {
        if (progress >= 0.95f)
        {
            _helper.ForceReturnBase();
            _helper.CurrentTask.Finished += ReturnBaseTaskFinished;
        }
        else if (progress <= 0.05f)
        {
            Finished?.Invoke();
        }
    }

    private void ReturnBaseTaskFinished()
    {
        _helper.CurrentTask.Finished -= ReturnBaseTaskFinished;
        if(_outsideTimer.Progress > 0.05f)
            _helper.HandleTask(this);
    }
    
    public void UseTask()
    {
    }
}
