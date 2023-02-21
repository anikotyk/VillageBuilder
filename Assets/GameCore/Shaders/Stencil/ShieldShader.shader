Shader "ShieldShader"
{
    Properties
    {
        [HDR]Color_C5E3E077("Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]Texture2D_2DF130DF("MainTexture", 2D) = "white" {}
        Vector1_EF6659A2("NoiseSpeed", Float) = 5
        Vector1_EABDEC1B("NoiseScale", Float) = 5
        Vector3_F9AA6F6A("VertexOffsetAmount", Vector) = (0, 0, 0, 0)
        [HDR]Color_C37BF70E("FresnelColor", Color) = (1, 1, 1, 1)
        Vector1_11E99660("FresnelPower", Float) = 3
        _View_Direction("View Direction", Vector) = (0, 0, 0, 0)
        _Tiling("Tiling", Vector) = (0, 0, 0, 0)
        _Offset("Offset", Vector) = (0, 0, 0, 0)
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
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
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        
        ZWrite Off
        
        Stencil
        {
            Ref [_Ref]
            Comp [_Comp]
            ReadMask [_ReadMask]
            WriteMask [_WriteMask]
            Pass [_Pass]
            Fail [_Fail]
            ZFail [_ZFail]
        }  
        
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha One, One One
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
             float3 viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyzw =  input.color;
            output.interp4.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.color = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float4 _Property_9314107446fb2084bcc5bbd4ef463b38_Out_0 = Color_C37BF70E;
            float3 _Property_9ecf856d68b94e20881a77ce02f16020_Out_0 = _View_Direction;
            float _Property_77f0d58a42379d82977dfaac354dc583_Out_0 = Vector1_11E99660;
            float _FresnelEffect_dcda58a8edfed68283bf2862e0f65eac_Out_3;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, _Property_9ecf856d68b94e20881a77ce02f16020_Out_0, _Property_77f0d58a42379d82977dfaac354dc583_Out_0, _FresnelEffect_dcda58a8edfed68283bf2862e0f65eac_Out_3);
            float4 _Multiply_a073d40476fb6a8d893e6272eed72ed9_Out_2;
            Unity_Multiply_float4_float4(_Property_9314107446fb2084bcc5bbd4ef463b38_Out_0, (_FresnelEffect_dcda58a8edfed68283bf2862e0f65eac_Out_3.xxxx), _Multiply_a073d40476fb6a8d893e6272eed72ed9_Out_2);
            float4 _Multiply_4dbbdf71eaac72808b120967020b8036_Out_2;
            Unity_Multiply_float4_float4(_Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2, _Multiply_a073d40476fb6a8d893e6272eed72ed9_Out_2, _Multiply_4dbbdf71eaac72808b120967020b8036_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.BaseColor = (_Multiply_4dbbdf71eaac72808b120967020b8036_Out_2.xyz);
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            output.color = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha One, One One
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
             float3 viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyzw =  input.color;
            output.interp4.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.color = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float4 _Property_9314107446fb2084bcc5bbd4ef463b38_Out_0 = Color_C37BF70E;
            float3 _Property_9ecf856d68b94e20881a77ce02f16020_Out_0 = _View_Direction;
            float _Property_77f0d58a42379d82977dfaac354dc583_Out_0 = Vector1_11E99660;
            float _FresnelEffect_dcda58a8edfed68283bf2862e0f65eac_Out_3;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, _Property_9ecf856d68b94e20881a77ce02f16020_Out_0, _Property_77f0d58a42379d82977dfaac354dc583_Out_0, _FresnelEffect_dcda58a8edfed68283bf2862e0f65eac_Out_3);
            float4 _Multiply_a073d40476fb6a8d893e6272eed72ed9_Out_2;
            Unity_Multiply_float4_float4(_Property_9314107446fb2084bcc5bbd4ef463b38_Out_0, (_FresnelEffect_dcda58a8edfed68283bf2862e0f65eac_Out_3.xxxx), _Multiply_a073d40476fb6a8d893e6272eed72ed9_Out_2);
            float4 _Multiply_4dbbdf71eaac72808b120967020b8036_Out_2;
            Unity_Multiply_float4_float4(_Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2, _Multiply_a073d40476fb6a8d893e6272eed72ed9_Out_2, _Multiply_4dbbdf71eaac72808b120967020b8036_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.BaseColor = (_Multiply_4dbbdf71eaac72808b120967020b8036_Out_2.xyz);
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            output.color = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            output.interp1.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            output.color = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv1;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.color = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_C5E3E077;
        float4 Texture2D_2DF130DF_TexelSize;
        float Vector1_EF6659A2;
        float Vector1_EABDEC1B;
        float3 Vector3_F9AA6F6A;
        float4 Color_C37BF70E;
        float Vector1_11E99660;
        float3 _View_Direction;
        float2 _Tiling;
        float2 _Offset;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(Texture2D_2DF130DF);
        SAMPLER(samplerTexture2D_2DF130DF);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_Radians_float(float2 UV, float2 Center, float Rotation, out float2 Out)
        {
            //rotation matrix
            UV -= Center;
            float s = sin(Rotation);
            float c = cos(Rotation);
        
            //center rotation matrix
            float2x2 rMatrix = float2x2(c, -s, s, c);
            rMatrix *= 0.5;
            rMatrix += 0.5;
            rMatrix = rMatrix*2 - 1;
        
            //multiply the UVs by the rotation matrix
            UV.xy = mul(UV.xy, rMatrix);
            UV += Center;
        
            Out = UV;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float4 _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0 = IN.uv1;
            float _Split_f688942831b2488b80b59a1d46c65a61_R_1 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[0];
            float _Split_f688942831b2488b80b59a1d46c65a61_G_2 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[1];
            float _Split_f688942831b2488b80b59a1d46c65a61_B_3 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[2];
            float _Split_f688942831b2488b80b59a1d46c65a61_A_4 = _UV_b86167bb8a2b8f8d9c833324f4f31ecb_Out_0[3];
            float3 _Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0 = float3(_Split_f688942831b2488b80b59a1d46c65a61_R_1, _Split_f688942831b2488b80b59a1d46c65a61_G_2, _Split_f688942831b2488b80b59a1d46c65a61_B_3);
            float _Split_56b015039c75d28080c7a1d5228a649d_R_1 = IN.ObjectSpaceNormal[0];
            float _Split_56b015039c75d28080c7a1d5228a649d_G_2 = IN.ObjectSpaceNormal[1];
            float _Split_56b015039c75d28080c7a1d5228a649d_B_3 = IN.ObjectSpaceNormal[2];
            float _Split_56b015039c75d28080c7a1d5228a649d_A_4 = 0;
            float4 _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4;
            float3 _Combine_db6422999088f888ac1dd360a13fba71_RGB_5;
            float2 _Combine_db6422999088f888ac1dd360a13fba71_RG_6;
            Unity_Combine_float(_Split_56b015039c75d28080c7a1d5228a649d_R_1, _Split_56b015039c75d28080c7a1d5228a649d_G_2, _Split_56b015039c75d28080c7a1d5228a649d_B_3, _Split_56b015039c75d28080c7a1d5228a649d_A_4, _Combine_db6422999088f888ac1dd360a13fba71_RGBA_4, _Combine_db6422999088f888ac1dd360a13fba71_RGB_5, _Combine_db6422999088f888ac1dd360a13fba71_RG_6);
            float _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0 = Vector1_EF6659A2;
            float _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_71ba7e15b379f383956a07e11ccfe57b_Out_0, _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2);
            float2 _Rotate_17595c52e0d08887941715cf9e236ace_Out_3;
            Unity_Rotate_Radians_float(_Combine_db6422999088f888ac1dd360a13fba71_RG_6, float2 (0.5, 0.5), _Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2, _Rotate_17595c52e0d08887941715cf9e236ace_Out_3);
            float2 _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3;
            Unity_TilingAndOffset_float(_Rotate_17595c52e0d08887941715cf9e236ace_Out_3, float2 (1, 1), (_Multiply_27d49d0cfaa5d58e82d668e24b989158_Out_2.xx), _TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3);
            float _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_daac63768c58e88f9fb07bf5e337e9d7_Out_3, 5, _GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2);
            float3 _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_GradientNoise_50cea28bb307b988ad28924390fb28ee_Out_2.xxx), _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2);
            float3 _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2;
            Unity_Multiply_float3_float3(_Vector3_eb9fe690b7cc0089a77290e0561e75e9_Out_0, _Multiply_7b1e489bd7bbef80abb9a20266978219_Out_2, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2);
            float3 _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_8672ed80da813e83a5e91bd9110313b8_Out_2, _Add_b204dc386a375d88a14d0d74eb30de06_Out_2);
            description.Position = _Add_b204dc386a375d88a14d0d74eb30de06_Out_2;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0 = Color_C5E3E077;
            UnityTexture2D _Property_5e80939067fa2a8a8f456579b6205a78_Out_0 = UnityBuildTexture2DStructNoScale(Texture2D_2DF130DF);
            float4 _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0 = SAMPLE_TEXTURE2D(_Property_5e80939067fa2a8a8f456579b6205a78_Out_0.tex, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.samplerstate, _Property_5e80939067fa2a8a8f456579b6205a78_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_R_4 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.r;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_G_5 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.g;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_B_6 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.b;
            float _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_A_7 = _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0.a;
            float4 _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2;
            Unity_Multiply_float4_float4(_Property_98be1b9f6eb5ce81aa06eaedc66d907f_Out_0, _SampleTexture2D_7b38cc896966bf87b1f81f88a830e042_RGBA_0, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2);
            float4 _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2;
            Unity_Multiply_float4_float4(IN.VertexColor, _Multiply_510f48c98047818cb5aeb471018bf6d2_Out_2, _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2);
            float _Split_34a0b468935ef08cacff1c2e35d0024e_R_1 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[0];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_G_2 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[1];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_B_3 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[2];
            float _Split_34a0b468935ef08cacff1c2e35d0024e_A_4 = _Multiply_46ccd873f9eda88992f9389eb1b5f10b_Out_2[3];
            surface.Alpha = _Split_34a0b468935ef08cacff1c2e35d0024e_A_4;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv1 =                                        input.uv1;
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}