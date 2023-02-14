using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;

public class InvertedLight : MonoBehaviour
{
    [SerializeField] private Light _light;
    public Vector4 hackColor;
    public float multiplier = 1;

    private void Awake()
    {
        Actualize();
    }

    private void OnValidate()
    {
        Actualize();
    }

    [Button("Actualize")]
    private void Actualize()
    {
        _light.color = new Color(hackColor.x, hackColor.y, hackColor.z, hackColor.w) * multiplier;
    }
}
