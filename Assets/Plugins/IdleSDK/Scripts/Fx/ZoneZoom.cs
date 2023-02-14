using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using IdleBasesSDK.Interactable;

public class ZoneZoom : MonoBehaviour
{
    [SerializeField] private ZoneBase _zoneBase;
    
    [SerializeField] private Transform _zoomModel;
    [SerializeField] private Vector3 _enterZoom = Vector3.one;
    [SerializeField] private Vector3 _exitZoom = Vector3.one;
    [SerializeField] private float _enterZoomDuration = 0.35f;
    
    private Tweener _zoomTweener;
    private void OnEnable()
    {
        _zoneBase.OnEnter += OnPlayerEnter;
        _zoneBase.OnExit += OnPlayerExit;
    }

    private void OnDisable()
    {
        _zoneBase.OnEnter -= OnPlayerEnter;
        _zoneBase.OnExit -= OnPlayerExit;
    }

    
    private void OnPlayerEnter(InteractableCharacter character)
    {
        _zoomTweener?.Kill();
        _zoomTweener = _zoomModel.DOScale(_enterZoom, _enterZoomDuration);
    }

    private void OnPlayerExit(InteractableCharacter character)
    {
        _zoomTweener?.Kill();
        _zoomTweener = _zoomModel.DOScale(_exitZoom, _enterZoomDuration);
    }
    
}
