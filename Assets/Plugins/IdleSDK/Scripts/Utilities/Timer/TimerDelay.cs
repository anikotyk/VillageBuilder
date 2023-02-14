using UnityEngine;
using System.Collections;
using System;
using UniRx;


namespace IdleBasesSDK.Utilities
{
    public class TimerDelay
    {
        public float Duration { get; private set; }
        public float WaitedTime { get; private set; } = 0.0f;
        public float TimeLeft => Duration - WaitedTime;
        public int ActionsCount { get; private set; } = 0;
        public TimerStatus Status { get; private set; }
        private TimeScale Scale;
        private Timer _timer;
        private bool _paused = false;

        private Action _action;

        public TimerDelay(Action action, Timer timer, float duration, TimeScale scale = TimeScale.Unscaled)
        {
            Status = TimerStatus.Active;
            _timer = timer;
            Duration = duration;
            timer.OnUpdate.On(OnUpdate);
            _action += action;
            ActionsCount++;
        }

        private void OnUpdate()
        {
            if (_paused == false)
                WasteTime();
            
            if (WaitedTime >= Duration)
            {
                Kill();
                _action?.Invoke();
            }
        }

        private void WasteTime()
        {
            if(Scale == TimeScale.Unscaled)
                WaitedTime += Time.unscaledDeltaTime;
            else
                WaitedTime += Time.deltaTime;
        }
        
        public void Kill()
        {
            if(Status == TimerStatus.Ended)
                return;
            
            Status = TimerStatus.Ended;
            _timer.OnUpdate.Off(OnUpdate);
        }

        public void Pause()
        {
            _paused = true;
        }

        public void Resume()
        {
            _paused = false;
        }

        public TimerDelay AddAction(Action action)
        {
            _action += action;
            ActionsCount++;
            return this;
        }

        public void AddTime(float time)
        {
            Duration += time;
        }


    }
}
