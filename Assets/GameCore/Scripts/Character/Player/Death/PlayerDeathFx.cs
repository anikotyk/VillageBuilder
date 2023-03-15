using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Utilities;
using Zenject;

public class PlayerDeathFx : MonoBehaviour
{
    [SerializeField] private Player _player;
    [SerializeField] private View _deathView;
    [SerializeField] private float _showViewDelay;
    [Space]
    [SerializeField, ShowIf(nameof(HasAnimator)), AnimatorParam(nameof(Animator))]
    private string _dieParameter;
    [SerializeField, ShowIf(nameof(HasAnimator)), AnimatorParam(nameof(Animator))]
    private string _idleParameter;
    [Space]
    [SerializeField] private Health _health;
    [SerializeField] private PlayerRespawn _playerRespawn;

    [Inject] private Timer _timer;
    
    private bool HasAnimator => _player != null;
    private Animator Animator => _player.Animator;

    private void OnEnable()
    {
        _health.Died += OnDie;
        _playerRespawn.Respawned += OnRespawn;
    }

    private void OnDisable()
    {
        _health.Died -= OnDie;
        _playerRespawn.Respawned -= OnRespawn;
    }


    private void OnDie()
    {
        Animator.SetTrigger(_dieParameter);
        _timer.ExecuteWithDelay(_deathView.Show, _showViewDelay);
    }

    private void OnRespawn()
    {
        Animator.SetTrigger(_idleParameter);
    }

}
