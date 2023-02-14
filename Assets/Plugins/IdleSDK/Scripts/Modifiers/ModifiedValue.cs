using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

[System.Serializable]
public class ModifiedValue<T>
{
    [SerializeField] private T StartValue;
    public T Value => GetValue();
    
    private List<STuple<object, ValueModifier<T>>> _modifiers = new();

    private T GetValue()
    {
        T result = StartValue;
        
        foreach (var modifier in _modifiers)
            result = modifier.Value2.ApplyModifier(result);

        return result;
    }

    public void AddModifier(object sender, ValueModifier<T> modifier)
    {
        var foundedModifer = _modifiers.Find(x => x.Value1 == sender);
        if (foundedModifer != null)
            _modifiers.Remove(foundedModifer);
        
        _modifiers.Add(new STuple<object, ValueModifier<T>>(sender, modifier));
    }

    public void RemoveModifier(object sender)
    {
        var modifierToRemove =_modifiers.Find(x => x.Value1 == sender);
        if(modifierToRemove != null)
            _modifiers.Remove(modifierToRemove);
    }
    
}
