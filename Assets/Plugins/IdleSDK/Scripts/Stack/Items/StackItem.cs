using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;
using UnityEngine.Events;


namespace IdleBasesSDK.Stack
{
    public abstract class StackItem : MonoBehaviour, IPoolItem<StackItem>
    {
        [SerializeField] private ItemType _itemType;
        [SerializeField] private StackSize _stackSize;
        [SerializeField] private Transform _wrapper;

        private int _amount = 1;
        public StackSize StackSize => _stackSize;
        public ItemType Type => _itemType;
        public Transform Wrapper => _wrapper;
        
        public int Amount => _amount;
        public StackItem Item => this;
        public IPool<StackItem> Pool { get; set; }
        public bool IsTook { get; set; }

        public UnityAction<StackItem> Claimed { get; set; }
        public UnityAction<StackItem> UnClaimed { get; set; }
        
        public bool IsClaimed { get; protected set; }

        public void Claim()
        {
            IsClaimed = true;
            Claimed?.Invoke(this);
            OnClaim();
        }

        public abstract void UnClaim();
        public abstract void OnClaim();
        public abstract void Restore();

        public void SetAmount(int newAmount)
        {
            if(newAmount <= 0)
                return;
            _amount = newAmount;
        }

        public void TakeItem()
        {
            Refresh();
            Restore();
        }

        public void ReturnItem()
        {
            Refresh();
            Restore();
        }

        private void Refresh()
        {
            _amount = 1;
            transform.localPosition = Vector3.zero;
            transform.rotation = Quaternion.identity;
            transform.localScale = Vector3.one;
            _wrapper.localPosition = Vector3.zero;
            _wrapper.localRotation = Quaternion.identity;
            _wrapper.localScale = Vector3.one;
            IsClaimed = false;
        }
    }

}

