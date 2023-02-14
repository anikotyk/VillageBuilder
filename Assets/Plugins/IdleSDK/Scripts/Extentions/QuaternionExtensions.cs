using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class QuaternionExtensions : MonoBehaviour
{
    public static Quaternion LookAt(Vector3 sourcePoint, Vector3 destinationPoint)
    {
        Vector3 forwardVector = Vector3.Normalize(destinationPoint - sourcePoint);
    
        float dot = Vector3.Dot(Vector3.forward, forwardVector);
    
        if (Mathf.Abs(dot - (-1.0f)) < 0.000001f)
            return new Quaternion(Vector3.up.x, Vector3.up.y, Vector3.up.z, Mathf.PI);
        
        if (Mathf.Abs(dot - (1.0f)) < 0.000001f)
            return Quaternion.identity;

        float rotAngle = Mathf.Acos(dot);
        Vector3 rotateAxis = Vector3.Cross(Vector3.forward, forwardVector);
        rotateAxis = Vector3.Normalize(rotateAxis);
        return CreateFromAxisAngle(rotateAxis, rotAngle);
    }
    
    public static Quaternion CreateFromAxisAngle(Vector3 axis, float angle)
    {
        float halfAngle = angle * 0.5f;
        float s = Mathf.Sin(halfAngle);
        Quaternion q;
        q.x = axis.x * s;
        q.y = axis.y * s;
        q.z = axis.z * s;
        q.w = Mathf.Cos(halfAngle);
        return q;
    }
}
