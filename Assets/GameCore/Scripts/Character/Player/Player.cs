using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK;
using IdleBasesSDK.Interactable;

public class Player : MonoBehaviour
{
    [SerializeField] private EquippedCharacter _equippedCharacter;
    [SerializeField] private StackableCharacter _stackableCharacter;
    [SerializeField] private Animator _animator;
    [SerializeField] private Transform _model;
    [SerializeField] private Movement _movement;
    [SerializeField] private CharacterControllerMovement _characterControllerMovement;
    
    public Animator Animator => _animator;
    public Transform Model => _model;
    public MovementHandler Movement => _movement.Handler;

    public EquippedCharacter Equipment => _equippedCharacter;
    public StackableCharacter Stack => _stackableCharacter;

    public ModifiedValue<float> Speed => _characterControllerMovement.Speed;

}
