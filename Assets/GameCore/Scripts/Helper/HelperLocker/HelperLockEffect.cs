using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Utilities;
using Zenject;

public class HelperLockEffect : MonoBehaviour
{
    [SerializeField] private HelperLocker _helperLocker;
    [SerializeField] private Animator _animator;
    [SerializeField] private AIMovement _aiMovement;
    [SerializeField] private ParticleSystem _particle;

    [SerializeField, ShowIf(nameof(HaveAnimator)), AnimatorParam(nameof(_animator))]
    private string _waitParameter;
    
    [SerializeField, ShowIf(nameof(HaveAnimator)), AnimatorParam(nameof(_animator))]
    private string _releaseParameter;

    [SerializeField] private float _enableHandleDelay;

    [Inject] private Timer _timer;
    private bool HaveAnimator => _animator != null;
    
    private void OnEnable()
    {
        Lock();
        if (_helperLocker.IsLocked == false)
        {
            Unlock();
            return;
        }
        _helperLocker.Released += Unlock;
    }

    private void OnDisable()
    {
        _helperLocker.Released -= Unlock;
    }

    private void Lock()
    {
        _aiMovement.enabled = false;
        _animator.SetTrigger(_waitParameter);
    }
    
    private void Unlock()
    {
        _animator.SetTrigger(_releaseParameter);
        _particle.Play();
        _timer.ExecuteWithDelay(() =>
        {
            _aiMovement.enabled = true;
        }, _enableHandleDelay);
    }
}
