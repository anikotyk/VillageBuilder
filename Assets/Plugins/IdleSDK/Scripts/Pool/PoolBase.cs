using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public abstract class PoolBase<T> : IPool<T> where T : MonoBehaviour, IPoolItem<T>
{
    public abstract T Prefab { get; }
    public abstract int Size { get; }
    public abstract Transform Parent { get; }
    
    private List<T> _pool = new();
    private DiContainer _container;
    private bool _needToInject = false;

    private bool _initialized = false;

    private T SpawnItem()
    {
        T spawnedItem;
        if (_needToInject == false)
            spawnedItem = Object.Instantiate(Prefab, Parent);
        else
            spawnedItem = _container.InstantiatePrefab(Prefab, Parent).GetComponent<T>();
        spawnedItem.Pool = this;
        spawnedItem.GetComponent<T>().Pool = this;
        Return(spawnedItem);
        _pool.Add(spawnedItem);
        return spawnedItem;
    }
    
    public void Initialize()
    {
        if(_initialized)
            return;
        for (int i = 0; i < Size; i++)
            SpawnItem();
        _initialized = true;
    }

    public void Initialize(DiContainer container)
    {
        _needToInject = true;
        _container = container;
        Initialize();
    }

    public T Get()
    {
        if (_pool.Count == 0)
            SpawnItem();

        T takeItem = GetUniqueItem();
        takeItem.IsTook = true;
        _pool.Remove(takeItem);
        takeItem.TakeItem();
        takeItem.gameObject.SetActive(true);
        return takeItem;
    }

    private T GetUniqueItem()
    {
        int index = 0;
        var takeItem = _pool[index];
        
        while (takeItem.IsTook)
        {
            index++;
            if (index >= _pool.Count)
            {
                takeItem = SpawnItem();
                break;
            }
            takeItem = _pool[index];
        }

        return takeItem;
    }

    
    public void Return(T poolItem)
    {
        if(_pool.Contains(poolItem) == false)
            _pool.Add(poolItem);
        poolItem.IsTook = false;
        poolItem.ReturnItem();
        poolItem.transform.SetParent(Parent);
        poolItem.gameObject.SetActive(false);
    }
}
