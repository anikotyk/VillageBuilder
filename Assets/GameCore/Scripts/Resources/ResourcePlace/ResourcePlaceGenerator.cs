using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;
using UnityEngine.Events;
using Zenject;

public class ResourcePlaceGenerator : MonoBehaviour
{
    [SerializeField] private ResourcePlace _resourcePlace;
    [SerializeField] private ItemType _resourceType;
    

    [Inject] private ResourceController _resourceController;
    [Inject] private DiContainer _diContainer;

    public Sprite ResourceIcon => _resourceController.GetPrefab(_resourceType).Icon;
    private int _collected = 0;
    
    public UnityAction<StackItem> Spawned { get; set; }
    
    private void OnEnable()
    {
        _resourcePlace.Damaged += OnDamaged;
    }
    
    private void OnDisable()
    {
        _resourcePlace.Damaged -= OnDamaged;
    }

    private void OnDamaged(int damage)
    {
        
        int collectedAmount = (int)(damage * (_resourcePlace.Capacity / (float)(_resourcePlace.MaxHealth)));
        if (collectedAmount <= 0)
            collectedAmount = 1;
        if (_collected + collectedAmount > _resourcePlace.Capacity)
        {
            collectedAmount = _resourcePlace.Capacity - _collected;
        }
        for (int i = 0; i < collectedAmount; i++)
        {
            SpawnResource();
        }
        
    }

    private void SpawnResource()
    {
        var pooledResource = _resourceController.GetInstance(_resourceType);
        pooledResource.Restore();
        pooledResource.transform.SetParent(transform);
        pooledResource.transform.localPosition = Vector3.zero;
        pooledResource.gameObject.SetActive(true);
        Spawned?.Invoke(pooledResource);
    }
}
