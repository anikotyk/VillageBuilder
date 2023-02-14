using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public class SimplePool<T> : PoolBase<T> where T : MonoBehaviour, IPoolItem<T>
{
    public override T Prefab { get; }
    public override int Size { get; }
    public override Transform Parent { get; }

    public SimplePool(T prefab, int size, Transform parent)
    {
        Prefab = prefab;
        Size = size;
        Parent = parent;
    }
}
