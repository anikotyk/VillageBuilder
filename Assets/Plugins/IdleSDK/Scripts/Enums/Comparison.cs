using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum Comparison
{
    Greater,
    GreaterEqual,
    Less,
    LessEqual,
    Equal, 
    NotEqual
}

public static class ComparisonExtension
{
    public static bool Compare(this Comparison comparison, float number1, float number2)
    {
        switch (comparison)
        {
            case Comparison.Equal:
                return number1 == number2;
            case Comparison.NotEqual:
                return number1 != number2;
            case Comparison.Greater:
                return number1 > number2;
            case Comparison.GreaterEqual:
                return number1 >= number2;
            case Comparison.Less:
                return number1 < number2;
            case Comparison.LessEqual:
                return number1 <= number2;
        }

        return false;
    }

    public static bool Compare(this Comparison comparison, int number1, int number2)
    {
        return comparison.Compare((float) number1, number2);
    }

    public static bool Compare(this float number1, float number2, Comparison comparison)
    {
        return comparison.Compare(number1, number2);
    }
}
