using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using ModestTree.Util;

public static class IEnumerableExtensions
{
    public static Dictionary<TKey, TValue> CloneDictionary<TKey, TValue>
        (this Dictionary<TKey, TValue> original) where TValue : System.ICloneable
    {
        Dictionary<TKey, TValue> result = new Dictionary<TKey, TValue>(original.Count,
            original.Comparer);
        
        foreach (KeyValuePair<TKey, TValue> entry in original)
            result.Add(entry.Key, (TValue) entry.Value.Clone());
        
        return result;
    }
    
    public static Dictionary<TKey, TValue> Copy<TKey, TValue>
        (this Dictionary<TKey, TValue> original)
    {
        Dictionary<TKey, TValue> result = new Dictionary<TKey, TValue>(original.Count,
            original.Comparer);
        
        foreach (KeyValuePair<TKey, TValue> entry in original)
            result.Add(entry.Key, entry.Value);
        
        return result;
    }
    

    public static bool Has<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate)
    {
        foreach (var sourceItem in source)
        {
            if (predicate(sourceItem))
                return true;
        }

        return false;
    }

    public static T Random<T>(this List<T> source)
    {
        int index = UnityEngine.Random.Range(0, source.Count);
        return source[index];
    }

    public static void ChangeActive(this List<GameObject> objects, bool active)
    {
        foreach (var gameObject in objects)
        {
            gameObject.SetActive(active);
        }
    }
}
