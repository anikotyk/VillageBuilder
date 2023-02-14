using UnityEngine;
using NaughtyAttributes;

namespace IdleBasesSDK
{
    public class MovementAnimator : MonoBehaviour
    {
        [SerializeField] private Animator _animator;
        [SerializeField] private CharacterMovement _characterMovement;
        [SerializeField] public float _maxSpeed;
        
        [SerializeField, AnimatorParam(nameof(_animator))]
        private string _speedRatioParameter;

        [SerializeField] private float _minMoveRatio = 0.16f;

        private void OnEnable()
        {
            _characterMovement.Handler.OnMove += OnMove;
            _characterMovement.Handler.OnStopMove += OnStopMove;
        }
        
        private void OnDisable()
        {
            _characterMovement.Handler.OnMove -= OnMove;
            _characterMovement.Handler.OnStopMove -= OnStopMove;
        }

        private void OnMove(Vector3 input)
        {
            float maxRatio = _characterMovement.ActualSpeed / _maxSpeed;
            SetRatio(Mathf.Clamp(input.magnitude, _minMoveRatio, maxRatio));
        }

        private void OnStopMove() => SetRatio(0);
        

        private void SetRatio(float ratio)
        {
            _animator.SetFloat(_speedRatioParameter, Mathf.Clamp(ratio, 0, 1));
        }
    }
}

