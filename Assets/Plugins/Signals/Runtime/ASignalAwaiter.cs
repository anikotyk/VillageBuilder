using System;
using System.Runtime.CompilerServices;
using JetBrains.Annotations;

namespace NepixSignals
{
    [PublicAPI]
    public static class ASignalsAsync
    {
        public static ASignalAwaiter GetAwaiter(this ASignal signal) => new(signal);
        public static SignalAwaiter<T> GetAwaiter<T>(this ASignal<T> signal) => new(signal);
        public static SignalAwaiter<T, U> GetAwaiter<T, U>(this ASignal<T, U> signal) => new(signal);
        public static SignalAwaiter<T, U, V> GetAwaiter<T, U, V>(this ASignal<T, U, V> signal) => new(signal);
    }
    
    [PublicAPI]
    public class ASignalAwaiter : INotifyCompletion
    {
        private ASignal _signal;
        private bool _completed;

        public ASignalAwaiter(ASignal signal) => _signal = signal;
        public bool IsCompleted => _completed;
        public void GetResult() {}
        public void OnCompleted(Action continuation)
        {
            _signal.Once(() =>
            {
                _completed = true;
                continuation.Invoke();
            }); 
        }
    }
    
    [PublicAPI]
    public class SignalAwaiter<T> : INotifyCompletion
    {
        private ASignal<T> _signal;
        private T _result;
        
        public SignalAwaiter(ASignal<T> signal) => _signal = signal;
        public bool IsCompleted => _result != null;
        public T GetResult() => _result;
        public void OnCompleted(Action continuation)
        {
            _signal.Once(arg =>
            {
                _result = arg;
                continuation.Invoke();
            }); 
        }
    }
    
    [PublicAPI]
    public class SignalAwaiter<T, U> : INotifyCompletion
    {
        private ASignal<T, U> _signal;
        private (T, U) _result;
        private bool _completed;
        
        public SignalAwaiter(ASignal<T, U> signal) => _signal = signal;
        public bool IsCompleted => _completed;
        public (T,U) GetResult() => _result;
        public void OnCompleted(Action continuation)
        {
            _signal.Once((arg1, arg2) =>
            {
                _completed = true;
                _result = (arg1, arg2);
                continuation.Invoke();
            }); 
        }
    }
    
    [PublicAPI]
    public class SignalAwaiter<T, U, V> : INotifyCompletion
    {
        private ASignal<T, U, V> _signal;
        private (T, U, V) _result;
        private bool _completed;
        
        public SignalAwaiter(ASignal<T, U, V> signal) => _signal = signal;
        public bool IsCompleted => _completed;
        public (T, U, V) GetResult() => _result;
        public void OnCompleted(Action continuation)
        {
            _signal.Once((arg1, arg2, arg3) =>
            {
                _completed = true;
                _result = (arg1, arg2, arg3);
                continuation.Invoke();
            }); 
        }
    }
}