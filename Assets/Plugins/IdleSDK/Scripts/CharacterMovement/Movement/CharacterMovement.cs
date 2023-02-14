using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

namespace IdleBasesSDK
{
    public abstract class CharacterMovement : Movement
    {
        private void OnEnable()
        {
            Handler.OnMove += OnHandledMove;
        }

        private void OnDisable()
        {
            Handler.OnMove -= OnHandledMove;
        }

        private void OnHandledMove(Vector3 input)
        {
            Move(input);
        }
        
        protected abstract void Move(Vector3 input);

    }
}
