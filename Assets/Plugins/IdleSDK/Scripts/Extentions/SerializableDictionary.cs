using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[Serializable]
public class SerializableDictionary<T1, T2>
{
    [SerializeField] private List<TempTuple> _tempTuples;

    [Serializable]
    private class TempTuple
    {
        public T1 Key;
        public T2 Value;
    }

    private Dictionary<T1, T2> _dictionary = new();

    private Dictionary<T1, T2> GetDictionary()
    {
        if (_dictionary.Count == 0)
        {
            foreach (var tempTuple in _tempTuples)
            {
                _dictionary.Add(tempTuple.Key, tempTuple.Value);
            } 
        }
        return _dictionary;
    }

    public T2 this[T1 key] => GetDictionary()[key];

}
