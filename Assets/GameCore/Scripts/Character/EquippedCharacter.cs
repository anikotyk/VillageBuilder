using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;

public class EquippedCharacter : InteractableCharacter
{
    [SerializeField] private WeaponController _weaponController;
    public WeaponController WeaponController => _weaponController;
}
