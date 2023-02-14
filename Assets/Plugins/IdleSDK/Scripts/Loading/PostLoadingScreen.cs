using DG.Tweening;
using IdleBasesSDK.Utilities;
using UnityEngine;
using UnityEngine.UI;
using Zenject;

namespace IdleBasesSDK.Loading
{
    public class PostLoadingScreen : MonoBehaviour
    {
        [SerializeField] private CanvasGroup _canvasGroup;
        [SerializeField] private float _animationDuration;
        [SerializeField] private float _hideDelay;
        [SerializeField] private Slider _slider;
        [SerializeField, Range(0, 1)] private float _startSliderValue;

        [Inject] private Timer _timer;

        private void Start()
        {
            Debug.Log($"Loaded game scene scale {Time.timeScale}");
            _slider.value = _startSliderValue;
            _slider.DOValue(1.0f, _hideDelay).OnComplete(Hide);
        }
        private void Hide()
        {
            Debug.Log("Hide post loading screen");
            _canvasGroup.DOFade(0, _animationDuration).OnComplete(() => gameObject.SetActive(false));
        }
    }
}
