using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public interface IPoolItem<T> where T : MonoBehaviour, IPoolItem<T>
{
    IPool<T> Pool { get; set; }
    bool IsTook { get; set; }

    void TakeItem();
    void ReturnItem();
}

