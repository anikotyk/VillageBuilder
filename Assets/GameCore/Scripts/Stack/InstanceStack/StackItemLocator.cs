using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using NaughtyAttributes;
using NaughtyAttributes.Test;
using IdleBasesSDK;
using IdleBasesSDK.Stack;
using Zenject;

public class StackItemLocator : MonoBehaviour
{
    [SerializeField] private InstanceStack _stack;
    [SerializeField] private Vector2Int _size;
    [SerializeField] private ItemType _storedItemType;
    [SerializeField] private Vector3 _itemGizmosSize;

    private void OnDrawGizmos()
    {
        for (int i = 0; i < 10; i++)
        {
            var center = GetDeltaByIndexAndSize(i, _itemGizmosSize) + transform.position;
            var size = transform.rotation * _itemGizmosSize;
            Gizmos.DrawWireCube(center, size);
        }
    }

    public Vector3 GetCurrentDelta(bool local = false)
    {
        return GetDeltaByIndex(_stack.SourceItems.Count, local);
    }

    public Vector3 GetNextDelta(int delta, bool local = false)
    {
        int count = _stack.SourceItems.Count + delta;
        if (_stack.ItemsCount + delta >= _stack.MaxVisibleInstanceCount)
            count = _stack.MaxVisibleInstanceCount - 1;
        return GetDeltaByIndex(count, local);
    }
    
    [Button("Rebuild")]
    public void Rebuild()
    {
        int index = 0;
        foreach (var item in _stack.SourceItems)
        {
            item.transform.localPosition = GetDeltaByIndexAndSize(index, item.StackSize.Size, true);
            item.transform.localRotation = Quaternion.identity;
            index++;
        }
    }

    public Vector3 GetDeltaByIndex(int count, bool local = false)
    {
       return GetDeltaByIndexAndSize(count, Vector3.zero, local);
    }

    private Vector3 GetDeltaByIndexAndSize(int count, Vector3 size, bool local = false)
    {
        Vector3Int index = Vector3Int.zero;
        int area = _size.x * _size.y;
        index.y = count / area;
        int xz = count - index.y * area;
        index.x = xz / _size.x;
        index.z = xz - _size.x * index.x;

        Vector3 result = Vector3.Scale(index, size);
        return result;
    }
}
