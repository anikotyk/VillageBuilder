using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using NaughtyAttributes;
using IdleBasesSDK.Materials;
using IdleBasesSDK.Utilities;
using Zenject;

public class BubbleBrightnessChanger : MonoBehaviour
{
    [SerializeField] private List<Renderer> _onScaleRenderers;
    [SerializeField] private List<Renderer> _onScaleEndRenderers;
    [SerializeField] private string _colorParameter;
    [SerializeField] private Gradient _gradient;
    [SerializeField] private float _maxDistance;
    [SerializeField] private DamageFx _damageFx;

    [Inject] private Bubble _bubble;

    private List<MultiMaterialModel> _onScaleModels = new();
    private List<MultiMaterialModel> _onScaleEndModels = new();

    public List<MultiMaterialModel> OnScaleModels
    {
        get
        {
            if (_onScaleModels == null || _onScaleModels.Count == 0)
            {
                _onScaleModels = new();
                foreach (var renderer in _onScaleRenderers)
                    _onScaleModels.Add(new MultiMaterialModel(renderer));
            }
            return _onScaleModels;
        }
    }
    
    public List<MultiMaterialModel> OnScaleEndModels
    {
        get
        {
            if (_onScaleEndModels == null || _onScaleEndModels.Count == 0)
            {
                _onScaleEndModels = new();
                foreach (var renderer in _onScaleEndRenderers)
                    _onScaleEndModels.Add(new MultiMaterialModel(renderer));
            }
            return _onScaleEndModels;
        }
    }

    private void OnEnable()
    {
        _bubble.StartScaling += OnScale;
        _bubble.EndScale += OnEndScale;
    }
    private void OnDisable()
    {
        _bubble.StartScaling -= OnScale;
        _bubble.EndScale -= OnEndScale;
    }

    private void OnEndScale()
    {
        ActualizeEndScaleModels();
    }
    
    private void OnScale(float scale)
    {
        StartCoroutine(OnScaling());
    }

    private IEnumerator OnScaling()
    {
        while (_bubble.IsScaling)
        {
            ActualizeScaleModels();
            yield return null;
        }
    }
    
    private void ActualizeScaleModels()
    {
        Actualize(OnScaleModels, _bubble.GetSquaredDistanceToBubble(transform.position));
    }
    
    private void ActualizeEndScaleModels()
    {
        Actualize(OnScaleEndModels, _bubble.GetSquaredDistanceToBubble(transform.position));
    }
    
    private void Actualize(List<MultiMaterialModel> models, float sqrDistance)
    {
        var brightnessCoefficient = sqrDistance / (_maxDistance * _maxDistance);
        var colorModifier = new ColorModifier(_colorParameter, _gradient.Evaluate(brightnessCoefficient));
        _damageFx.ApplyModifier(colorModifier);
        foreach (var multiMaterialModel in models)
        {
            if(multiMaterialModel.gameObject.activeInHierarchy == false)
                continue;
            multiMaterialModel.ApplyModifier(colorModifier).SetModifiedMaterials();
        }
    }

    [Button("ActualizeScaleColor")]
    private void ActualizeScaleEditor()
    {
        ActualizeScaleModels();
    }
    [Button("ActualizeScaleEndColor")]
    private void ActualizeScaleEndEditor()
    {
        ActualizeEndScaleModels();
    }
}
