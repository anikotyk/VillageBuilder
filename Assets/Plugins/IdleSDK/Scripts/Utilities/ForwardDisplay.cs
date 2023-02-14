using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ForwardDisplay : MonoBehaviour
{
    public Vector3 Forward;

    private void Update()
    {
        Forward = transform.forward;
    }
}
