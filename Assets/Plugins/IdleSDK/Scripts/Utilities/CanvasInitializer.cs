using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Zenject;

public class CanvasInitializer : MonoBehaviour
{
    [SerializeField] private Canvas _canvas;

    [Inject] private Camera _camera;

    private void Awake()
    {
        _canvas.worldCamera = _camera;
    }
}
