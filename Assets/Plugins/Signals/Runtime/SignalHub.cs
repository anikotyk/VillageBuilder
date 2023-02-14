using System;
using System.Collections.Generic;
using System.Diagnostics;
using NepixSignals.Api;
using Debug = UnityEngine.Debug;

#pragma warning disable 0649

namespace NepixSignals
{
    /// <summary>
    /// A hub for Signals you can implement in your classes
    /// </summary>
    [DebuggerDisplay("Id = {id}")]
    public class SignalHub
    {
        private readonly Dictionary<Type, ISignal> _signals = new Dictionary<Type, ISignal>();

        public readonly string id;

        public SignalHub parent { get; private set; }
        public List<SignalHub> subs { get; private set; }
        public bool propagateToSubs = true;

        public SignalHub(string id)
        {
            this.id = id;
        }
        
        /// <summary>
        /// Getter for a signal of a given type
        /// </summary>
        /// <typeparam name="SType">Type of signal</typeparam>
        /// <returns>The proper signal binding</returns>
        public SType Get<SType>() where SType : ISignal, new()
        {
            Type signalType = typeof(SType);

            if (_signals.TryGetValue(signalType, out var signal))
            {
                return (SType) signal;
            }

            return (SType) Bind(signalType);
        }

        /*/// <summary>
        /// Reassign all signals to another hub. 
        /// </summary>
        /// <param name="hub">target hub</param>
        public void Reassign(SignalHub hub)
        {
            foreach (KeyValuePair<Type,ISignal> signal in signals) {
                hub.signals.Add(signal.Key, signal.Value);
            }
            signals.Clear();
        }*/

        /// <summary>
        /// Manually provide a SignalHash and bind it to a given listener
        /// (you most likely want to use an AddListener, unless you know exactly
        /// what you are doing)
        /// </summary>
        /// <param name="signalHash">Unique hash for signal</param>
        /// <param name="handler">Callback for signal listener</param>
        public void OnToHash(string signalHash, Action handler)
        {
            ISignal signal = GetSignalByHash(signalHash);
            (signal as ASignal)?.On(handler);
        }

        public void OnceToHash(string signalHash, Action handler)
        {
            ISignal signal = GetSignalByHash(signalHash);
            (signal as ASignal)?.Once(handler);
        }

        public void DispatchToHash(string signalHash)
        {
            ISignal signal = GetSignalByHash(signalHash);
            // Check to prevent recursive
            if (signal?.dispatchToParent == true) return;
            (signal as ASignal)?.Dispatch();
        }

        public void DispatchToHash<T>(string signalHash, T arg)
        {
            ISignal signal = GetSignalByHash(signalHash);
            // Check to prevent recursive
            if (signal?.dispatchToParent == true) return;
            (signal as ASignal<T>)?.Dispatch(arg);
        }

        public void DispatchToHash<T, U>(string signalHash, T arg1, U arg2)
        {
            ISignal signal = GetSignalByHash(signalHash);
            // Check to prevent recursive
            if (signal?.dispatchToParent == true) return;
            (signal as ASignal<T, U>)?.Dispatch(arg1, arg2);
        }

        public void DispatchToHash<T, U, V>(string signalHash, T arg1, U arg2, V arg3)
        {
            ISignal signal = GetSignalByHash(signalHash);
            // Check to prevent recursive
            if (signal?.dispatchToParent == true) return;
            (signal as ASignal<T, U, V>)?.Dispatch(arg1, arg2, arg3);
        }

        /// <summary>
        /// Manually provide a SignalHash and unbind it from a given listener
        /// (you most likely want to use a RemoveListener, unless you know exactly
        /// what you are doing)
        /// </summary>
        /// <param name="signalHash">Unique hash for signal</param>
        /// <param name="handler">Callback for signal listener</param>
        public void OffFromHash(string signalHash, Action handler)
        {
            ISignal signal = GetSignalByHash(signalHash);
            (signal as ASignal)?.Off(handler);
        }

        public SignalHub CreateSub(string id)
        {
            var sub = new SignalHub(id)
            {
                parent = this
            };
            subs ??= new List<SignalHub>();
            subs.Add(sub);
            return sub;
        }

        private ISignal Bind(Type signalType)
        {
            if (_signals.TryGetValue(signalType, out var signal))
            {
                Debug.LogError($"Signal already registered for type {signalType}");
                return signal;
            }

            signal = (ISignal) Activator.CreateInstance(signalType);
            signal.hub = this;
            _signals.Add(signalType, signal);
            return signal;
        }

        private ISignal Bind<T>() where T : ISignal, new()
        {
            return Bind(typeof(T));
        }

        private ISignal GetSignalByHash(string signalHash)
        {
            foreach (ISignal signal in _signals.Values)
            {
                if (signal.hash == signalHash)
                {
                    return signal;
                }
            }

            return null;
        }
    }
}