using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Haptic;
using NaughtyAttributes;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using Zenject;

public class StackGiver : MonoBehaviour
{
    [SerializeField] private StackProvider _stackProvider;
    [SerializeField] private StackableCharacterZone _zoneBase;
    [SerializeField] private bool _haveTargetType;
    [SerializeField, ShowIf(nameof(_haveTargetType))] private ItemType _targetType;
    [SerializeField] private bool _overrideTransforms;
    [SerializeField, ShowIf(nameof(_overrideTransforms))] 
    private Transform _parent;

    [Inject] private IHapticService _hapticService;
    
    private void OnEnable()
    {
        _zoneBase.OnInteractInternal += OnInteract;
    }
    
    private void OnDisable()
    {
        _zoneBase.OnInteractInternal -= OnInteract;
    }

    protected void OnInteract(StackableCharacter character)
    {
        if(_stackProvider.Interface.ItemsCount == 0)
            return;

        bool tryTake;
        StackItem stackItem;
        if (_haveTargetType)
            tryTake = _stackProvider.Interface.TryTake(_targetType, out stackItem, character.transform);
        else
            tryTake = _stackProvider.Interface.TryTake(ItemType.Any, out stackItem, character.transform);
        
        if(tryTake == false)
            return;
        if (_overrideTransforms)
        {
            stackItem.transform.SetParent(_parent);
            stackItem.transform.localPosition = Vector3.zero;
        }
        
        character.MainStack.TryAdd(stackItem);
        _hapticService.Selection();
    }
}
