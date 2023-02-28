using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BubbleSpeedBooster : BubbleMoveListener
{
    [SerializeField] private float _speedModifierValue;
    [SerializeField] private NumericAction _modifierAction;
    
    
    protected override void OnInsideBubble()
    {
        Player.Speed.AddModifier(this, new FloatModifier(_speedModifierValue, _modifierAction));
    }

    protected override void OnOutsideBubble()
    {
        Player.Speed.RemoveModifier(this);
    }
}
