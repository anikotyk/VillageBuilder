
using System.Collections.Generic;
using UnityEngine;
using Zenject;

public interface IPool<T> where T : MonoBehaviour, IPoolItem<T>
{
    public T Prefab { get; }
    public int Size { get; }
    public Transform Parent { get; }

    public void Initialize();

    public void Initialize(DiContainer container);

    public T Get();

    public void Return(T poolItem);
}
