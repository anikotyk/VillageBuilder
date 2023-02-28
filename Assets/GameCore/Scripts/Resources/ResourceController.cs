using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;
using Zenject;

public class ResourceController : MonoBehaviour
{
    [SerializeField] private List<ResourceData> _resourcesData;
    [SerializeField] private Transform _poolParent;
    [SerializeField] private int _poolSize;

    [Inject] private DiContainer _container;
    public IEnumerable<ResourceData> Resources => _resourcesData;

    private bool _intilialized = false;
    private Dictionary<ItemType, IPool<StackItem>> _itemPools = new();

    private Dictionary<ItemType, IPool<StackItem>> ItemsPool
    {
        get
        {
            if (_intilialized == false)
            {
                Initialize();
            }
            return _itemPools;
        }
    }


    private void Start()
    {
        Initialize();
    }


    private void Initialize()
    {
        if(_intilialized)
            return;
        
        foreach (var resourceData in _resourcesData)
        {
            SimplePool<StackItem> simplePool = new SimplePool<StackItem>(resourceData.Prefab, _poolSize, _poolParent);
            simplePool.Initialize(_container);
            _itemPools.Add(resourceData.ItemType, simplePool);
        }
        
        _intilialized = true;
    }


    public Resource GetPrefab(ItemType itemType)
    {
        return _resourcesData.Find(x => x.ItemType == itemType).Prefab;
    }

    public StackItem GetInstance(ItemType itemType)
    {
        return ItemsPool[itemType].Get();
    }

    public List<StackItem> GetInstances(ItemType itemType, int count, Action<StackItem> handle = null)
    {
        var pool = ItemsPool[itemType];
        List<StackItem> resources = new List<StackItem>();
        for (int i = 0; i < count; i++)
        {
            var resource = pool.Get();
            resources.Add(resource);
            handle?.Invoke(resource);
        }

        return resources;
    }
}
