using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

namespace IdleBasesSDK.Utilities
{
    public class Rotator : MonoBehaviour
    {
        [SerializeField] private Transform _target;
        [SerializeField] private float _rotateSpeed;
        [SerializeField] private Vector3 _rotateAxis;

        private void OnEnable()
        {
        }

        private void OnDisable()
        {
        }

        private void Update()
        {
            _target.rotation *= Quaternion.Euler(_rotateAxis * (_rotateSpeed * Time.deltaTime));
        }
    }
}
