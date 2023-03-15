using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;
using UnityEngine.Events;

public class Health : Destructible
{
    [SerializeField] private EquippedCharacterZone _characterZone;
    [SerializeField] private bool _externalUse;
    
    public UnityAction Died { get; set; }
    
    private void OnEnable()
    {
        _characterZone.OnInteractInternal += OnInteract;
        _characterZone.OnExit += OnCharacterExit;
    }

    private void OnDisable()
    {
        _characterZone.OnInteractInternal -= OnInteract;
    }

    private void OnInteract(EquippedCharacter equippedCharacter)
    {
        if(_externalUse)
            return;
        Use(equippedCharacter);
    }

    private void OnCharacterExit(InteractableCharacter character)
    {
        if(CurrentWeaponInUse == null)
            return;
        AbortWeaponUse(CurrentWeaponInUse);
    }
    
    protected override bool UseCondition(Weapon weapon)
    {
        return _characterZone.IsCharacterInside && _characterZone.Character.enabled && enabled && weapon.enabled;
    }
    
    protected override void OnHealthChanged(int health)
    {
        if (health <= 0)
            Died?.Invoke();
        
    }
}
