using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;

public class HelperLocker : MonoBehaviour
{
    [SerializeField] private ProgressibleProvider _progressibleProvider;
    [SerializeField] private Helper _helper;
    [SerializeField] private string _helperId;

    public bool IsLocked => ES3.Load(_helperId, true);
    
    public UnityAction Released { get; set; }
    private void OnEnable()
    {
        if(IsLocked == false)
            return;
        _helper.enabled = false;
        _progressibleProvider.Interface.ProgressChanged += OnProgressChanged;
    }

    private void OnDisable()
    {
        _progressibleProvider.Interface.ProgressChanged -= OnProgressChanged;
    }

    private void OnProgressChanged(float progress)
    {
        if(progress > 0.01f)
            return;
        Release();
    }

    private void Release()
    {
        ES3.Save(_helperId, false);
        _helper.enabled = true;
        Released?.Invoke();
    }
}
