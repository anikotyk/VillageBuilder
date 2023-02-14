
public enum NumericAction
{
    None, 
    Add, 
    Multiply, 
    Divide, 
    Sub
}


public static class NumericActionExtension
{
    public static float Calculate(this NumericAction numericAction, float startValue, float modifierValue)
    {
        switch (numericAction)
        {
            case NumericAction.Add:
                return startValue + modifierValue;
            case NumericAction.Divide:
                return startValue / modifierValue;
            case NumericAction.Multiply:
                return startValue * modifierValue;
            case NumericAction.Sub:
                return startValue - modifierValue;
            default:
                return startValue;
        }
    }
    
    public static int Calculate(this NumericAction numericAction, int startValue, int modifierValue)
    {
        switch (numericAction)
        {
            case NumericAction.Add:
                return startValue + modifierValue;
            case NumericAction.Divide:
                return startValue / modifierValue;
            case NumericAction.Multiply:
                return startValue * modifierValue;
            case NumericAction.Sub:
                return startValue - modifierValue;
            default:
                return startValue;
        }
    }
}