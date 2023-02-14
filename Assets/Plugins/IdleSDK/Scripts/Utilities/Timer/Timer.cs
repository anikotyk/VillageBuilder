using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NepixSignals;

namespace IdleBasesSDK.Utilities
{
    public class Timer : MonoBehaviour
    {
        public TheSignal OnUpdate { get; } = new();
        
        public TimerDelay ExecuteWithDelay(Action action, float delay, TimeScale timeScale = TimeScale.Unscaled)
        {
            return new TimerDelay(action, this, delay, timeScale);
        }

        public TimerDelay ExecuteWithDelay<T>(Action<T> action, T t, float delay,
            TimeScale timeScale = TimeScale.Unscaled)
        {
            return new TimerDelay(() => action(t), this, delay, timeScale);
        }

        private void Update()
        {
            OnUpdate.Dispatch();
        }
    }
}

