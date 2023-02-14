using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using IdleBasesSDK.Utilities;
using Zenject;

public class DelayedView : View
{
    [SerializeField] private View _view;
    [SerializeField] private float _showDelay;
    [SerializeField] private float _hideDelay;
    public override bool IsHidden { get; }
    [Inject] private Timer _timer;
    private TimerDelay _showTimerDelay;
    private TimerDelay _hideTimerDelay;
    
    public override void Show()
    {
        _hideTimerDelay?.Kill();
        if(_showTimerDelay is {Status: TimerStatus.Active})
            return;
        _showTimerDelay = _timer.ExecuteWithDelay(_view.Show, _showDelay);
    }

    public override void Hide()
    {
        _showTimerDelay?.Kill();
        if(_hideTimerDelay is {Status: TimerStatus.Active})
            return;
        _hideTimerDelay = _timer.ExecuteWithDelay(_view.Hide, _hideDelay);
    }
}
