using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.AI;

public static class NavMeshExtentions
{
    public static float GetDistance(this NavMeshPath path)
    {
        if (path.corners.Length < 2)
            return 0;
        
        float lengthSoFar = 0.0F;
        for (int i = 1; i < path.corners.Length; i++) {
            lengthSoFar += Vector3.Distance(path.corners[i - 1], path.corners[i]);
        }
        return lengthSoFar;
    }
}
