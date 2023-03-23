using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public class SkinnedItem : MonoBehaviour, ISkinnedChanger
{
    [SerializeField] private string _itemId;
    [SerializeField] private List<Skin> _skins;
    [SerializeField] private Skin _defaultSkin;

    [Inject] private SkinManager _skinManager;
    
    private Skin _currentSkin;
    private Skin _selectedSkin;
    public string ItemId => _itemId;

    private void OnEnable()
    {
        _skinManager.ChangedSkin += OnSkinChange;
    }

    private void OnSkinChange(ISkinnedChanger skinnedChanger, string skinId)
    {
        if((object)skinnedChanger == (object)this || skinnedChanger.ItemId != ItemId)
            return;
        EquipSkin(skinId);
    }

    private void Awake()
    {
        EquipSavedSkin();
    }

    private void EquipSavedSkin()
    {
        string currentSkinId = ES3.Load(ItemId, defaultValue:_defaultSkin.Id);
        foreach (var skin in _skins)
            skin.Deselect();
        
        EquipSkin(currentSkinId);
    }

    public void SelectSkin(string id)
    {
        if(_currentSkin != null)
            _currentSkin.Deselect();
        if(_selectedSkin != null)
            _selectedSkin.Deselect();
        
        _selectedSkin = _skins.Find(x => x.Id == id);
        _selectedSkin.Select();
    }

    public void ResetSelection()
    {
        if(_selectedSkin != null)
            _selectedSkin.Deselect();

        if (_currentSkin != null)
            _currentSkin.Select();
        else
            EquipSavedSkin();
    }

    public void EquipSkin(string id)
    {
        var targetSkin = _skins.Find(x => x.Id == id);
        
        if(targetSkin == null)
            return;
        
        if(targetSkin.Available == false)
            return;

        if(_currentSkin != null)
            _currentSkin.Deselect();
        targetSkin.Select();
        _currentSkin = targetSkin;
    }

}
