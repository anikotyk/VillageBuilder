using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using Zenject;

public class BuyZoneFx : MonoBehaviour
{
    [SerializeField] private BuyZone _buyZone;
    [SerializeField] private Transform _costViewsParent;
    [SerializeField] private BuyZoneCostView _costViewPrefab;
    [SerializeField] private float _zoomOutTime = 0.35f;

    [Inject] private DiContainer _container;

    private Dictionary<ItemType, BuyZoneCostView> _costViews = new ();


    private void Awake()
    {
        foreach (var price in _buyZone.SourcePrices)
        {
            var costView = _container.InstantiatePrefab(_costViewPrefab, _costViewsParent)
                .GetComponent<BuyZoneCostView>();
            costView.Init(_buyZone, price.Key);
            _costViews.Add(price.Key, costView);
        }
    }

    private void OnEnable()
    {
        _buyZone.UsedResource += OnResourceUsed;
    }
    
    private void OnDisable()
    {
        _buyZone.UsedResource -= OnResourceUsed;
    }


    private void OnResourceUsed(StackItem stackItem)
    {
        BuyZoneCostView costView = _costViews[stackItem.Type];
        costView.Actualize();
        if (_buyZone.IsBought())
            _costViewsParent.DOScale(Vector3.zero, _zoomOutTime);

    }

    
}
