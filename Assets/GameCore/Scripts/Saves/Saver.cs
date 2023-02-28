﻿using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using DG.Tweening;
using NaughtyAttributes;
using IdleBasesSDK.Signals;
using IdleBasesSDK.Utilities;
using UniRx;
using Zenject;
using Debug = UnityEngine.Debug;
using Random = UnityEngine.Random;

public abstract class Saver<T> : MonoBehaviour, IDisposable
{
    [SerializeField] private string _id;
    [SerializeField] private float _saveDelay;
    
    protected abstract T DefaultValue { get; }
    public string Id => _id;

    private void Start()
    {
        DOVirtual.DelayedCall(_saveDelay + Random.Range(-5.0f, 5f), DelayedSave);
    }
    
    public void Save(T saveItem)
    {
        Observable.Start(() =>
        {
            ES3.Save(_id, saveItem, _id);
        }).ObserveOnMainThread().Subscribe();
    }

    public void Save()
    {
        Save(GetSaveData());
    }

    public T GetSave()
    {
        return ES3.Load(_id, _id, DefaultValue);
    }

    protected abstract T GetSaveData();
    protected abstract bool NeedToSave();
    
    private void DelayedSave()
    {
        Save(GetSaveData());
        DOVirtual.DelayedCall(_saveDelay, DelayedSave);
    }
    

    [Button("ClearSave")]
    private void ClearSave()
    {
        ES3.DeleteKey(_id);
    }
    
    private void OnApplicationPause(bool pauseStatus)
    {
        Save();
    }

    private void OnApplicationQuit()
    {
        Save();
    }

    public void Dispose()
    {
    }
}
