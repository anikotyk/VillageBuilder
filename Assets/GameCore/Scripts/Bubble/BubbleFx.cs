using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using DG.Tweening;
using IdleBasesSDK.Utilities;
using Zenject;

public class BubbleFx : MonoBehaviour
{
    [SerializeField] private Transform _bubbleWrapper;
    [SerializeField] private List<ParticleSystem> _particles;
    [SerializeField] private float _particlePlayDelay;

    [Inject] private Bubble _bubble;
    private void OnEnable()
    {
        _bubble.StartScaling += OnStartScaling;
        _bubble.Scaled += OnScaled;
    }

    private void OnDisable()
    {
        _bubble.StartScaling -= OnStartScaling;
        _bubble.Scaled -= OnScaled;
    }

    private void OnStartScaling(float targetScale)
    {
        DOVirtual.DelayedCall(_particlePlayDelay, ShowParticles);
    }
    
    private void OnScaled(float targetScale)
    {
        _bubbleWrapper.localScale = targetScale * Vector3.one;
    }
    private void ShowParticles()
    {
        foreach (var particle in _particles)
        {
            particle.Play();
        }
    }
}
