using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;

public class FreezeTransform : MonoBehaviour
{
    [SerializeField] private Vector3 _positionValues;
    [SerializeField] private Vector3 _scaleValues;
    [SerializeField] private bool _local;

    
    
    private void LateUpdate()
    {
        Actualize();
    }

    private void OnValidate()
    {
        Actualize();
    }

    [Button("Actialize")]
    private void Actualize()
    {
        if (_local)
            transform.localPosition = GetFrozenVector(transform.localPosition, _positionValues);
        else
            transform.position = GetFrozenVector(transform.position, _positionValues);

        if (_local)
            transform.localScale = GetFrozenVector(transform.localScale, _scaleValues);
        else
        {
            if(transform.lossyScale.Divide(transform.localScale).Have(x=> x < 0.01f))
                return;
            var targetScaleValues = _scaleValues.Divide(transform.lossyScale.Divide(transform.localScale));
            transform.localScale = GetFrozenVector(transform.localScale, targetScaleValues);
        }
    }

    private Vector3 GetFrozenVector(Vector3 targetVector, Vector3 frozenValues)
    {
        Vector3 resultVector = targetVector;
        
        if (Mathf.Abs(frozenValues.x) > 0)
            resultVector.x = frozenValues.x;
        
        if(Mathf.Abs(frozenValues.y) > 0)
            resultVector.y = frozenValues.y;
        
        if(Mathf.Abs(frozenValues.z) > 0)
            resultVector.z = frozenValues.z;
        
        return resultVector;
    }
}
