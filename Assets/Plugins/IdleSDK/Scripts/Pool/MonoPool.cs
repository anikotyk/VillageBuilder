using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Zenject;

[System.Serializable]
public class MonoPool<T>: PoolBase<T> where T : MonoBehaviour, IPoolItem<T>
{
    [SerializeField] private T _prefab;
    [SerializeField] private int _size;
    [SerializeField] private Transform _parent;
    
    public override T Prefab => _prefab;
    public override int Size => _size;
    public override Transform Parent => _parent;


}
