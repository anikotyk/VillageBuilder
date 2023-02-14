using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class MeshExtentions 
{
    public static void ChangeVertexColorBrightness(this Mesh mesh, float brightnessDelta)
    {
        var colors = mesh.colors;
        
        for(int i = 0; i < colors.Length; i++)
        {
            colors[i].r = Mathf.Clamp01(colors[i].r + brightnessDelta);
            colors[i].g = Mathf.Clamp01(colors[i].g + brightnessDelta);
            colors[i].b = Mathf.Clamp01(colors[i].b + brightnessDelta);
        }

        mesh.colors = colors;
    }
}
