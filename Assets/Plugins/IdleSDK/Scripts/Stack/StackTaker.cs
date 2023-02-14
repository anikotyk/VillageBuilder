using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using NaughtyAttributes;
using Haptic;
using IdleBasesSDK.Interactable;
using UnityEngine.Events;
using Zenject;

namespace IdleBasesSDK.Stack
{
    public abstract class StackTaker : MonoBehaviour
    {
        [SerializeField] protected StackableCharacterZone ZoneBase;
        [SerializeField] private Transform _takePoint;
        [SerializeField] private bool _overrideRotate;
        
        [Inject] private IHapticService _hapticService;
        
        public UnityAction<StackItem> OnTake;
        protected virtual int OneTakeCount { get; } = 1;
        protected virtual Vector3 DestinationDelta => Vector3.zero;
        public virtual float Progress => 0.0f;

        private void OnEnable()
        {
            ZoneBase.OnInteractInternal += OnInteract;
            OnEnableInternal();
        }
        
        private void OnDisable()
        {
            ZoneBase.OnInteractInternal -= OnInteract;
            OnDisableInternal();
        }

        protected virtual void OnEnableInternal()
        {
        }

        protected virtual void OnDisableInternal()
        {
        }

        public abstract ItemType GetTypeToTake(StackableCharacter interactableCharacter);
        public abstract bool TakePredicate();
        
        private void OnInteract(StackableCharacter interactableCharacter)
        {
            if(TakePredicate() == false)
                return;
            
            TakeItem(interactableCharacter, GetTypeToTake(interactableCharacter));
        }

        private void TakeItem(StackableCharacter interactableCharacter, ItemType itemType)
        {
            if (interactableCharacter.TryToGetStack(itemType, out IStack stack) == false) 
                return;

            int oneTakeCount = OneTakeCount;
            bool canTake = stack.Items[itemType].Value >= oneTakeCount || (itemType == ItemType.Any && stack.ItemsCount > 0);
            if (canTake == false)
                return;

            StackItemDataModifier modifier = new StackItemDataModifier(DestinationDelta, Progress, _overrideRotate);
            if(stack.TryTake(itemType, out StackItem stackItem, _takePoint, modifier) == false)
                return;
            
            if(oneTakeCount > 1)
                stack.TrySpend(stackItem.Type, oneTakeCount - 1);
            
            stackItem.SetAmount(oneTakeCount);
            stackItem.Claim();

            
            _hapticService.Selection(); 
            OnTake?.Invoke(stackItem);
            OnTakeItem(stackItem);
        }

        protected virtual void OnTakeItem(StackItem stackItem){}
        
    }
}