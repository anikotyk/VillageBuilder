using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TorchRefillPresenter : MonoBehaviour
{
    [SerializeField] private View _refillView;
    [SerializeField] private OutsideTimer _outsideTimer;

    private void OnEnable()
    {
        _outsideTimer.ProgressChanged += OnProgressChanged;
    }
    
    private void OnDisable()
    {
        _outsideTimer.ProgressChanged -= OnProgressChanged;
    }

    private void OnProgressChanged(float progress)
    {
        if(progress > 0.99f)
            _refillView.Show();
        else
            _refillView.Hide();
    }
}
