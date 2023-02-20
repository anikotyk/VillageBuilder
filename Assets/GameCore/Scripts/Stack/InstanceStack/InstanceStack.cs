﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Stack;
using Zenject;

public class InstanceStack : StackBase
{
    [SerializeField] private bool _visibleEqualsCapacity;
    [SerializeField, HideIf(nameof(_visibleEqualsCapacity))]
    private int _maxVisibleInstanceCount;
    [SerializeField] private bool _disableOnTake;

    public int MaxVisibleInstanceCount => _visibleEqualsCapacity ? MaxSize : _maxVisibleInstanceCount;

    public List<StackItem> SourceItems { get; } = new List<StackItem>();

    private Dictionary<ItemType, List<StackItem>> _items = new();

    private bool _initializedItems = false;
    
    private Dictionary<ItemType, List<StackItem>> Items
    {
        get
        {
            if (_initializedItems == false)
            {
                InitializeItemDictionary(_items, () => new List<StackItem>());
                _initializedItems = true;
            }

            return _items;
        }
    }

    protected override void OnAddItem(StackItem stackItem)
    {
        if (ItemsCount > MaxVisibleInstanceCount)
        {
            stackItem.Pool.Return(stackItem);
            return;
        }
        stackItem.gameObject.SetActive(true);
        Items[stackItem.Type].Add(stackItem);
        SourceItems.Add(stackItem);
    }
    
    protected override void OnTakeItem(StackItem stackItem)
    {
        if (ItemsCount >= MaxVisibleInstanceCount)
        {
            stackItem.Claim();
            if (_disableOnTake)
            {
                stackItem.Pool.Return(stackItem);
            }
            return;
        }

        Items[stackItem.Type].Remove(stackItem);
        SourceItems.Remove(stackItem);
    }

    protected override bool TryGetInstance(ItemType type, out StackItem stackItem)
    {
        if (ItemsCount > MaxVisibleInstanceCount)
        {
            stackItem = GameObject.FindObjectOfType<StackItem>();
            stackItem.transform.SetParent(transform);
            stackItem.transform.localPosition = Vector3.zero;
            return true;
        }
        stackItem = null;
        var itemsList = Items[type];
        if (itemsList.Count == 0)
            return false;
        stackItem = itemsList[^1];
        return true;
    }

    protected override IEnumerable<StackItem> GetInstances(ItemType type, int count)
    {
        var itemsList = Items[type];
        for (int i = 0; i < count; i++)
        {
            var instance = itemsList[^1];
            yield return instance;
        }
    }
}
