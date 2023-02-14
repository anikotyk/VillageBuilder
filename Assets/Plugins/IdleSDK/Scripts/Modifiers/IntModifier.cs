
public class IntModifier : ValueModifier<int>
{
    private NumericAction _numericAction;
    private int _valueModifier;

    public IntModifier(int valueModifier, NumericAction action)
    {
        _valueModifier = valueModifier;
        _numericAction = action;
    }

    public override int ApplyModifier(int value)
    {
        return _numericAction.Calculate(value, _valueModifier);
    }
    
}
