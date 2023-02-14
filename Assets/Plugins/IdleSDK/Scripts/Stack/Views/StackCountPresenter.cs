using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Stack;

namespace IdleBasesSDK.Stack
{
    public class StackCountPresenter : StackCountChangeListener
    {
        [SerializeField] private View _modelView;
        [SerializeField] private int _sizeToShow;
        protected override void OnStackCountChanged(int count)
        {
            if(count >= _sizeToShow)
                _modelView.Show();
            else
                _modelView.Hide();
        }
    }
}

