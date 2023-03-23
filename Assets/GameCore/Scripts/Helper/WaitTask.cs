using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Utilities;
using UnityEngine.Events;
using Zenject;

public class WaitTask : MonoBehaviour, ITask
{
    [SerializeField] private Transform _waitPoint;
    [SerializeField] private float _waitTime;
    [SerializeField] private Animator _helperAnimator;
    [SerializeField, ShowIf(nameof(HasAnimator)), AnimatorParam(nameof(_helperAnimator))] 
    private string _useTaskAnimation;
    [SerializeField, ShowIf(nameof(HasAnimator)), AnimatorParam(nameof(_helperAnimator))] 
    private string _finishTaskAnimation;

    [Inject] private Timer _timer;
    private bool HasAnimator => _helperAnimator != null;

    public bool AvailableToHelp => true;
    public bool Active => true;
    public Transform TaskPoint => _waitPoint;
    public UnityAction Finished { get; set; }
    public void UseTask()
    {
        _helperAnimator.SetTrigger(_useTaskAnimation);
        _timer.ExecuteWithDelay(OnTaskFinished, _waitTime);
    }

    private void OnTaskFinished()
    {
        Debug.Log("Task finished");
        _helperAnimator.SetTrigger(_finishTaskAnimation);
        Finished?.Invoke();
    }

}
