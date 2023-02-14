using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;

public class StackMover : StackTaker
{
    [SerializeField] private ItemType _targetType;
    [SerializeField] private StackProvider _receiveStack;
    [SerializeField] private bool _zoomOutOnEnd;
    [SerializeField] private bool _returnIntoPoolOnEnd;
    [SerializeField, ShowIf(nameof(_zoomOutOnEnd))] private float _zoomOutDelay;
    [SerializeField, ShowIf(nameof(_zoomOutOnEnd))] private float _zoomOutTime;
    public override ItemType GetTypeToTake(StackableCharacter interactableCharacter)
    {
        return _targetType;
    }

    public override bool TakePredicate()
    {
        return _receiveStack.Interface.MaxSize > _receiveStack.Interface.ItemsCount;
    }

    protected override void OnTakeItem(StackItem item)
    {
        _receiveStack.Interface.TryAdd(item);
        item.transform.DOScale(Vector3.zero, _zoomOutTime).SetDelay(_zoomOutDelay).OnComplete(() =>
        {
            if (_returnIntoPoolOnEnd)
                item.Pool.Return(item);
        });
    }
}
