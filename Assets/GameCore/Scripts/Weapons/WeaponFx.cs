using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Utilities;
using Zenject;

public class WeaponFx : MonoBehaviour
{
    [SerializeField] private Weapon _weapon;
    [SerializeField] protected WeaponController _weaponController;
    [SerializeField] private Transform _weaponModel;
    [SerializeField] private float _zoomTime;
    [SerializeField] private TrailRenderer _trailRenderer;
    [SerializeField] private float _trailEnableDelay = 0.05f;
    [SerializeField] private float _trailAdditionDisableTime = 0.05f;
    [SerializeField] private Animator _animator;
    [SerializeField, ShowIf(nameof(AnimatorSerialized)), AnimatorParam(nameof(Animator))] 
    private string _useAnimation;

    [Inject] private Timer _timer;
    
    private bool AnimatorSerialized => _animator != null;
    private Animator Animator => _animator;

    private Tweener _scaleTweener = null;
    
    private void OnEnable()
    {
        _weapon.StartUsing += Show;
        _weapon.StartUsing += OnUse;
        _weapon.EndedUsing += Hide;
        _weaponController.ChangedActive += OnChangedActive;
        Hide(_weapon);
    }
    
    private void OnDisable()
    {
        _weapon.StartUsing -= Show;
        _weapon.StartUsing -= OnUse;
        _weapon.EndedUsing -= Hide;
    }
    
    private void Show(Weapon weapon)
    {
        if (_scaleTweener != null)
            _scaleTweener.Kill();
        
        _timer.ExecuteWithDelay(() => _trailRenderer.emitting = true, _trailEnableDelay);
        _scaleTweener = _weaponModel.DOScale(Vector3.one, _zoomTime).SetEase(Ease.OutBack);
        
    }
    
    private void Hide(Weapon weapon)
    {
        if (_scaleTweener != null)
            _scaleTweener.Kill();
        Animator.SetBool(_useAnimation, false);
        _trailRenderer.emitting = false;
        _scaleTweener = _weaponModel.DOScale(Vector3.zero, _zoomTime);
    }

    private void OnUse(Weapon weapon)
    {
        Animator.SetBool(_useAnimation, true);
    }

    private void OnChangedActive(bool active)
    {
        if(active)
            return;
        Hide(_weapon);
                

    }
}
