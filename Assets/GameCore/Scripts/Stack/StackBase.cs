using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using IdleBasesSDK.Extentions;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Upgrades;
using UnityEngine.Events;
using Zenject;

public abstract class StackBase : MonoBehaviour, IStack
{
    [SerializeField, HideIf(nameof(_capacityFromUpgrade))] private int _maxSize;
    [SerializeField] private bool _capacityFromUpgrade;
    [SerializeField, ShowIf(nameof(_capacityFromUpgrade))] private UpgradeValue _capacityUpgrade;
    [SerializeField] private bool _storeAnyType;
    [SerializeField, HideIf(nameof(_storeAnyType))] private List<ItemType> _storedTypes;

    [Inject] private UpgradesController _upgradesController;
    private Dictionary<ItemType, IntReference> _items = new();
    private bool _initialized = false;
    private int _count = 0;

    public int ItemsCount => _count;
    public int MaxSize => _capacityFromUpgrade ? _capacityUpgrade.ValueInt :  _maxSize;

    public Dictionary<ItemType, IntReference> Items
    {
        get
        {
            if(_initialized == false)
                Initialize();
            return _items;
        }
    }
    public UnityAction<StackItemData> AddedItem { get; set; }
    public UnityAction<StackItemData> TookItem { get; set; }
    public UnityAction<ItemType, int> TypeCountChanged { get; set; }
    public UnityAction<int> CountChanged { get; set; }

    private void Awake()
    {
        Initialize();
    }

    private void Start()
    {
        Initialize();
    }

    private void Initialize()
    {
        if(_initialized)
            return;
        InitializeItemDictionary(_items, () => new IntReference());
        _initialized = true;
    }

    protected void InitializeItemDictionary<T>(Dictionary<ItemType, T> dictionary, Func<T> getDefaultValue)
    {
        if (_storeAnyType || _storedTypes.Has(x=>x == ItemType.Any))
        {
            foreach (ItemType itemType in Enum.GetValues(typeof(ItemType)))
            {
                dictionary.Add(itemType, getDefaultValue());
            }
        }
        else
        {
            foreach (ItemType suit in _storedTypes)
            {
                dictionary.Add(suit, getDefaultValue());
            }
        }
    }

    public bool StoreType(ItemType itemType)
    {
        foreach (var storedType in _storedTypes)
        {
            if (storedType == itemType || storedType == ItemType.Any)
                return true;
        }

        return false;
    }

    public bool TryAdd(StackItem stackItem)
    {
        Initialize();
        if (_count + stackItem.Amount > MaxSize)
            return false;
        
        var countRef = Items[stackItem.Type];
        countRef.Value += stackItem.Amount;
        _count += stackItem.Amount;
        OnAddItem(stackItem);
        AddedItem?.Invoke(new StackItemData(stackItem));
        TypeCountChanged?.Invoke(stackItem.Type, stackItem.Amount);
        CountChanged?.Invoke(_count);
        return true;
    }

    protected virtual void OnAddItem(StackItem stackItem)
    {
    }

    public bool TryAddRange(ItemType type, int count)
    {
        Initialize();
        if (_count + count > MaxSize)
            return false;

        var countRef = Items[type];
        countRef.Value += count;
        _count += count;
        TypeCountChanged?.Invoke(type, count);
        CountChanged?.Invoke(_count);
        return true;
    }

    public bool TryTake(ItemType itemType, out StackItem stackItem, Transform destination, StackItemDataModifier modifier = new StackItemDataModifier())
    {
        stackItem = null;
        if (itemType == ItemType.Any)
        {
            if (_count <= 0)
                return false;

            ItemType typeToTake = ItemType.None;
            foreach (var item in Items)
            {
                if (item.Value.Value > 0)
                {
                    typeToTake = item.Key;
                    break;
                }
            }
            return TryTake(typeToTake, out stackItem, destination, modifier);
        }
        var itemCountRef = Items[itemType];
        if (itemCountRef.Value <= 0)
            return false;
        itemCountRef.Value--;
        if (TryGetInstance(itemType, out stackItem) == false)
            return false;
        
        _count -= stackItem.Amount;
        OnTakeItem(stackItem);
        TookItem?.Invoke(new StackItemData(stackItem).AddDestination(destination).ApplyModifier(modifier));
        TypeCountChanged?.Invoke(itemType, -stackItem.Amount);
        CountChanged?.Invoke(_count);
        return true;
    }
    
    protected virtual void OnTakeItem(StackItem stackItem)
    {
    }

    protected abstract bool TryGetInstance(ItemType type, out StackItem stackItem);
    protected abstract IEnumerable<StackItem> GetInstances(ItemType type, int count);

    public bool TryTakeLast(out StackItem stackItem, Transform destination, StackItemDataModifier modifier = new StackItemDataModifier())
    {
        stackItem = null;
        if (_count == 0)
            return false;
        ItemType takeType = _storedTypes[0];
        var countRef = Items[takeType];
        if (countRef.Value <= 0)
            return false;
        countRef.Value -= 1;
        if (TryGetInstance(takeType, out stackItem) == false)
            return false;
        
        _count -= stackItem.Amount;
        OnTakeItem(stackItem);
        TookItem?.Invoke(new StackItemData(stackItem).AddDestination(destination).ApplyModifier(modifier));
        TypeCountChanged?.Invoke(stackItem.Type, -stackItem.Amount);
        CountChanged?.Invoke(_count);
        return true;
    }

    public bool TrySpend(ItemType type, int amount)
    {
        var countRef = Items[type];
        
        if (_count < amount)
            return false;
        
        if (countRef.Value < amount)
            return false;
        countRef.Value -= amount;
        
        _count -= amount;
        TypeCountChanged?.Invoke(type, -amount);
        CountChanged?.Invoke(_count);
        return true;
    }

    public bool TrySpend(ItemType type, int amount, out IEnumerable<StackItem> spendItems)
    {
        spendItems = default;
        if (TrySpend(type, amount) == false)
            return false;
        _count -= amount;
        spendItems = GetInstances(type, amount);
        return true;
    }
}
