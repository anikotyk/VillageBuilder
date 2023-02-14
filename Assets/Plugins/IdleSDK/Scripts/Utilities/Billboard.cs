using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using Zenject;

public class Billboard : MonoBehaviour
{
    [SerializeField] private Vector3 _direction = Vector3.forward;
    [SerializeField] private bool _actualizeInUpdate;

    [Inject] private Camera _camera;

    private void Start()
    {
        Actualize();
    }

    private void Update()
    {
        if(_actualizeInUpdate)
            Actualize();
    }

    private void Actualize()
    {
        if (_camera == null)
            return;
        transform.LookAt(transform.position + _camera.transform.rotation * _direction, _camera.transform.rotation * Vector3.up);
    }

    [Button("Actualize")]
    private void EditorActualize()
    {
        if (Camera.main != null)
            transform.LookAt(transform.position + Camera.main.transform.rotation * _direction,
                Camera.main.transform.rotation * Vector3.up);
    }
}
