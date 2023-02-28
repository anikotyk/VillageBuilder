using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Interactable;
using IdleBasesSDK.Stack;
using IdleBasesSDK.Utilities;
using Zenject;

public class BuyZoneSaver : Saver<Dictionary<ItemType, int>>
{
    [SerializeField] private ZoneBase _zoneBase;
    [SerializeField] private BuyZone _buyZone;

    private Dictionary<ItemType, int> _defaultValue = new ();

    protected override Dictionary<ItemType, int> DefaultValue
    {
        get
        {
            if (_defaultValue.Count == 0)
                _defaultValue = _buyZone.SourcePrices.Copy();
            return _defaultValue;
        }
    }

    private void OnEnable()
    {
        if (_buyZone.IsBought())
        {
            _buyZone.Buy();
            return;
        }

        _zoneBase.OnExit += OnBuyProgressChanged;
    }

    private void OnDisable()
    {
        _zoneBase.OnExit -= OnBuyProgressChanged;
    }

    protected override Dictionary<ItemType, int> GetSaveData() => _buyZone.Prices;
    protected override bool NeedToSave()
    {
        if (_buyZone.IsBought())
            return false;
        return true;
    }


    private void OnBuyProgressChanged(InteractableCharacter character)
    {
        Save();
    }


}
