using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using Zenject;
using Random = UnityEngine.Random;

public class ResourceGenerateFx : MonoBehaviour
{
    [SerializeField] private ResourcePlaceGenerator _resourcePlaceGenerator;
    [SerializeField] private StackItemRotator _stackItemRotator;
    [SerializeField] private Vector2 _spawnRange;
    [SerializeField] private float _targetY;
    [SerializeField] private MoveFx _moveFx;
    [SerializeField] private float _receiveDelay;
    [SerializeField] private float _zoomInDuration;

    [Inject] private Player _player;
    [Inject] private Timer _timer;
    private void OnEnable()
    {
        _resourcePlaceGenerator.Spawned += OnResourceSpawned;
    }

    private void OnDisable()
    {
        _resourcePlaceGenerator.Spawned -= OnResourceSpawned;
    }

    private void OnResourceSpawned(StackItem collectable)
    {
        Vector2 randomPoint = Random.insideUnitCircle * _spawnRange.Random();
        Vector3 delta = new Vector3(randomPoint.x, _targetY, randomPoint.y);
        collectable.transform.localPosition = Vector3.zero;
        collectable.transform.localScale = Vector3.zero;
        collectable.transform.DOScale(Vector3.one, _zoomInDuration);
        _moveFx.Move(collectable.transform, transform, delta, localMove:true);
        _stackItemRotator.Rotate(collectable.transform, _moveFx.Duration);
        
        collectable.Claimed += OnClaim;
    }

    private void OnClaim(StackItem item)
    {
        item.Claimed -= OnClaim;
        DOTween.Kill(item.transform);
    }
    
}
