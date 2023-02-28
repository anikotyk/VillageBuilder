using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Views;
using Zenject;

public class BubblePresenter : BubbleMoveListener
{
    [SerializeField] private View _view;
    [SerializeField] private bool _invert = false;


    protected override void OnInsideBubble()
    {
        if (_invert == false)
            _view.Hide();
        else
            _view.Show();
    }

    protected override void OnOutsideBubble()
    {
        if (_invert == false)
            _view.Show();
        else
            _view.Hide();
    }
}
