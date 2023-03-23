using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using UnityEngine.Events;

public class DropItemsFromStack : MonoBehaviour, ITask
{
    [SerializeField] private StackableCharacterZone _dropZone;
    [SerializeField] private Transform _taskPoint;
    public bool AvailableToHelp => true;
    public bool Active => true;
    public Transform TaskPoint => _taskPoint;
    public UnityAction Finished { get; set; }
    public void UseTask()
    {
        if(_dropZone.IsCharacterInside == false)
            return;
        if(_dropZone.Character.MainStack.ItemsCount <= 0)
            Finished?.Invoke();
    }

    private void OnEnable()
    {
        _dropZone.OnInteractInternal += OnInteract;
    }

    private void OnInteract(StackableCharacter character)
    {
        if(character.MainStack.ItemsCount <= 0)
            Finished?.Invoke();
    }
}
