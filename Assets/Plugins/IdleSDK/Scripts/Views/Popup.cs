using NaughtyAttributes;
using UnityEngine;
using Haptic;
using IdleBasesSDK.Utilities;
using UnityEngine.Events;
using Zenject;

namespace IdleBasesSDK.Views
{
    public class Popup : MonoBehaviour
    {
        [SerializeField] private GameObject _popupModel;
        [SerializeField] private bool _pauseOnShow = true;

        [Inject] private PauseManager _pauseManager;
        [Inject] private IHapticService _hapticService;

        [Button("Show")]
        public void Show()
        {
            _popupModel.SetActive(true);
            _hapticService.Selection();
            if(_pauseOnShow)
                _pauseManager.Pause(this);
            OnShow();
        }

        public void Hide()
        {
            OnHide();
            _popupModel.SetActive(false);
            if(_pauseOnShow)
                _pauseManager.Resume(this);
        }

        protected virtual void OnShow(){}
        protected virtual void OnHide(){}
    }
}

