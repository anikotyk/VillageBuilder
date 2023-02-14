using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class StaserMath
{
    public static float MinAbs(float value1, float value2)
    {
        if (Mathf.Abs(value1) < Mathf.Abs(value2))
            return value1;
        return value2;
    }
    
    public static float MaxAbs(float value1, float value2)
    {
        if (Mathf.Abs(value1) < Mathf.Abs(value2))
            return value2;
        return value1;
    }

    public static float Sqr(this float value)
    {
        return value * value;
    }
}
