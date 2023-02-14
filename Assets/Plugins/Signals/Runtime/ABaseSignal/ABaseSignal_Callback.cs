using System;
using System.Collections.Generic;
using System.Linq;
using NepixSignals.Api;
using UnityEngine.Assertions;

namespace NepixSignals
{
    public abstract partial class ABaseSignal<T>
    {
        protected class Callback : ISignalCallback
        {
            private ABaseSignal<T> _signal;
            
            private List<Func<bool>> _whenPredicate;
            private List<Func<bool>> _offWhenEarlyPredicate;
            private List<Func<bool>> _offWhenLatePredicate;

            /// <summary>
            /// Handler method that should be called.
            /// </summary>
            internal T handler { get; private set; }
            
            /// <summary>
            /// Priority of the callback.
            /// The higher value the faster
            /// in the queue handler would be called
            /// </summary>
            public int priority { get; private set; }
            
            /// <summary>
            /// How many times left to call before remove.
            /// Negative value means infinite calls amount.
            /// </summary>
            public int countdown { get; private set; }

            /// <summary>
            /// Ctor
            /// </summary>
            /// <param name="signal"></param>
            /// <param name="handler"></param>
            internal Callback(ABaseSignal<T> signal, T handler)
            {
                Assert.IsNotNull(signal, "Signal can't be null");
                
                _signal = signal;
                this.handler = handler;
                _whenPredicate = null;
                priority = 0;
                countdown = -1;
            }

            /// <summary>
            /// Check if callback added to a signal.
            /// </summary>
            /// <returns></returns>
            public bool IsAddedToSignal() => _signal.Has(this);

            /// <summary>
            /// On again the callback to signal, in case it was off.
            /// Warning: exception could be fired
            /// if signal already has this callback
            /// </summary>
            public void On() => _signal.On(this);

            public void Once() => _signal.Once(this); 

            /// <summary>
            /// Off from signal.
            /// </summary>
            public void Off()
            {
                if (IsAddedToSignal()) _signal.Off(this);
            }

            /// <summary>
            /// Combine of all checkups
            /// </summary>
            /// <returns></returns>
            internal bool CanEmit() => IsAddedToSignal() && IsWhenFulfilled() && IsCountdownFulfilled();

            internal void BeforeTryEmit()
            {
                if (IsOffWhenEarlyFulfilled()) Off();
            }
            
            internal void EmitStart()
            {
                // For future...
            }
            
            internal void EmitEnd()
            {
                // Countdown only for callbacks that greater 0
                // Callbacks with 0 are completed
                // Callbacks with negative value - infinite
                if (countdown > 0) countdown--;
            }
            
            internal void AfterTryEmit()
            {
                if (IsOffWhenLateFulfilled()) Off();
            }
            
            /// <summary>
            /// The handler will be called only when predicate fulfilled.
            /// </summary>
            /// <param name="predicate">When predicate</param>
            /// <returns>Callback</returns>
            public ISignalCallback When(Func<bool> predicate) 
            {
                if (_whenPredicate == null) _whenPredicate = new List<Func<bool>>();
                _whenPredicate.Add(predicate);
                return this;
            }
            
            /// <summary>
            /// A signal will be off when predicate fulfilled.
            /// </summary>
            /// <param name="predicate">When predicate</param>
            /// <param name="late">If true than check predicate after dispatch, otherwise - before.</param>
            /// <returns>Callback</returns>
            public ISignalCallback OffWhen(Func<bool> predicate, bool late = true) 
            {
                if (late)
                {
                    if (_offWhenLatePredicate == null) _offWhenLatePredicate = new List<Func<bool>>();
                    _offWhenLatePredicate.Add(predicate);
                }
                else
                {
                    if (_offWhenEarlyPredicate == null) _offWhenEarlyPredicate = new List<Func<bool>>();
                    _offWhenEarlyPredicate.Add(predicate);
                }

                return this;
            }

            /// <summary>
            /// Set priority of callback.
            /// </summary>
            /// <param name="value"></param>
            /// <returns></returns>
            public ISignalCallback Priority(int value)
            {
                priority = value;
                _signal.Sort();
                return this;
            }

            /// <summary>
            /// Set countdown for callback.
            /// How many times it should be called.
            /// Negative value means infinite calls amount.
            /// </summary>
            /// <param name="value"></param>
            /// <returns></returns>
            public ISignalCallback Countdown(int value)
            {
                countdown = value;
                return this;
            }

            /// <summary>
            /// Check is when predicate fulfilled.
            /// If the predicate is null that fulfilled.
            /// </summary>
            /// <returns>Callback</returns>
            private bool IsWhenFulfilled()
            {
                return _whenPredicate == null || _whenPredicate.All(when => when());
            }

            /// <summary>
            /// Check is off when predicate fulfilled.
            /// </summary>
            /// <returns>Callback</returns>
            private bool IsOffWhenEarlyFulfilled()
            {
                return _offWhenEarlyPredicate != null && _offWhenEarlyPredicate.All(when => when());
            }

            /// <summary>
            /// Check is off when predicate fulfilled.
            /// </summary>
            /// <returns>Callback</returns>
            private bool IsOffWhenLateFulfilled()
            {
                return _offWhenLatePredicate != null && _offWhenLatePredicate.All(when => when());
            }
            
            private bool IsCountdownFulfilled()
            {
                return countdown != 0;
            }
        }
    }
}