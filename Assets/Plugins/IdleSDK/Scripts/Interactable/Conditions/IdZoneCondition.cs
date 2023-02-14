using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;

public class IdZoneCondition : InteractCondition
{
    [SerializeField] private string _targetId;
    
    public override bool CanInteract(InteractableCharacter character)
    {
        return character.Id == _targetId;
    }
}
