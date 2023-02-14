using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SpeedModifier
{
    public object Sender { get; }
    public FloatModifier Modifier { get; }

    public SpeedModifier(object sender, FloatModifier floatModifier)
    {
        Sender = sender;
        Modifier = floatModifier;
    }

    public SpeedModifier(object sender, float modifier, NumericAction action = NumericAction.Multiply) : this(sender, new FloatModifier(modifier, action))
    {
    }

    public float CalculateSpeed(float startSpeed)
    {
        return Modifier.ApplyModifier(startSpeed);
    }
}
