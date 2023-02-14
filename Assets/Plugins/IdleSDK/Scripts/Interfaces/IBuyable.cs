
using System;
using UnityEngine.Events;

public interface IBuyable
{
    public float Price { get; }
    public void Buy();

}
