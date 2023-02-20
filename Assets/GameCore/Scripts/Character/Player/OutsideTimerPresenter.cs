using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class OutsideTimerPresenter : MonoBehaviour
{
    [SerializeField] private OutsideTimer _outsideTimer;
    [SerializeField] private View _view;

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
        if(progress > 0.01f)
            _view.Show();
        else
            _view.Hide();
    }
}
