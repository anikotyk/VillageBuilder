using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Stack;
using TMPro;
using UnityEngine.UI;
using Zenject;

public class UpgradeViewFx : MonoBehaviour
{
    [SerializeField] private UpgradeView _upgradeView;
    [SerializeField] private Button _upgradeButton;
    [SerializeField] private Transform _destinationPoint;
    [SerializeField] private TMP_Text _priceText;
    [SerializeField] private View _closeButtonZoomView;
    [Header("Fxs")]
    [SerializeField] private RectTransform _model;
    [SerializeField] private Puncher _puncher;
    [SerializeField] private Bouncer _bouncer;
    
    [Inject] private Player _player;
    [Inject] private ResourcesFx _resourcesFx;

    private int _waitCount = 0;
    private int _iterationPriceDecrease = 0;
    private int _price = 0;
    
    private void OnEnable()
    {
        _upgradeView.Upgraded += OnUpgrade;
    }

    private void OnDisable()
    {
        _upgradeView.Upgraded -= OnUpgrade;
    }
    

    [Button("Test")]
    private void OnUpgrade(IEnumerable<StackItem> stackItems)
    {
        _upgradeButton.interactable = false;
        _puncher.Punch(_model);
        _puncher.Punch(_player.Model);
        _waitCount = _resourcesFx.Visualize(stackItems, _destinationPoint.position, OnFxReceiveDestination);
        _closeButtonZoomView.Hide();
        _price = Int32.Parse(_priceText.text);
        _iterationPriceDecrease = _price / _waitCount;
        
    }
    
    private void OnFxReceiveDestination()
    {
        _waitCount--;
        if (_waitCount == 0)
        {
            _puncher.Punch(_model);
            _bouncer.Bounce();
            _upgradeView.Actualize();
            _closeButtonZoomView.Show();
            return;
        }
        
        _price -= _iterationPriceDecrease;
        _priceText.text = _price.ToString();
        _bouncer.Bounce();
    }
}
