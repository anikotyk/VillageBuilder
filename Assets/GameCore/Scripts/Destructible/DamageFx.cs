using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Materials;

public class DamageFx : MonoBehaviour
{
    [SerializeField] private Destructible _destructible;
    [SerializeField] private float _zoomMultiplier;
    [SerializeField] private float _zoomTime;
    [SerializeField] private float _zoomOutTime;
    [SerializeField] private List<Renderer> _models;
    [SerializeField] private ParticleSystem _particleSystem;
    [SerializeField, ColorUsage(false, true)] private Color _highlightEmissionColor;
    [SerializeField] private string _emissionMaterialParameter = "_Emission";
    [SerializeField] private bool _reloadKeyword;
    [SerializeField, ShowIf(nameof(_reloadKeyword))] private string _keywordToReload = "_MK_EMISSION";
   
    private List<MultiMaterialModel> _multiMaterialModels = new();
    public List<MultiMaterialModel> MultiMaterialModels
    {
        get
        {
            if (_multiMaterialModels.Count == 0)
            {
                var emissionModifier = new ColorModifier(_emissionMaterialParameter, _highlightEmissionColor);
                foreach (var render in _models)
                {
                    var model = new MultiMaterialModel(render);
                    if(_reloadKeyword)
                        model.ApplyModifier(emissionModifier, _keywordToReload);
                    else
                        model.ApplyModifier(emissionModifier);
                    _multiMaterialModels.Add(model);
                }
            }
            return _multiMaterialModels;
        }
    }

    private void OnEnable()
    {
        _destructible.HealthChanged += OnHealthChanged;
    }

    private void OnDisable()
    {
        _destructible.HealthChanged -= OnHealthChanged;
    }
    
    private void OnHealthChanged()
    {
        foreach (var model in _models)
        {
            MultiMaterialModels.ForEach(x=> x.SetModifiedMaterials());
            
            model.transform.DOScale(Vector3.one * _zoomMultiplier, _zoomTime).OnComplete(() =>
            {
                model.transform.DOScale(Vector3.one, _zoomOutTime).SetEase(Ease.OutBack);
                MultiMaterialModels.ForEach(x=> x.SetBaseMaterials());
            });
            
            if(_particleSystem != null)
                _particleSystem.Play();
        }
    }

    public void ApplyModifier(IMaterialModifier modifier)
    {
        foreach (var model in MultiMaterialModels)
        {
            model.ApplyBaseModifier(modifier);
        }
    }
}
