using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using UnityEngine.Events;
using Zenject;

public class ResourcePlace : MonoBehaviour
{
    [SerializeField] private InteractableCharacterZone _actionZone;
    [SerializeField] private GameObject _checkActiveObject;
    [SerializeField] private ItemType _placeType;
    [SerializeField] private int _capacity;
    [SerializeField] private bool _taskTarget = true;
    public bool AvailableToHelp => _checkActiveObject.activeInHierarchy && _taskTarget;
    public bool Active { get; private set; } = true;

    public Transform TaskPoint => _actionZone.transform;
    public UnityAction Finished { get; set; }
    public int Capacity => _capacity;

    public ItemType Type => _placeType;

    

    private void OnInteract()
    {
        UseCondition();
    }


    protected bool UseCondition()
    {
        return _actionZone.IsCharacterInside;
    }

    protected void OnHealthChanged(int health)
    {
        if (health <= 0)
        {
            Active = false;
            Finished?.Invoke();
        }
        else
        {
            Active = true;
        }
    }
    
    public void UseTask()
    {
    }


}
