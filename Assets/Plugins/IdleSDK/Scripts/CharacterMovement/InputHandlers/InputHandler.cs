using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace IdleBasesSDK
{
    public abstract class InputHandler : MovementHandler
    {
        [SerializeField, Range(0, 1)] 
        private float _sensitivity;

        [SerializeField] private bool _maximizeMoveVector;

        private List<object> _blockers = new List<object>();
        private bool _enabledHandle = true;
        private bool _isMoving = false;

        public bool HandleEnabled => _enabledHandle;
        
        private void Update()
        {
            HandleMove();
        }

        private void HandleMove()
        {
            if(_enabledHandle == false)
                return;
            
            var input = GetInput();
            if (Mathf.Abs(input.x) + Mathf.Abs(input.y) + Mathf.Abs(input.z) < _sensitivity)
            {
                if(_isMoving)
                    OnStopMove?.Invoke();
                _isMoving = false;
                return;
            }

            if(_isMoving == false)
                OnStartMove?.Invoke();
            _isMoving = true;

            if (_maximizeMoveVector)
                input = Maximaze(input);
            
            OnMove?.Invoke(input);
        }

        private Vector3 Maximaze(Vector3 input)
        {
            Vector3 maximizedVector = Vector3.zero;
            maximizedVector.x = CalculateAxisInput(input.x, input.z);
            maximizedVector.z = CalculateAxisInput(input.z, input.x);
            return maximizedVector;
        }
        
        
        private float CalculateAxisInput(float axisToCalculate, float secondAxis)
        {
            if (Mathf.Abs(axisToCalculate) <= _sensitivity)
            {
                return 0.0f;
            }
        
            if (Mathf.Abs(axisToCalculate) >= Mathf.Abs(secondAxis))
                return axisToCalculate < 0 ? -1.0f : 1.0f;

            return axisToCalculate / Mathf.Abs(secondAxis);
        }

        public void EnableMaximization() => _maximizeMoveVector = true;
        public void DisableMaximization() => _maximizeMoveVector = false;

        public override void EnableHandle(object sender)
        {
            _blockers.Remove(sender);
            if(_blockers.Count > 0)
                return;
            _enabledHandle = true;
        }

        public override void DisableHandle(object sender)
        { 
            if(_blockers.Contains(sender) == false)
                _blockers.Add(sender);
            _enabledHandle = false; 
        } 
        
    }  
}


