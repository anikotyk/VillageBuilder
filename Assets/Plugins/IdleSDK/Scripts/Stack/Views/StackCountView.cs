using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using TMPro;

namespace IdleBasesSDK.Stack
{
    public class StackCountView : StackCountChangeListener
    {
        [SerializeField] private bool _showMaxSize;
        [SerializeField] private TMP_Text _countText;
        
        protected override void OnStackCountChanged(int count)
        {
            string additional = "";
            if (_showMaxSize)
                additional = $"/{Stack.MaxSize}";
            _countText.text = $"{Stack.ItemsCount}{additional}";
        }
    }
}

