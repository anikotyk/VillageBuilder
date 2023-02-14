using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Views;

public class ZoneViewPresenter : MonoBehaviour
{
    [SerializeField] private View _view;
    [SerializeField] private ZoneBase _zoneBase;
    [SerializeField] private PresenterAction _onCharacterEnterZone = PresenterAction.Show;
    [SerializeField] private PresenterAction _onCharacterExitZone = PresenterAction.Hide;
    [SerializeField] private PresenterAction _onCharacterInteract = PresenterAction.None;

    private void OnEnable()
    {
        _zoneBase.OnEnter += OnEnter;
        _zoneBase.OnExit += OnExit;
        _zoneBase.OnInteract += OnInteract;
    }

    private void OnDisable()
    {
        _zoneBase.OnEnter -= OnEnter;
        _zoneBase.OnExit -= OnExit;
        _zoneBase.OnInteract -= OnInteract;
    }
    
    private void Present(PresenterAction action)
    {
        if (action == PresenterAction.Hide)
            _view.Hide();
        else if(action == PresenterAction.Show)
            _view.Show();
    }
    private void OnEnter(InteractableCharacter character) => Present(_onCharacterEnterZone);
    private void OnExit(InteractableCharacter character) => Present(_onCharacterExitZone);
    private void OnInteract(InteractableCharacter character) => Present(_onCharacterInteract);
   
}
