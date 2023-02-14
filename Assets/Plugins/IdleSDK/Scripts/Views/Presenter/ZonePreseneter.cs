using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Interactable;


namespace IdleBasesSDK.Views
{
    public class ZonePreseneter : ViewPresenter
    {
        [SerializeField] private ZoneBase _zoneBase;
        [SerializeField] private PresenterAction _enterAction;
        [SerializeField] private PresenterAction _exitAction;
        [SerializeField] private PresenterAction _interactAction;

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

        private void OnEnter(InteractableCharacter character)
        {
            HandlePresenterAction(_enterAction);
        }
        
        private void OnExit(InteractableCharacter character)
        {
            HandlePresenterAction(_exitAction);
        }
        
        private void OnInteract(InteractableCharacter character)
        {
            HandlePresenterAction(_interactAction);
        }
    } 
}

