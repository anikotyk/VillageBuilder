using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using BansheeGz.BGSpline.Components;

public static class VectorExtentions
{
    public static bool SameDirection(this Vector3 forwardSource, Vector3 forwardTarget)
    {
        float dot =Vector3.Dot(forwardSource, forwardTarget);
        if(dot <= 0f)
            return false;
        return true;
    }

    public static Vector3 Divide(this Vector3 source, Vector3 divider)
    {
        return new Vector3(DivideVectorValue(source.x, divider.x), DivideVectorValue(source.y, divider.y),
            DivideVectorValue(source.z, divider.z));
    }

    public static bool Have(this Vector3 source, Predicate<float> predicate)
    {
        if (predicate(source.x) || predicate(source.y) || predicate(source.z))
            return true;
        return false;
    }

    private static float DivideVectorValue(float source, float divider)
    {
        if (source == 0 || divider == 0)
            return 0;
        return source / divider;
    }

    public static bool SameDirection(this Transform sourceTransform, Transform targetTransform)
    {
        return SameDirection(sourceTransform.forward, targetTransform.forward);
    }
    public static float Random(this Vector2 vector)
    {
        return UnityEngine.Random.Range(vector.Min(), vector.Max());
    }
    
    public static int Random(this Vector2Int vector)
    {
        return UnityEngine.Random.Range(vector.Min(), vector.Max()+1);
    }

    public static int Min(this Vector2Int vector2)
    {
        if (vector2.x > vector2.y)
            return vector2.y;
        return vector2.x;
    }
    public static float Min(this Vector2 vector2)
    {
        if (vector2.x > vector2.y)
            return vector2.y;
        return vector2.x;
    }
    
    public static int Max(this Vector2Int vector2)
    {
        if (vector2.x < vector2.y)
            return vector2.y;
        return vector2.x;
    }
    public static float Max(this Vector2 vector2)
    {
        if (vector2.x < vector2.y)
            return vector2.y;
        return vector2.x;
    }

    public static Vector2 Abs(this Vector2 vector2)
    {
        return new Vector2(Mathf.Abs(vector2.x), Mathf.Abs(vector2.y));
    }

    public static float Sum(this Vector2 vector2)
    {
        return vector2.x + vector2.y;
    }

    public static Vector2 XZ(this Vector3 vector3)
    {
        return new Vector2(vector3.x, vector3.z);
    }
    
    public static Vector3 XZ(this Vector2 vector3)
    {
        return new Vector3(vector3.x, 0, vector3.y);
    }
    
    public static Vector3 NormalizeInvert(this Vector3 vector3)
    {
        return new Vector3(vector3.x > 0 ? 0 : 1 , vector3.y > 0 ? 0 : 1, vector3.z > 0 ? 0 : 1);
    }


    public static float SqrDistance(Vector3 firstPoint, Vector3 secondPoint)
    {
        Vector3 offset = secondPoint - firstPoint;
        return offset.sqrMagnitude;
    }
    
    public static float SqrDistance(Transform firstPoint, Transform secondPoint)
    {
        Vector3 offset = secondPoint.position - firstPoint.position;
        return offset.sqrMagnitude;
    }
}
