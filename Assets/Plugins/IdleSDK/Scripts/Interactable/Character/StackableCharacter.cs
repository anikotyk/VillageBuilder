using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Stack;

namespace IdleBasesSDK.Interactable
{
    public class StackableCharacter : InteractableCharacter
    {
        [SerializeField] private List<StackProvider> _stackProviders;

        public IStack MainStack => _stackProviders[0].Interface;

        public bool TryToGetStack(ItemType type, out IStack stack)
        {
            stack = MainStack;
            return true;
        }

        public bool TryAdd(StackItem stackItem)
        {
            return MainStack.TryAdd(stackItem);
        }
    }
}
