using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public abstract class ValueModifier<T>
{
    public abstract T ApplyModifier(T value);
}
