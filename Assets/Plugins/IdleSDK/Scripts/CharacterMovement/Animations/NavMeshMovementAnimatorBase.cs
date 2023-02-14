using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;

namespace IdleBasesSDK
{
    public abstract class NavMeshMovementAnimatorBase : MonoBehaviour
    {
        [SerializeField] protected NavMeshAgentHandler _moveHandler;
        [SerializeField] protected Animator Animator;

        [SerializeField, ShowIf(nameof(HasAnimator)), AnimatorParam(nameof(Animator))]
        private string _walkingParamRatio;

        [SerializeField] private float _minMoveRatio;
        [SerializeField] private float _maxSpeed;

        [SerializeField] private bool _animateRotation;
        [SerializeField, ShowIf(nameof(_animateRotation))] private float _minDot;
        [SerializeField, ShowIf(nameof(_animateRotation))] private int _rotateLayerIndex;
        [SerializeField, ShowIf(nameof(_animateRotation)), AnimatorParam(nameof(Animator))]
        private string _turnLeftParameter;
        [SerializeField, ShowIf(nameof(_animateRotation)), AnimatorParam(nameof(Animator))]
        private string _turnRightParameter;
        [SerializeField, ShowIf(nameof(_animateRotation)), AnimatorParam(nameof(Animator))]
        private string _stopRotationParameter;
        protected bool HasAnimator => Animator != null;
        

        private void OnEnable()
        {
            _moveHandler.OnStartMove += OnStartMove;
            _moveHandler.OnMove += OnMove;
            _moveHandler.OnStopMove += StopMove;
        }

        private void OnDisable()
        {
            _moveHandler.OnStartMove -= OnStartMove;
            _moveHandler.OnMove -= OnMove;
            _moveHandler.OnStopMove -= StopMove;
        }

        protected virtual void OnMove(Vector3 input)
        {
            ChangeSpeedRatio();
            AnimateRotation();
        }

        protected virtual void OnStartMove()
        {
            ChangeSpeedRatio();
            AnimateRotation();
        }
        
        public void ChangeSpeedRatio()
        {
            if (_moveHandler.Agent.speed <= 0.05f)
            {
                StopMove();
                return;
            }
            float moveRatio = Mathf.Clamp(_moveHandler.Agent.speed / _maxSpeed, _minMoveRatio, 1);
            
            Animator.SetFloat(_walkingParamRatio, moveRatio);
        }

        public void StopMove()
        {
            Animator.SetFloat(_walkingParamRatio, 0);
        }

        private void AnimateRotation()
        {
            Vector3 target = _moveHandler.Agent.SourceAgent.steeringTarget - transform.position;
            Vector3 direction = transform.right;

            float dot = Vector3.Dot(direction, target);

            if (Mathf.Abs(dot) < _minDot)
            {
                StopRotate();
                return;
            }
            
            Animator.SetLayerWeight(_rotateLayerIndex, dot);
            
            if (dot > 0)
                TurnRight();
            else
                TurnLeft();
        }

        private void TurnLeft() => Turn(true);
        private void TurnRight() => Turn(false, true);

        private void StopRotate()
        {
            Turn(false, false, true);
            _moveHandler.Agent.RemoveModifier(this);
        }

        private void Turn(bool left, bool right = false, bool stop = false)
        {
            Animator.SetBool(_turnLeftParameter, left);
            Animator.SetBool(_turnRightParameter, right);
            if(stop)
                Animator.SetTrigger(_stopRotationParameter);
        }
    }
}
