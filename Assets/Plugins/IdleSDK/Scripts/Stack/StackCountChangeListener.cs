using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;

namespace IdleBasesSDK.Stack
{
    public abstract class StackCountChangeListener : MonoBehaviour
    {
        [SerializeField] private StackProvider _stackProvider;
    
        protected IStack Stack => _stackProvider.Interface;
        private void OnEnable()
        {
            _stackProvider.Interface.CountChanged += OnStackCountChanged;
            OnStackCountChanged(_stackProvider.Interface.ItemsCount);
            OnEnableInternal();
        }
        
        private void OnDisable()
        {
            _stackProvider.Interface.CountChanged += OnStackCountChanged;
            OnDisableInternal();
        }
    
        protected abstract void OnStackCountChanged(int count);

        protected virtual void OnEnableInternal()
        {
        }
        protected virtual void OnDisableInternal()
        {
        }
    }

}
