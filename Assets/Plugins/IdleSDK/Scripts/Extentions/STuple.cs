using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[System.Serializable]
public class STuple<T1, T2>
{
    public T1 Value1;
    public T2 Value2;

    public STuple(T1 t1, T2 t2)
    {
        Value1 = t1;
        Value2 = t2;
    }
}


[System.Serializable]
public class STuple<T1, T2, T3>
{
    public T1 Value1;
    public T2 Value2;
    public T3 Value3;

    public STuple(T1 t1, T2 t2, T3 t3)
    {
        Value1 = t1;
        Value2 = t2;
        Value3 = t3;
    }
}
