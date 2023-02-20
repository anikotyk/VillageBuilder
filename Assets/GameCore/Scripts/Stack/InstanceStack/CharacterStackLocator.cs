using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using ModestTree;
using IdleBasesSDK.Stack;

public class CharacterStackLocator : MonoBehaviour
{
    [SerializeField] private InstanceStack _stack;
    [SerializeField] private Vector3 _columnOffsetDirection;
    [SerializeField] private float _columnsOffset;

    public StackSettings Settings => StackSettings.value;
    public InstanceStack Stack => _stack;

    private void OnEnable()
    {
        _stack.TookItem += OnTakeItem;
    }
    
    private void OnDisable()
    {
        _stack.TookItem -= OnTakeItem;
    }

    private void OnTakeItem(StackItemData itemData)
    {
        Rebuild(itemData.Target.transform);
    }

    private void Rebuild(Transform skipTransform = null)
    {
        for (int i = 0; i < _stack.SourceItems.Count; i++)
        {
            if(skipTransform == _stack.SourceItems[i].transform)
                continue;
            _stack.SourceItems[i].transform.localPosition = GetDelta(i);
        }
    }

    public Vector3 GetCurrentDelta()
    {
        if(_stack.ItemsCount == 1)
            return Vector3.zero;
        
        int columnsCount = (_stack.ItemsCount - 1) / Settings.MaxRowsCount;
        Vector3 delta = columnsCount * _columnsOffset * _columnOffsetDirection;
        for (int i = columnsCount * Settings.MaxRowsCount; i < _stack.SourceItems.Count - 1; i++)
        {
            delta += _stack.SourceItems[i].StackSize.Size.y * Vector3.up;
        }

        return delta;
    }

    private Vector3 GetDelta(int index)
    {
        if(index == 0)
            return Vector3.zero;
        
        int columnsCount = index / Settings.MaxRowsCount;
        Vector3 delta = columnsCount * _columnsOffset * _columnOffsetDirection;
        for (int i = columnsCount * Settings.MaxRowsCount; i < index; i++)
        {
            delta += _stack.SourceItems[i].StackSize.Size.y * Vector3.up;
        }

        return delta;
    }
    
    public int GetRow(StackItem item)
    {
        int index = _stack.SourceItems.IndexOf(item);
        return GetRow(index);
    }

    public int GetColumn(StackItem item)
    {
        int index = _stack.SourceItems.IndexOf(item);
        return GetColumn(index);
    }
    
    public int GetRow(int index)
    {
        if (index < Settings.MaxRowsCount)
            return index;
        int columnsCount = GetColumn(index);
        return index - columnsCount * Settings.MaxRowsCount;
    }

    public int GetColumn(int index)
    {
        return index / Settings.MaxRowsCount;
    }
}
