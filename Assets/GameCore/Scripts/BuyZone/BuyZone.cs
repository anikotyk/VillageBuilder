using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using UnityEngine.Events;
using Zenject;

public class BuyZone : StackTaker, ITutorialEvent
{
    [SerializeField] private List<CostData> _pricesData;
    [SerializeField] private BuyZoneSaver _zoneSaver;
    [SerializeField] private float _buyDelay;
    [SerializeField] private float _resourceDeliverTime;
    [SerializeField] private float _targetBuyTime;
    [SerializeField] private bool _takeByOne;

    [Inject] private Timer _timer;
    [Inject] private Player _player;
    
    private Dictionary<ItemType, int> _currentPrices = null;
    private Dictionary<ItemType, int> _sourcePrices = new();


    private ItemType _lastTakeType;
    private bool _isBought = false;
    private bool _needToTake = true;

    private int _oneInteractTakeCount = 0;
    
    public override float Progress
    {
        get
        {
            float progress = 1 - (((float)Prices.Sum(x => x.Value) / _pricesData.Sum(x => x.Amount)));
            return progress;
        }
    }

    public float FinalValue => 1;
    
    protected override int OneTakeCount
    {
        get
        {
            if (_takeByOne)
            {
                _oneInteractTakeCount = 1;
                return 1;
            }
            if (_oneInteractTakeCount == 0)
            {
                int interactsCount = (int)(_targetBuyTime / ZoneBase.InteractTime);
                int pricesSum = _pricesData.Sum(x => x.Amount);
                _oneInteractTakeCount = Mathf.Clamp(Mathf.RoundToInt(pricesSum / (float)interactsCount), 1, int.MaxValue);
            }

            if (_lastTakeType == ItemType.None)
                return 1;
            int highClamp = Mathf.Min(Prices[_lastTakeType], _player.Stack.MainStack.Items[_lastTakeType].Value);
            return Mathf.Clamp(_oneInteractTakeCount, 1, highClamp);
        }
    }

    public Dictionary<ItemType, int> Prices {
        get
        {
            if (_currentPrices == null)
            {
                _currentPrices = _zoneSaver.GetSave();
                _needToTake = !IsBoughtCheck();
            }

            return _currentPrices;
        }
    }

    public Dictionary<ItemType, int> SourcePrices
    {
        get
        {
            if (!_sourcePrices.Any())
            {
                foreach (var costData in _pricesData)
                {
                    _sourcePrices.Add(costData.Resource, costData.Amount);
                }
            }

            return _sourcePrices;
        }
    }
    public UnityAction<float> BuyProgressChanged{ get; set; }
    public UnityAction<float> BuyProgressChangedDelayed { get; set; }
    
    public UnityAction Bought { get; set; }
    public UnityAction<StackItem> UsedResource { get; set; }
    
    public UnityAction Finished { get; set; }
    public UnityAction Available { get; set; }
    public UnityAction<float> ProgressChanged { get; set; }

    public override ItemType GetTypeToTake(StackableCharacter interactableCharacter)
    {
        foreach (var price in _currentPrices)
        {
            if (interactableCharacter.TryToGetStack(price.Key, out IStack stack) == false)
                continue;
            if (price.Value > 0 && stack.Items[price.Key].Value > 0)
            {
                _lastTakeType = price.Key;
                return price.Key;
            }
        }

        _lastTakeType = ItemType.None;
        return ItemType.None;
    }

    protected override void OnEnableInternal()
    {
        Available?.Invoke();
    }
    
    private void Start()
    {
        if (Prices.Has(x => x.Value > 0) == false)
        {
            Buy();
        }
    }
    
    public override bool TakePredicate()
    {
        return _isBought == false & _needToTake;
    }

    protected override void OnTakeItem(StackItem stackItem)
    {
        Prices[stackItem.Type] -= stackItem.Amount;
        int count = Prices[stackItem.Type];
        bool bought = count <= 0 && Prices.Has(x => x.Value > 0) == false;
        if (bought)
        {
            _needToTake = false;
            _isBought = true;
        }

        float progress = Progress;
        BuyProgressChanged?.Invoke(progress);
        ProgressChanged?.Invoke(progress);
        
        _timer.ExecuteWithDelay(() =>
        {
            UsedResource?.Invoke(stackItem);
            stackItem.Pool.Return(stackItem);
            BuyProgressChangedDelayed?.Invoke(progress);
            if (bought)
            {
                _timer.ExecuteWithDelay(() =>
                {
                    Bought?.Invoke();
                    Finished?.Invoke();
                }, _buyDelay);
                Debug.Log($"Bought {_zoneSaver.Id}");
            }
        }, _resourceDeliverTime);
    }

    public void Buy()
    {
        if(_isBought)
            return;
        _isBought = true;
        _needToTake = false;
        _timer.ExecuteWithDelay(() => Bought?.Invoke(), _buyDelay);
    }

    public bool IsBoughtCheck()
    {
        return Prices.Has(x => x.Value > 0) == false;
    }
    
    public bool IsBought()
    {
        return _isBought;
    }
    
    public bool IsFinished()
    {
        return IsBoughtCheck();
    }

    public bool IsAvailable()
    {
        return gameObject.activeSelf;
    }
}
