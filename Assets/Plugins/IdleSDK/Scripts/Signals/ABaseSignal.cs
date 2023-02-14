using System.Collections.Generic;
using System;
using System.Linq;

namespace IdleBasesSDK.Signals
{
    public abstract partial class ABaseSignal<T> : ISignal
    {
        private List<Callback> _callbacks = new List<Callback>();

        public void On(T action)
        {
            _callbacks.Add(new Callback(action));
        }

        public void Off(T action)
        {
            var callbacks = _callbacks.FindAll(x => x.Handler.Equals(action));
            foreach (var callback in callbacks)
                _callbacks.Remove(callback);

        }

        public void Once(T action)
        {
            _callbacks.Add(new Callback(action, 1));
        }

        protected void DispatchInternal(Action<Callback> externalDispatch)
        {
            var callbacks = _callbacks.OrderBy(x => x.Priority);
            foreach (var callback in _callbacks)
            {
                callback.Handle();
                externalDispatch(callback);
            }

            _callbacks = _callbacks.FindAll(x => x.IsAvailable());
        }
    }
}