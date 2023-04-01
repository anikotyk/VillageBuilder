using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;

public class BubbleMaterialSwapper : BubbleIncreaseListener
{
    [SerializeField] private Material _insideBubbleMaterial;
    [SerializeField] private Material _outsideBubbleMartial;
    [SerializeField] private List<Renderer> _renderers;
    [SerializeField] private bool _destructible;
    
    [SerializeField, ShowIf(nameof(_destructible))] 
    private DestructibleModel _destructibleModel;

    private bool _insideMaterial = false;

    protected override Transform Target => transform;
    
    protected override void OnInsideBubble()
    {
        SetMaterial(_insideBubbleMaterial);
    }

    protected override void OnOutsideBubble()
    {
        SetMaterial(_outsideBubbleMartial);
    }

    private void SetMaterial(Material material)
    {
        if(_insideMaterial && material == _insideBubbleMaterial)
            return;
        
        if(_insideMaterial == false && material == _outsideBubbleMartial)
            return;

        _insideMaterial = material == _insideMaterial;

        foreach (var renderer in _renderers)
        {
            renderer.material = material;
        }
    }
}
