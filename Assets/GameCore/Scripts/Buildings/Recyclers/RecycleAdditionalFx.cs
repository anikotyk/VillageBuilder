using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using Zenject;

public abstract class RecycleAdditionalFx : MonoBehaviour
{
    [SerializeField] private Recycler _recycler;
    [SerializeField] protected float CycleDuration;
    [SerializeField] protected Transform StartSpawnPoint;
    
    
    [Inject] protected Timer Timer;
    [Inject] private DiContainer _container;
    [Inject] private ResourceController _resourceController;
    
    protected Transform SourceItem;
    protected Transform ProductionItem;
    
    private bool _recycling = false;
    
    
    private void OnEnable()
    {
        SourceItem = SpawnResource(_recycler.SourceType);
        ProductionItem = SpawnResource(_recycler.ProductType);
        _recycler.OnStartRecycle += StartRecycle;
        _recycler.OnEndRecycle += EndRecycle;
        OnEnableInternal();
    }
    
    private void OnDisable()
    {
        _recycler.OnStartRecycle -= StartRecycle;
        _recycler.OnEndRecycle -= EndRecycle;
        OnDisableInternal();
    }

    protected virtual void OnEnableInternal(){}
    protected virtual void OnDisableInternal(){}
    
    private Transform SpawnResource(ItemType type)
    {
        var resource =  _container.InstantiatePrefab(_resourceController.GetPrefab(type), StartSpawnPoint).GetComponent<Resource>();
        resource.Claim();
        resource.gameObject.SetActive(false);
        return resource.transform;
    }

    private void StartRecycle()
    {
        _recycling = true;
        OnStartRecycle();
        RecycleCycle();
    }

    protected virtual void OnStartRecycle(){}
    private void RecycleCycle()
    {
        if(_recycling == false)
            return;
        ProductCycle();
        Timer.ExecuteWithDelay(RecycleCycle, CycleDuration);
    }

    protected abstract void ProductCycle();

    private void EndRecycle()
    {
        _recycling = false;
        OnEndRecycle();
    }
    protected virtual void OnEndRecycle(){}
}
