using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Extentions;
using UnityEngine.Events;


namespace IdleBasesSDK.Stack
{
    public interface IStack
    {
        public int ItemsCount { get; }
        public int MaxSize { get; }
        public Dictionary<ItemType, IntReference> Items { get; }        
        
        public UnityAction<StackItemData> AddedItem { get; set; } 
        public UnityAction<StackItemData> TookItem { get; set; }
        public UnityAction<ItemType, int> TypeCountChanged { get; set; }
        public UnityAction<int> CountChanged { get; set; }
        public bool StoreType(ItemType itemType);
        public bool TryAdd(StackItem stackItem);

        public bool TryTakeLast(out StackItem stackItem, Transform destination, StackItemDataModifier modifier = new StackItemDataModifier());

        public bool TryTake(ItemType itemType, out StackItem stackItem, Transform destination, StackItemDataModifier modifier = new StackItemDataModifier());

        public bool TrySpend(ItemType type, int amount);
        public bool TrySpend(ItemType type, int amount, out IEnumerable<StackItem> spendItems);
        public bool TryAddRange(ItemType type, int count);

    }
}

