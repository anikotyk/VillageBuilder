using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using UnityEngine.Events;
using Zenject;

public class Recycler : StackTaker
{
    [SerializeField] private StackProvider _sourceStack;
    [SerializeField] private StackProvider _productionStack;
    [SerializeField] private StackItemLocator _stackItemLocator;
    [SerializeField] private int _itemsToRecycle;
    [SerializeField] private ItemType _takeType;
    [SerializeField] private float _addDelay;
    [SerializeField] private float _startProductDelay;
    [SerializeField] private float _recycleItemTime;
    [SerializeField] private ItemType _productType;
    [SerializeField] private List<RecycleCondition> _recycleConditions;
    [SerializeField] private float _defaultActualizeDelay = 3.0f;

    [Inject] private ResourceController _resourceController;
    [Inject] private DiContainer _diContainer;
    [Inject] private Timer _timer;
    

    private bool _productionStarted = false;
    private bool _productionInProcess = false;

    private int _delayedItemsCount = 0;

    public ItemType ProductType => _productType;
    public ItemType SourceType => _takeType;
    private int DelayedItemsCount
    {
        get => _delayedItemsCount;
        set
        {
            _delayedItemsCount = Mathf.Clamp(value, 0, int.MaxValue);
        }
    }
    protected override Vector3 DestinationDelta => _stackItemLocator.GetNextDelta(DelayedItemsCount);
    

    public UnityAction OnStartRecycle;
    public UnityAction OnEndRecycle;

    public override ItemType GetTypeToTake(StackableCharacter interactableCharacter) => _takeType;
    
    private void Start()
    {
        ActualizeProduction();
        _timer.ExecuteWithDelay(DelayedActualize, _defaultActualizeDelay);
    }

    private void DelayedActualize()
    {
        ActualizeProduction();
        _timer.ExecuteWithDelay(DelayedActualize, _defaultActualizeDelay);
    }

    public override bool TakePredicate()
    {
        return _sourceStack.Interface.ItemsCount <= _sourceStack.Interface.MaxSize;
    }

    protected override void OnTakeItem(StackItem stackItem)
    {
        DelayedItemsCount++;
        _timer.ExecuteWithDelay(() =>
        {
            if (_sourceStack.Interface.TryAdd(stackItem))
            {
                ActualizeProduction();
            }

            DelayedItemsCount--;
        }, _addDelay);
        
    }

    private void ActualizeProduction()
    {
        if (_sourceStack.Interface.ItemsCount >= _itemsToRecycle && PassConditions())
            StartProduction();
        else
            StopProduction();
    }

    private void StartProduction()
    {
        if(_productionStarted || _productionInProcess)
            return;
        _productionStarted = true;
        OnStartRecycle?.Invoke();
        StartCoroutine(Production());
    }

    private bool PassConditions()
    {
        foreach (var condition in _recycleConditions)
        {
            if (condition.CanRecycle() == false)
                return false;
        }

        return true;
    }

    private IEnumerator Production() 
    {
        yield return new WaitForSeconds(_startProductDelay);
        while (_productionStarted)
        {
            if (_sourceStack.Interface.ItemsCount < _itemsToRecycle
                || _sourceStack.Interface.Items[_takeType].Value < _itemsToRecycle
                || PassConditions() == false)
            {
                TryStop();
                yield return null;
                continue;
            }
            
            
            _productionInProcess = true;
            _recycleConditions.ForEach(x=>x.HandleConditionPassed());
            for (int i = 1; i <= _itemsToRecycle; i++)
            {
                if (_sourceStack.Interface.TryTake(_takeType, out StackItem takeItem, transform) == false)
                {
                    TryStop();
                    break;
                }
            }

            yield return new WaitForSeconds(_recycleItemTime);

            var resource = _resourceController.GetInstance(_productType);
            resource.transform.SetParent(_productionStack.GameObject.transform, false);
            resource.Claim();
            _productionStack.Interface.TryAdd(resource);
        }

        TryStop();
    }
    
    private void StopProduction()
    {
        if(_productionStarted == false)
            return;
        
        _productionStarted = false;
        OnEndRecycle?.Invoke();
    }

    private void TryStop()
    {
        if (DelayedItemsCount >= _itemsToRecycle)
            return;
        _productionStarted = false;
        _productionInProcess = false;
        
        OnEndRecycle?.Invoke();
    }

}
