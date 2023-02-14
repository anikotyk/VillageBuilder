using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TransformRandomizer : MonoBehaviour
{
    [SerializeField] private Transform _target;
    [SerializeField] private Vector2 _scaleRange;
    [SerializeField] private Vector3 _rotationAxis;
    [SerializeField] private Vector2 _rotationRange;
    

    private void Awake()
    {
        _target.localScale = _scaleRange.Random() * Vector3.one;
        _target.localRotation = Quaternion.Euler(_rotationRange.Random() * _rotationAxis);
    }
}
