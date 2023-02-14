using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;

public class StackInstancesStore : MonoBehaviour
{
    [SerializeField] private StackProvider _stackProvider;
    public List<StackItem> Items { get; } = new List<StackItem>();

    private void OnEnable()
    {
        _stackProvider.Interface.AddedItem += OnAddedItem;
        _stackProvider.Interface.TookItem += OnTookItem;
    }
    
    private void OnDisable()
    {
        _stackProvider.Interface.AddedItem -= OnAddedItem;
        _stackProvider.Interface.TookItem -= OnTookItem;
    }

    private void OnAddedItem(StackItemData data)
    {
        Items.Add(data.Target);
    }

    private void OnTookItem(StackItemData data)
    {
        Items.Remove(data.Target);
    }
}
