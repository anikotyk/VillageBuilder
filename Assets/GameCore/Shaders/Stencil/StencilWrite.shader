Shader "Stencil/Write"
{
    Properties
    {
        _Ref ("", int) = 1
        _ReadMask ("ReadMask", int) = 255
        _WriteMask ("WriteMask", int) = 255
        [Enum(UnityEngine.Rendering.CompareFunction)] _Comp ("Comp", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _Pass ("Pass", Float) = 2
        [Enum(UnityEngine.Rendering.StencilOp)] _Fail ("Fail", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _ZFail ("ZFail", Float) = 0
    }
    
    SubShader
    {
        Tags{"RenderType"="Opaque" "Queue" = "Geometry-1"}
        
        Blend Zero One
        ZWrite Off
        
        Stencil
        {
            Ref [_Ref]
            ReadMask [_ReadMask]
            WriteMask [_WriteMask]
            Comp [_Comp]
            Pass [_Pass]
            Fail [_Fail]
            ZFail [_ZFail]
        }  
        
        Pass
        {            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return 0;
            }
            ENDCG
        }
    }
}
