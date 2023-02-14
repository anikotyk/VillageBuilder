using System;
using DG.Tweening;
using UnityEngine;
using NaughtyAttributes;
using UnityEngine.UI;

namespace IdleBasesSDK.Utilities
{
    public class ProgressibleView : MonoBehaviour
    {
        [SerializeField] private ProgressibleProvider _progressible;
        [SerializeField] private bool _isSlider;
        [SerializeField, ShowIf(nameof(_isSlider))] private Slider _slider;
        [SerializeField, HideIf(nameof(_isSlider))] private Image _image;
        [SerializeField] private bool _reverseProgress;

        private void OnEnable()
        {
            _progressible.Interface.ProgressChanged += OnProgressChanged;
        }

        private void OnDisable()
        {
            _progressible.Interface.ProgressChanged -= OnProgressChanged;
        }

        private void OnProgressChanged(float progress)
        {
            if (_reverseProgress)
                progress = 1 - progress;
            if (_isSlider)
                _slider.DOValue(progress, 0.1f);
            else
                _image.fillAmount = progress;
        }
    }
}
