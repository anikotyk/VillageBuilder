using UnityEngine;
using Zenject;

namespace IdleBasesSDK.Utilities
{
    public class Disabler : MonoBehaviour
    {
        [SerializeField] private float _delay;
    
        [Inject] private Timer _timer;
        private TimerDelay _currentDelay;
        private void OnEnable()
        {
            _currentDelay?.Kill();
            _currentDelay = _timer.ExecuteWithDelay(() => gameObject.SetActive(false), _delay);
        }
    }
}

