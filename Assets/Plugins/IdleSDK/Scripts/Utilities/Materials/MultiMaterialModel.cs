using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using IdleBasesSDK.Materials;

public class MultiMaterialModel
{
    private List<MaterialPropertyBlock> _basePropertyBlocks = new List<MaterialPropertyBlock>();
    private List<MaterialPropertyBlock> _modifiedPropertyBlocks = new List<MaterialPropertyBlock>();

    private Renderer _renderer;
    private List<string> _keywordsToRefresh = new();

    public Transform transform => _renderer.transform;
    public GameObject gameObject => _renderer.gameObject;

    public MultiMaterialModel(Renderer renderer)
    {
        _renderer = renderer;
        InitPropertyBlocks();
    }

    private void InitPropertyBlocks()
    {
        for (int i = 0; i < _renderer.materials.Length; i++)
        {
            _basePropertyBlocks.Add(GetPropertyBlock(i));
            _modifiedPropertyBlocks.Add(GetPropertyBlock(i));
        }
    }

    private MaterialPropertyBlock GetPropertyBlock(int index)
    {
        var propertyBlock = new MaterialPropertyBlock();
        _renderer.GetPropertyBlock(propertyBlock, index);
        return propertyBlock;
    }
    
    public MultiMaterialModel ApplyModifier(IMaterialModifier materialModifier, string keywordToRefresh = "none")
    {
        if(keywordToRefresh != "none" && _keywordsToRefresh.Contains(keywordToRefresh) == false)
            _keywordsToRefresh.Add(keywordToRefresh);
        
        foreach (var modifiedPropertyBlock in _modifiedPropertyBlocks)
            materialModifier.ActualizePropertyBlock(modifiedPropertyBlock);

        return this;
    }

    public MultiMaterialModel ApplyBaseModifier(IMaterialModifier materialModifier)
    {
        foreach (var modifiedPropertyBlock in _basePropertyBlocks)
            materialModifier.ActualizePropertyBlock(modifiedPropertyBlock);

        return this;
    }
    
    public MultiMaterialModel SetBaseMaterials()
    {
        UpdateMaterial(_basePropertyBlocks);
        return this;
    }

    public MultiMaterialModel SetModifiedMaterials()
    {
        UpdateMaterial(_modifiedPropertyBlocks);
        return this;
    }

    private void UpdateMaterial(List<MaterialPropertyBlock> propertyBlocks)
    {
        for (int i = 0; i < propertyBlocks.Count(); i++)
        {
            _keywordsToRefresh.ForEach(x=> _renderer.materials[i].DisableKeyword(x));
            _renderer.SetPropertyBlock(propertyBlocks[i], i);
            _keywordsToRefresh.ForEach(x=> _renderer.materials[i].EnableKeyword(x));
        }
    }
}
