using System;
using UnityEngine;

namespace IdleBasesSDK
{
    public class CharacterControllerMovement : CharacterMovement
    {
        [SerializeField] private CharacterController _characterController;
        [SerializeField] private GameObject _rotationModel;
        [SerializeField] private ModifiedValue<float> _speed;
        [SerializeField] private ModifiedValue<float> _angularSpeed;
        
        private Quaternion _rotationDestination = Quaternion.identity;
        
        protected override float CurrentSpeed => _speed.Value;
        
        public override float ActualSpeed => CurrentSpeed;
        public override bool IsMoving => _characterController.velocity.magnitude > 0.15f;

        public ModifiedValue<float> AngularSpeed => _angularSpeed;
        public ModifiedValue<float> Speed => _speed;
        
        
        private void Update()
        {
            _rotationModel.transform.rotation = Quaternion.Lerp(_rotationModel.transform.rotation, _rotationDestination, _angularSpeed.Value * Time.deltaTime);
        }
        
        protected override void Move(Vector3 input)
        {
            if (_characterController.isGrounded == false)
                input.y -= 1;
            
            Rotate(input);
            float magnitude = input.magnitude;
            float magnitudeCoefficient = magnitude > 1.0f ? magnitude : 1.0f;
            _characterController.Move(input * _speed.Value * Time.deltaTime / magnitudeCoefficient);
        }
    
        private void Rotate(Vector3 move)
        {
            Quaternion rotation = Quaternion.LookRotation(move, Vector3.up);
            var angle = rotation.eulerAngles.y;
            _rotationDestination = Quaternion.Euler(Vector3.up*angle);
        }
    }
}

