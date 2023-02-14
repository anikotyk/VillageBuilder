
using UnityEngine;

public class FloatModifier: ValueModifier<float>
{
    private NumericAction _numericAction;
    private float _valueModifier;
    
    public FloatModifier(float valueModifier, NumericAction action)
    {
        _valueModifier = valueModifier;
        _numericAction = action;
    }
    
    public override float ApplyModifier(float value)
    {
        return _numericAction.Calculate(value, _valueModifier);
    }

    public static bool operator !=(FloatModifier modifier1, FloatModifier modifier2)
    {
        return !(modifier1 == modifier2);
    }
    public static bool operator ==(FloatModifier modifier1, FloatModifier modifier2)
    {
        return modifier1._numericAction == modifier2._numericAction &&
               Mathf.Abs(modifier1._valueModifier - modifier2._valueModifier) < 0.01f;
    }
}
