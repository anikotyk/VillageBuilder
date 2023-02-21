Shader "WaterShader"
{
    Properties
    {
        _Distance("Distance", Float) = 1
        _Water_Tiling_Speed("Fluid Tiling Speed", Float) = 1
        _Ripple_Density("Ripple Density", Float) = 5
        _Ripple_Slimness("Ripple Slimness", Float) = 5
        [HDR]_Ripple_Color("Ripple Color", Color) = (0.2276166, 0.8773585, 0.7542518, 0)
        _Displacement_Multiplier("Displacement Multiplier", Float) = 1
        [HDR]_Deep_Water_Color("Deep Fluid Color", Color) = (0, 0.7137255, 0.8313726, 0)
        [HDR]_Shallow_Water_Color("Shallow Fluid Color", Color) = (0.4941176, 0.9921569, 1, 0)
        _Radial_Shear("Radial Shear", Vector) = (0.5, 0.5, 0, 0)
        _Metallic("Metallic", Range(0, 1)) = 0
        _("Smoothness", Range(0, 1)) = 0.5
        _Normal_Strength("Normal Strength", Range(0, 1)) = 1
        Vector2_CFDAA394("Normal Speed", Vector) = (0.5, 0.01, 0, 0)
        [HDR]_Edge_Color("Edge Color", Color) = (0.5660378, 0.5633678, 0.5633678, 1)
        _Edge_Amount("Edge Amount", Float) = 15
        _Edge_Speed("Edge Speed", Float) = 1
        _Edge_Scale("Edge Scale", Float) = 10
        _Edge_Cutoff("Edge Cutoff", Float) = 4.8
        _Refraction_Speed("Refraction Speed", Range(0, 2)) = 0.7
        _Refraction_Strength("Refraction Strength", Range(0, 0.03)) = 0.0047
        _Refraction_Scale("Refraction Scale", Float) = 87.3
        Vector1_3A4931B2("Caustic Density", Float) = 5
        Vector1_F1E786B1("Caustik Slimness", Float) = 5
        Vector1_A9532B28("Depth", Float) = 1
        _Stencil("Stencil", Int) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _Comp ("Comp", Float) = 8
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        
        Stencil
        {
            Ref [_Stencil]
            Comp [_Comp]
        }
        
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
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
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
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
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
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
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
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
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
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
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float
        {
        float4 ScreenPosition;
        half4 uv0;
        float3 TimeParameters;
        };
        
        void SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(float Vector1_D6A021C1, float Vector1_7F016ED2, float Vector1_593139BD, Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float IN, out float4 Out_1)
        {
        float4 _ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
        float _Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0 = Vector1_D6A021C1;
        float _Property_7641a75fa136178980ef0f71543b4842_Out_0 = Vector1_7F016ED2;
        float _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2;
        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7641a75fa136178980ef0f71543b4842_Out_0, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _Vector2_a4431f26994ba7889cc452d61527c795_Out_0 = float2(_Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0.xx), _Vector2_a4431f26994ba7889cc452d61527c795_Out_0, _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3);
        float _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2;
        Unity_GradientNoise_float(_TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3, 1, _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2);
        float _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3;
        Unity_Remap_float(_GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2, float2 (0, 1), float2 (-1, 1), _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3);
        float _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0 = Vector1_593139BD;
        float _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2;
        Unity_Multiply_float_float(_Remap_6cb2a701b12b968297835aadb1af8d23_Out_3, _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0, _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2);
        float4 _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        Unity_Add_float4(_ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0, (_Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2.xxxx), _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2);
        Out_1 = _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_Depth_26425acd5373460488e4601693660775_float
        {
        float4 ScreenPosition;
        };
        
        void SG_Depth_26425acd5373460488e4601693660775_float(float Vector1_A1A19221, Bindings_Depth_26425acd5373460488e4601693660775_float IN, out float Out_0)
        {
        float _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1;
        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1);
        float4 _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0 = IN.ScreenPosition;
        float _Split_431c5cd2a23e7182953afde936a4f0a8_R_1 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[0];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_G_2 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[1];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_B_3 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[2];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_A_4 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[3];
        float _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2;
        Unity_Subtract_float(_SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1, _Split_431c5cd2a23e7182953afde936a4f0a8_A_4, _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2);
        float _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0 = Vector1_A1A19221;
        float _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2;
        Unity_Divide_float(_Subtract_378f3f64d807428c9214b1ff245c1615_Out_2, _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0, _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2);
        float _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        Unity_Saturate_float(_Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2, _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1);
        Out_0 = _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float4 _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0 = _Ripple_Color;
            float4 _Multiply_efd37e41e298a180aae7170273f98134_Out_2;
            Unity_Multiply_float4_float4((_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2.xxxx), _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0, _Multiply_efd37e41e298a180aae7170273f98134_Out_2);
            float _Property_b2da54079c7c358e8b9ee590868ad868_Out_0 = _Refraction_Scale;
            float _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0 = _Refraction_Speed;
            float _Property_e658d9258101a18989f8d60f4a34a87c_Out_0 = _Refraction_Strength;
            Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float _RefractedUV_2437b98a074d4c3690ffa214ba089bfd;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.ScreenPosition = IN.ScreenPosition;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.uv0 = IN.uv0;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.TimeParameters = IN.TimeParameters;
            float4 _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1;
            SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(_Property_b2da54079c7c358e8b9ee590868ad868_Out_0, _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0, _Property_e658d9258101a18989f8d60f4a34a87c_Out_0, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1);
            float3 _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1;
            Unity_SceneColor_float(_RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1, _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1);
            float4 _Property_d3d71c6de499188899bad2a5c30484fd_Out_0 = _Shallow_Water_Color;
            float4 _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0 = _Deep_Water_Color;
            float _Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0 = _Distance;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_d765df70b51d40f6928ff436f6005c4e;
            _Depth_d765df70b51d40f6928ff436f6005c4e.ScreenPosition = IN.ScreenPosition;
            float _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0, _Depth_d765df70b51d40f6928ff436f6005c4e, _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0);
            float4 _Lerp_f491185183c8e782a72120b241f273a6_Out_3;
            Unity_Lerp_float4(_Property_d3d71c6de499188899bad2a5c30484fd_Out_0, _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0, (_Depth_d765df70b51d40f6928ff436f6005c4e_Out_0.xxxx), _Lerp_f491185183c8e782a72120b241f273a6_Out_3);
            float4 _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0 = _Edge_Color;
            float _Property_914b41f3b6198389a525cf47d0a6644c_Out_0 = _Edge_Amount;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_7044a59df6c84c518575deb57e0a0d87;
            _Depth_7044a59df6c84c518575deb57e0a0d87.ScreenPosition = IN.ScreenPosition;
            float _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_914b41f3b6198389a525cf47d0a6644c_Out_0, _Depth_7044a59df6c84c518575deb57e0a0d87, _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0);
            float _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0 = _Edge_Cutoff;
            float _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2;
            Unity_Multiply_float_float(_Depth_7044a59df6c84c518575deb57e0a0d87_Out_0, _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0, _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2);
            float _Property_375b7da9ae3b6a8982da168b2575178e_Out_0 = _Edge_Scale;
            float _Property_1721828d6fc5608c9268aa0e2126475d_Out_0 = _Edge_Speed;
            float _Multiply_c4e49439b4c290819b17080b35542f45_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_1721828d6fc5608c9268aa0e2126475d_Out_0, _Multiply_c4e49439b4c290819b17080b35542f45_Out_2);
            float2 _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_375b7da9ae3b6a8982da168b2575178e_Out_0.xx), (_Multiply_c4e49439b4c290819b17080b35542f45_Out_2.xx), _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3);
            float _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3, 1, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2);
            float _Step_e655333b01bcb48c9149205bff703255_Out_2;
            Unity_Step_float(_Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2, _Step_e655333b01bcb48c9149205bff703255_Out_2);
            float4 _Property_fae886207afb9388a0700603d53b1a67_Out_0 = _Edge_Color;
            float _Split_309789363bdd5f8290502c29b06d6a6d_R_1 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[0];
            float _Split_309789363bdd5f8290502c29b06d6a6d_G_2 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[1];
            float _Split_309789363bdd5f8290502c29b06d6a6d_B_3 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[2];
            float _Split_309789363bdd5f8290502c29b06d6a6d_A_4 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[3];
            float _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2;
            Unity_Multiply_float_float(_Step_e655333b01bcb48c9149205bff703255_Out_2, _Split_309789363bdd5f8290502c29b06d6a6d_A_4, _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2);
            float4 _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3;
            Unity_Lerp_float4(_Lerp_f491185183c8e782a72120b241f273a6_Out_3, _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0, (_Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2.xxxx), _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3);
            float _Split_f5939beaede5f9818e310a8dd500a731_R_1 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[0];
            float _Split_f5939beaede5f9818e310a8dd500a731_G_2 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[1];
            float _Split_f5939beaede5f9818e310a8dd500a731_B_3 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[2];
            float _Split_f5939beaede5f9818e310a8dd500a731_A_4 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[3];
            float3 _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3;
            Unity_Lerp_float3(_SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1, (_Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3.xyz), (_Split_f5939beaede5f9818e310a8dd500a731_A_4.xxx), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3);
            float3 _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            Unity_Add_float3((_Multiply_efd37e41e298a180aae7170273f98134_Out_2.xyz), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3, _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2);
            float2 _Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0 = Vector2_CFDAA394;
            float2 _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2;
            Unity_Multiply_float2_float2(_Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0, (IN.TimeParameters.x.xx), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2);
            float2 _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2, _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3);
            float _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3, 40, _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1;
            float3x3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2,0.01,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix, _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1);
            float _Property_12f1488766297b8f84fcba9575ef837c_Out_0 = _Normal_Strength;
            float3 _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2;
            Unity_NormalStrength_float(_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1, _Property_12f1488766297b8f84fcba9575ef837c_Out_0, _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1;
            float3x3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2,0.01,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix, _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1);
            float3 _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2;
            Unity_NormalStrength_float((_Property_12f1488766297b8f84fcba9575ef837c_Out_0.xxx), (_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1).x, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2);
            float3 _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            Unity_NormalBlend_float(_NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2, _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2);
            float _Property_97af932ebaae8d8795e67d59640792fb_Out_0 = _Metallic;
            float _Property_b52d5aeca1969188916a21bba68944c9_Out_0 = _;
            surface.BaseColor = _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            surface.NormalTS = _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = _Property_97af932ebaae8d8795e67d59640792fb_Out_0;
            surface.Occlusion = _Property_b52d5aeca1969188916a21bba68944c9_Out_0;
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
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
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
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
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
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
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
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
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
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
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float
        {
        float4 ScreenPosition;
        half4 uv0;
        float3 TimeParameters;
        };
        
        void SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(float Vector1_D6A021C1, float Vector1_7F016ED2, float Vector1_593139BD, Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float IN, out float4 Out_1)
        {
        float4 _ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
        float _Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0 = Vector1_D6A021C1;
        float _Property_7641a75fa136178980ef0f71543b4842_Out_0 = Vector1_7F016ED2;
        float _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2;
        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7641a75fa136178980ef0f71543b4842_Out_0, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _Vector2_a4431f26994ba7889cc452d61527c795_Out_0 = float2(_Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0.xx), _Vector2_a4431f26994ba7889cc452d61527c795_Out_0, _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3);
        float _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2;
        Unity_GradientNoise_float(_TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3, 1, _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2);
        float _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3;
        Unity_Remap_float(_GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2, float2 (0, 1), float2 (-1, 1), _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3);
        float _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0 = Vector1_593139BD;
        float _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2;
        Unity_Multiply_float_float(_Remap_6cb2a701b12b968297835aadb1af8d23_Out_3, _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0, _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2);
        float4 _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        Unity_Add_float4(_ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0, (_Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2.xxxx), _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2);
        Out_1 = _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_Depth_26425acd5373460488e4601693660775_float
        {
        float4 ScreenPosition;
        };
        
        void SG_Depth_26425acd5373460488e4601693660775_float(float Vector1_A1A19221, Bindings_Depth_26425acd5373460488e4601693660775_float IN, out float Out_0)
        {
        float _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1;
        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1);
        float4 _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0 = IN.ScreenPosition;
        float _Split_431c5cd2a23e7182953afde936a4f0a8_R_1 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[0];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_G_2 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[1];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_B_3 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[2];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_A_4 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[3];
        float _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2;
        Unity_Subtract_float(_SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1, _Split_431c5cd2a23e7182953afde936a4f0a8_A_4, _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2);
        float _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0 = Vector1_A1A19221;
        float _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2;
        Unity_Divide_float(_Subtract_378f3f64d807428c9214b1ff245c1615_Out_2, _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0, _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2);
        float _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        Unity_Saturate_float(_Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2, _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1);
        Out_0 = _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float4 _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0 = _Ripple_Color;
            float4 _Multiply_efd37e41e298a180aae7170273f98134_Out_2;
            Unity_Multiply_float4_float4((_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2.xxxx), _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0, _Multiply_efd37e41e298a180aae7170273f98134_Out_2);
            float _Property_b2da54079c7c358e8b9ee590868ad868_Out_0 = _Refraction_Scale;
            float _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0 = _Refraction_Speed;
            float _Property_e658d9258101a18989f8d60f4a34a87c_Out_0 = _Refraction_Strength;
            Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float _RefractedUV_2437b98a074d4c3690ffa214ba089bfd;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.ScreenPosition = IN.ScreenPosition;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.uv0 = IN.uv0;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.TimeParameters = IN.TimeParameters;
            float4 _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1;
            SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(_Property_b2da54079c7c358e8b9ee590868ad868_Out_0, _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0, _Property_e658d9258101a18989f8d60f4a34a87c_Out_0, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1);
            float3 _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1;
            Unity_SceneColor_float(_RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1, _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1);
            float4 _Property_d3d71c6de499188899bad2a5c30484fd_Out_0 = _Shallow_Water_Color;
            float4 _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0 = _Deep_Water_Color;
            float _Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0 = _Distance;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_d765df70b51d40f6928ff436f6005c4e;
            _Depth_d765df70b51d40f6928ff436f6005c4e.ScreenPosition = IN.ScreenPosition;
            float _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0, _Depth_d765df70b51d40f6928ff436f6005c4e, _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0);
            float4 _Lerp_f491185183c8e782a72120b241f273a6_Out_3;
            Unity_Lerp_float4(_Property_d3d71c6de499188899bad2a5c30484fd_Out_0, _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0, (_Depth_d765df70b51d40f6928ff436f6005c4e_Out_0.xxxx), _Lerp_f491185183c8e782a72120b241f273a6_Out_3);
            float4 _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0 = _Edge_Color;
            float _Property_914b41f3b6198389a525cf47d0a6644c_Out_0 = _Edge_Amount;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_7044a59df6c84c518575deb57e0a0d87;
            _Depth_7044a59df6c84c518575deb57e0a0d87.ScreenPosition = IN.ScreenPosition;
            float _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_914b41f3b6198389a525cf47d0a6644c_Out_0, _Depth_7044a59df6c84c518575deb57e0a0d87, _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0);
            float _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0 = _Edge_Cutoff;
            float _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2;
            Unity_Multiply_float_float(_Depth_7044a59df6c84c518575deb57e0a0d87_Out_0, _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0, _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2);
            float _Property_375b7da9ae3b6a8982da168b2575178e_Out_0 = _Edge_Scale;
            float _Property_1721828d6fc5608c9268aa0e2126475d_Out_0 = _Edge_Speed;
            float _Multiply_c4e49439b4c290819b17080b35542f45_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_1721828d6fc5608c9268aa0e2126475d_Out_0, _Multiply_c4e49439b4c290819b17080b35542f45_Out_2);
            float2 _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_375b7da9ae3b6a8982da168b2575178e_Out_0.xx), (_Multiply_c4e49439b4c290819b17080b35542f45_Out_2.xx), _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3);
            float _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3, 1, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2);
            float _Step_e655333b01bcb48c9149205bff703255_Out_2;
            Unity_Step_float(_Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2, _Step_e655333b01bcb48c9149205bff703255_Out_2);
            float4 _Property_fae886207afb9388a0700603d53b1a67_Out_0 = _Edge_Color;
            float _Split_309789363bdd5f8290502c29b06d6a6d_R_1 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[0];
            float _Split_309789363bdd5f8290502c29b06d6a6d_G_2 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[1];
            float _Split_309789363bdd5f8290502c29b06d6a6d_B_3 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[2];
            float _Split_309789363bdd5f8290502c29b06d6a6d_A_4 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[3];
            float _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2;
            Unity_Multiply_float_float(_Step_e655333b01bcb48c9149205bff703255_Out_2, _Split_309789363bdd5f8290502c29b06d6a6d_A_4, _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2);
            float4 _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3;
            Unity_Lerp_float4(_Lerp_f491185183c8e782a72120b241f273a6_Out_3, _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0, (_Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2.xxxx), _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3);
            float _Split_f5939beaede5f9818e310a8dd500a731_R_1 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[0];
            float _Split_f5939beaede5f9818e310a8dd500a731_G_2 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[1];
            float _Split_f5939beaede5f9818e310a8dd500a731_B_3 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[2];
            float _Split_f5939beaede5f9818e310a8dd500a731_A_4 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[3];
            float3 _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3;
            Unity_Lerp_float3(_SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1, (_Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3.xyz), (_Split_f5939beaede5f9818e310a8dd500a731_A_4.xxx), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3);
            float3 _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            Unity_Add_float3((_Multiply_efd37e41e298a180aae7170273f98134_Out_2.xyz), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3, _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2);
            float2 _Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0 = Vector2_CFDAA394;
            float2 _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2;
            Unity_Multiply_float2_float2(_Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0, (IN.TimeParameters.x.xx), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2);
            float2 _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2, _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3);
            float _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3, 40, _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1;
            float3x3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2,0.01,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix, _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1);
            float _Property_12f1488766297b8f84fcba9575ef837c_Out_0 = _Normal_Strength;
            float3 _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2;
            Unity_NormalStrength_float(_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1, _Property_12f1488766297b8f84fcba9575ef837c_Out_0, _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1;
            float3x3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2,0.01,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix, _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1);
            float3 _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2;
            Unity_NormalStrength_float((_Property_12f1488766297b8f84fcba9575ef837c_Out_0.xxx), (_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1).x, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2);
            float3 _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            Unity_NormalBlend_float(_NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2, _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2);
            float _Property_97af932ebaae8d8795e67d59640792fb_Out_0 = _Metallic;
            float _Property_b52d5aeca1969188916a21bba68944c9_Out_0 = _;
            surface.BaseColor = _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            surface.NormalTS = _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = _Property_97af932ebaae8d8795e67d59640792fb_Out_0;
            surface.Occlusion = _Property_b52d5aeca1969188916a21bba68944c9_Out_0;
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
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
        Cull Back
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
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
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
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
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0 = Vector2_CFDAA394;
            float2 _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2;
            Unity_Multiply_float2_float2(_Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0, (IN.TimeParameters.x.xx), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2);
            float2 _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2, _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3);
            float _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3, 40, _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1;
            float3x3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2,0.01,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix, _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1);
            float _Property_12f1488766297b8f84fcba9575ef837c_Out_0 = _Normal_Strength;
            float3 _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2;
            Unity_NormalStrength_float(_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1, _Property_12f1488766297b8f84fcba9575ef837c_Out_0, _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2);
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1;
            float3x3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2,0.01,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix, _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1);
            float3 _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2;
            Unity_NormalStrength_float((_Property_12f1488766297b8f84fcba9575ef837c_Out_0.xxx), (_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1).x, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2);
            float3 _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            Unity_NormalBlend_float(_NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2, _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2);
            surface.NormalTS = _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
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
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
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
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
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
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
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
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float
        {
        float4 ScreenPosition;
        half4 uv0;
        float3 TimeParameters;
        };
        
        void SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(float Vector1_D6A021C1, float Vector1_7F016ED2, float Vector1_593139BD, Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float IN, out float4 Out_1)
        {
        float4 _ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
        float _Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0 = Vector1_D6A021C1;
        float _Property_7641a75fa136178980ef0f71543b4842_Out_0 = Vector1_7F016ED2;
        float _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2;
        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7641a75fa136178980ef0f71543b4842_Out_0, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _Vector2_a4431f26994ba7889cc452d61527c795_Out_0 = float2(_Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0.xx), _Vector2_a4431f26994ba7889cc452d61527c795_Out_0, _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3);
        float _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2;
        Unity_GradientNoise_float(_TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3, 1, _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2);
        float _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3;
        Unity_Remap_float(_GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2, float2 (0, 1), float2 (-1, 1), _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3);
        float _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0 = Vector1_593139BD;
        float _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2;
        Unity_Multiply_float_float(_Remap_6cb2a701b12b968297835aadb1af8d23_Out_3, _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0, _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2);
        float4 _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        Unity_Add_float4(_ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0, (_Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2.xxxx), _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2);
        Out_1 = _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_Depth_26425acd5373460488e4601693660775_float
        {
        float4 ScreenPosition;
        };
        
        void SG_Depth_26425acd5373460488e4601693660775_float(float Vector1_A1A19221, Bindings_Depth_26425acd5373460488e4601693660775_float IN, out float Out_0)
        {
        float _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1;
        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1);
        float4 _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0 = IN.ScreenPosition;
        float _Split_431c5cd2a23e7182953afde936a4f0a8_R_1 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[0];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_G_2 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[1];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_B_3 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[2];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_A_4 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[3];
        float _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2;
        Unity_Subtract_float(_SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1, _Split_431c5cd2a23e7182953afde936a4f0a8_A_4, _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2);
        float _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0 = Vector1_A1A19221;
        float _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2;
        Unity_Divide_float(_Subtract_378f3f64d807428c9214b1ff245c1615_Out_2, _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0, _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2);
        float _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        Unity_Saturate_float(_Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2, _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1);
        Out_0 = _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float4 _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0 = _Ripple_Color;
            float4 _Multiply_efd37e41e298a180aae7170273f98134_Out_2;
            Unity_Multiply_float4_float4((_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2.xxxx), _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0, _Multiply_efd37e41e298a180aae7170273f98134_Out_2);
            float _Property_b2da54079c7c358e8b9ee590868ad868_Out_0 = _Refraction_Scale;
            float _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0 = _Refraction_Speed;
            float _Property_e658d9258101a18989f8d60f4a34a87c_Out_0 = _Refraction_Strength;
            Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float _RefractedUV_2437b98a074d4c3690ffa214ba089bfd;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.ScreenPosition = IN.ScreenPosition;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.uv0 = IN.uv0;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.TimeParameters = IN.TimeParameters;
            float4 _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1;
            SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(_Property_b2da54079c7c358e8b9ee590868ad868_Out_0, _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0, _Property_e658d9258101a18989f8d60f4a34a87c_Out_0, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1);
            float3 _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1;
            Unity_SceneColor_float(_RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1, _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1);
            float4 _Property_d3d71c6de499188899bad2a5c30484fd_Out_0 = _Shallow_Water_Color;
            float4 _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0 = _Deep_Water_Color;
            float _Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0 = _Distance;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_d765df70b51d40f6928ff436f6005c4e;
            _Depth_d765df70b51d40f6928ff436f6005c4e.ScreenPosition = IN.ScreenPosition;
            float _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0, _Depth_d765df70b51d40f6928ff436f6005c4e, _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0);
            float4 _Lerp_f491185183c8e782a72120b241f273a6_Out_3;
            Unity_Lerp_float4(_Property_d3d71c6de499188899bad2a5c30484fd_Out_0, _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0, (_Depth_d765df70b51d40f6928ff436f6005c4e_Out_0.xxxx), _Lerp_f491185183c8e782a72120b241f273a6_Out_3);
            float4 _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0 = _Edge_Color;
            float _Property_914b41f3b6198389a525cf47d0a6644c_Out_0 = _Edge_Amount;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_7044a59df6c84c518575deb57e0a0d87;
            _Depth_7044a59df6c84c518575deb57e0a0d87.ScreenPosition = IN.ScreenPosition;
            float _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_914b41f3b6198389a525cf47d0a6644c_Out_0, _Depth_7044a59df6c84c518575deb57e0a0d87, _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0);
            float _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0 = _Edge_Cutoff;
            float _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2;
            Unity_Multiply_float_float(_Depth_7044a59df6c84c518575deb57e0a0d87_Out_0, _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0, _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2);
            float _Property_375b7da9ae3b6a8982da168b2575178e_Out_0 = _Edge_Scale;
            float _Property_1721828d6fc5608c9268aa0e2126475d_Out_0 = _Edge_Speed;
            float _Multiply_c4e49439b4c290819b17080b35542f45_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_1721828d6fc5608c9268aa0e2126475d_Out_0, _Multiply_c4e49439b4c290819b17080b35542f45_Out_2);
            float2 _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_375b7da9ae3b6a8982da168b2575178e_Out_0.xx), (_Multiply_c4e49439b4c290819b17080b35542f45_Out_2.xx), _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3);
            float _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3, 1, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2);
            float _Step_e655333b01bcb48c9149205bff703255_Out_2;
            Unity_Step_float(_Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2, _Step_e655333b01bcb48c9149205bff703255_Out_2);
            float4 _Property_fae886207afb9388a0700603d53b1a67_Out_0 = _Edge_Color;
            float _Split_309789363bdd5f8290502c29b06d6a6d_R_1 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[0];
            float _Split_309789363bdd5f8290502c29b06d6a6d_G_2 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[1];
            float _Split_309789363bdd5f8290502c29b06d6a6d_B_3 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[2];
            float _Split_309789363bdd5f8290502c29b06d6a6d_A_4 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[3];
            float _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2;
            Unity_Multiply_float_float(_Step_e655333b01bcb48c9149205bff703255_Out_2, _Split_309789363bdd5f8290502c29b06d6a6d_A_4, _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2);
            float4 _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3;
            Unity_Lerp_float4(_Lerp_f491185183c8e782a72120b241f273a6_Out_3, _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0, (_Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2.xxxx), _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3);
            float _Split_f5939beaede5f9818e310a8dd500a731_R_1 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[0];
            float _Split_f5939beaede5f9818e310a8dd500a731_G_2 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[1];
            float _Split_f5939beaede5f9818e310a8dd500a731_B_3 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[2];
            float _Split_f5939beaede5f9818e310a8dd500a731_A_4 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[3];
            float3 _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3;
            Unity_Lerp_float3(_SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1, (_Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3.xyz), (_Split_f5939beaede5f9818e310a8dd500a731_A_4.xxx), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3);
            float3 _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            Unity_Add_float3((_Multiply_efd37e41e298a180aae7170273f98134_Out_2.xyz), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3, _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2);
            surface.BaseColor = _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        Cull Back
        
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
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
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
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
            output.texCoord0 = input.interp1.xyzw;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
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
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float
        {
        float4 ScreenPosition;
        half4 uv0;
        float3 TimeParameters;
        };
        
        void SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(float Vector1_D6A021C1, float Vector1_7F016ED2, float Vector1_593139BD, Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float IN, out float4 Out_1)
        {
        float4 _ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
        float _Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0 = Vector1_D6A021C1;
        float _Property_7641a75fa136178980ef0f71543b4842_Out_0 = Vector1_7F016ED2;
        float _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2;
        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7641a75fa136178980ef0f71543b4842_Out_0, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _Vector2_a4431f26994ba7889cc452d61527c795_Out_0 = float2(_Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0.xx), _Vector2_a4431f26994ba7889cc452d61527c795_Out_0, _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3);
        float _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2;
        Unity_GradientNoise_float(_TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3, 1, _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2);
        float _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3;
        Unity_Remap_float(_GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2, float2 (0, 1), float2 (-1, 1), _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3);
        float _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0 = Vector1_593139BD;
        float _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2;
        Unity_Multiply_float_float(_Remap_6cb2a701b12b968297835aadb1af8d23_Out_3, _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0, _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2);
        float4 _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        Unity_Add_float4(_ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0, (_Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2.xxxx), _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2);
        Out_1 = _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_Depth_26425acd5373460488e4601693660775_float
        {
        float4 ScreenPosition;
        };
        
        void SG_Depth_26425acd5373460488e4601693660775_float(float Vector1_A1A19221, Bindings_Depth_26425acd5373460488e4601693660775_float IN, out float Out_0)
        {
        float _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1;
        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1);
        float4 _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0 = IN.ScreenPosition;
        float _Split_431c5cd2a23e7182953afde936a4f0a8_R_1 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[0];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_G_2 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[1];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_B_3 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[2];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_A_4 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[3];
        float _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2;
        Unity_Subtract_float(_SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1, _Split_431c5cd2a23e7182953afde936a4f0a8_A_4, _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2);
        float _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0 = Vector1_A1A19221;
        float _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2;
        Unity_Divide_float(_Subtract_378f3f64d807428c9214b1ff245c1615_Out_2, _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0, _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2);
        float _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        Unity_Saturate_float(_Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2, _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1);
        Out_0 = _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float4 _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0 = _Ripple_Color;
            float4 _Multiply_efd37e41e298a180aae7170273f98134_Out_2;
            Unity_Multiply_float4_float4((_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2.xxxx), _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0, _Multiply_efd37e41e298a180aae7170273f98134_Out_2);
            float _Property_b2da54079c7c358e8b9ee590868ad868_Out_0 = _Refraction_Scale;
            float _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0 = _Refraction_Speed;
            float _Property_e658d9258101a18989f8d60f4a34a87c_Out_0 = _Refraction_Strength;
            Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float _RefractedUV_2437b98a074d4c3690ffa214ba089bfd;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.ScreenPosition = IN.ScreenPosition;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.uv0 = IN.uv0;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.TimeParameters = IN.TimeParameters;
            float4 _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1;
            SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(_Property_b2da54079c7c358e8b9ee590868ad868_Out_0, _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0, _Property_e658d9258101a18989f8d60f4a34a87c_Out_0, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1);
            float3 _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1;
            Unity_SceneColor_float(_RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1, _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1);
            float4 _Property_d3d71c6de499188899bad2a5c30484fd_Out_0 = _Shallow_Water_Color;
            float4 _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0 = _Deep_Water_Color;
            float _Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0 = _Distance;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_d765df70b51d40f6928ff436f6005c4e;
            _Depth_d765df70b51d40f6928ff436f6005c4e.ScreenPosition = IN.ScreenPosition;
            float _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0, _Depth_d765df70b51d40f6928ff436f6005c4e, _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0);
            float4 _Lerp_f491185183c8e782a72120b241f273a6_Out_3;
            Unity_Lerp_float4(_Property_d3d71c6de499188899bad2a5c30484fd_Out_0, _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0, (_Depth_d765df70b51d40f6928ff436f6005c4e_Out_0.xxxx), _Lerp_f491185183c8e782a72120b241f273a6_Out_3);
            float4 _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0 = _Edge_Color;
            float _Property_914b41f3b6198389a525cf47d0a6644c_Out_0 = _Edge_Amount;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_7044a59df6c84c518575deb57e0a0d87;
            _Depth_7044a59df6c84c518575deb57e0a0d87.ScreenPosition = IN.ScreenPosition;
            float _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_914b41f3b6198389a525cf47d0a6644c_Out_0, _Depth_7044a59df6c84c518575deb57e0a0d87, _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0);
            float _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0 = _Edge_Cutoff;
            float _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2;
            Unity_Multiply_float_float(_Depth_7044a59df6c84c518575deb57e0a0d87_Out_0, _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0, _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2);
            float _Property_375b7da9ae3b6a8982da168b2575178e_Out_0 = _Edge_Scale;
            float _Property_1721828d6fc5608c9268aa0e2126475d_Out_0 = _Edge_Speed;
            float _Multiply_c4e49439b4c290819b17080b35542f45_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_1721828d6fc5608c9268aa0e2126475d_Out_0, _Multiply_c4e49439b4c290819b17080b35542f45_Out_2);
            float2 _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_375b7da9ae3b6a8982da168b2575178e_Out_0.xx), (_Multiply_c4e49439b4c290819b17080b35542f45_Out_2.xx), _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3);
            float _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3, 1, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2);
            float _Step_e655333b01bcb48c9149205bff703255_Out_2;
            Unity_Step_float(_Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2, _Step_e655333b01bcb48c9149205bff703255_Out_2);
            float4 _Property_fae886207afb9388a0700603d53b1a67_Out_0 = _Edge_Color;
            float _Split_309789363bdd5f8290502c29b06d6a6d_R_1 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[0];
            float _Split_309789363bdd5f8290502c29b06d6a6d_G_2 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[1];
            float _Split_309789363bdd5f8290502c29b06d6a6d_B_3 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[2];
            float _Split_309789363bdd5f8290502c29b06d6a6d_A_4 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[3];
            float _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2;
            Unity_Multiply_float_float(_Step_e655333b01bcb48c9149205bff703255_Out_2, _Split_309789363bdd5f8290502c29b06d6a6d_A_4, _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2);
            float4 _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3;
            Unity_Lerp_float4(_Lerp_f491185183c8e782a72120b241f273a6_Out_3, _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0, (_Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2.xxxx), _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3);
            float _Split_f5939beaede5f9818e310a8dd500a731_R_1 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[0];
            float _Split_f5939beaede5f9818e310a8dd500a731_G_2 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[1];
            float _Split_f5939beaede5f9818e310a8dd500a731_B_3 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[2];
            float _Split_f5939beaede5f9818e310a8dd500a731_A_4 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[3];
            float3 _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3;
            Unity_Lerp_float3(_SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1, (_Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3.xyz), (_Split_f5939beaede5f9818e310a8dd500a731_A_4.xxx), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3);
            float3 _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            Unity_Add_float3((_Multiply_efd37e41e298a180aae7170273f98134_Out_2.xyz), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3, _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2);
            surface.BaseColor = _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
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
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
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
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
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
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
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
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
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
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
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
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float
        {
        float4 ScreenPosition;
        half4 uv0;
        float3 TimeParameters;
        };
        
        void SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(float Vector1_D6A021C1, float Vector1_7F016ED2, float Vector1_593139BD, Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float IN, out float4 Out_1)
        {
        float4 _ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
        float _Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0 = Vector1_D6A021C1;
        float _Property_7641a75fa136178980ef0f71543b4842_Out_0 = Vector1_7F016ED2;
        float _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2;
        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7641a75fa136178980ef0f71543b4842_Out_0, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _Vector2_a4431f26994ba7889cc452d61527c795_Out_0 = float2(_Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0.xx), _Vector2_a4431f26994ba7889cc452d61527c795_Out_0, _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3);
        float _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2;
        Unity_GradientNoise_float(_TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3, 1, _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2);
        float _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3;
        Unity_Remap_float(_GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2, float2 (0, 1), float2 (-1, 1), _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3);
        float _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0 = Vector1_593139BD;
        float _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2;
        Unity_Multiply_float_float(_Remap_6cb2a701b12b968297835aadb1af8d23_Out_3, _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0, _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2);
        float4 _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        Unity_Add_float4(_ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0, (_Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2.xxxx), _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2);
        Out_1 = _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_Depth_26425acd5373460488e4601693660775_float
        {
        float4 ScreenPosition;
        };
        
        void SG_Depth_26425acd5373460488e4601693660775_float(float Vector1_A1A19221, Bindings_Depth_26425acd5373460488e4601693660775_float IN, out float Out_0)
        {
        float _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1;
        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1);
        float4 _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0 = IN.ScreenPosition;
        float _Split_431c5cd2a23e7182953afde936a4f0a8_R_1 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[0];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_G_2 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[1];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_B_3 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[2];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_A_4 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[3];
        float _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2;
        Unity_Subtract_float(_SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1, _Split_431c5cd2a23e7182953afde936a4f0a8_A_4, _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2);
        float _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0 = Vector1_A1A19221;
        float _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2;
        Unity_Divide_float(_Subtract_378f3f64d807428c9214b1ff245c1615_Out_2, _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0, _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2);
        float _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        Unity_Saturate_float(_Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2, _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1);
        Out_0 = _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float4 _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0 = _Ripple_Color;
            float4 _Multiply_efd37e41e298a180aae7170273f98134_Out_2;
            Unity_Multiply_float4_float4((_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2.xxxx), _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0, _Multiply_efd37e41e298a180aae7170273f98134_Out_2);
            float _Property_b2da54079c7c358e8b9ee590868ad868_Out_0 = _Refraction_Scale;
            float _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0 = _Refraction_Speed;
            float _Property_e658d9258101a18989f8d60f4a34a87c_Out_0 = _Refraction_Strength;
            Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float _RefractedUV_2437b98a074d4c3690ffa214ba089bfd;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.ScreenPosition = IN.ScreenPosition;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.uv0 = IN.uv0;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.TimeParameters = IN.TimeParameters;
            float4 _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1;
            SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(_Property_b2da54079c7c358e8b9ee590868ad868_Out_0, _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0, _Property_e658d9258101a18989f8d60f4a34a87c_Out_0, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1);
            float3 _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1;
            Unity_SceneColor_float(_RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1, _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1);
            float4 _Property_d3d71c6de499188899bad2a5c30484fd_Out_0 = _Shallow_Water_Color;
            float4 _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0 = _Deep_Water_Color;
            float _Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0 = _Distance;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_d765df70b51d40f6928ff436f6005c4e;
            _Depth_d765df70b51d40f6928ff436f6005c4e.ScreenPosition = IN.ScreenPosition;
            float _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0, _Depth_d765df70b51d40f6928ff436f6005c4e, _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0);
            float4 _Lerp_f491185183c8e782a72120b241f273a6_Out_3;
            Unity_Lerp_float4(_Property_d3d71c6de499188899bad2a5c30484fd_Out_0, _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0, (_Depth_d765df70b51d40f6928ff436f6005c4e_Out_0.xxxx), _Lerp_f491185183c8e782a72120b241f273a6_Out_3);
            float4 _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0 = _Edge_Color;
            float _Property_914b41f3b6198389a525cf47d0a6644c_Out_0 = _Edge_Amount;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_7044a59df6c84c518575deb57e0a0d87;
            _Depth_7044a59df6c84c518575deb57e0a0d87.ScreenPosition = IN.ScreenPosition;
            float _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_914b41f3b6198389a525cf47d0a6644c_Out_0, _Depth_7044a59df6c84c518575deb57e0a0d87, _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0);
            float _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0 = _Edge_Cutoff;
            float _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2;
            Unity_Multiply_float_float(_Depth_7044a59df6c84c518575deb57e0a0d87_Out_0, _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0, _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2);
            float _Property_375b7da9ae3b6a8982da168b2575178e_Out_0 = _Edge_Scale;
            float _Property_1721828d6fc5608c9268aa0e2126475d_Out_0 = _Edge_Speed;
            float _Multiply_c4e49439b4c290819b17080b35542f45_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_1721828d6fc5608c9268aa0e2126475d_Out_0, _Multiply_c4e49439b4c290819b17080b35542f45_Out_2);
            float2 _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_375b7da9ae3b6a8982da168b2575178e_Out_0.xx), (_Multiply_c4e49439b4c290819b17080b35542f45_Out_2.xx), _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3);
            float _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3, 1, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2);
            float _Step_e655333b01bcb48c9149205bff703255_Out_2;
            Unity_Step_float(_Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2, _Step_e655333b01bcb48c9149205bff703255_Out_2);
            float4 _Property_fae886207afb9388a0700603d53b1a67_Out_0 = _Edge_Color;
            float _Split_309789363bdd5f8290502c29b06d6a6d_R_1 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[0];
            float _Split_309789363bdd5f8290502c29b06d6a6d_G_2 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[1];
            float _Split_309789363bdd5f8290502c29b06d6a6d_B_3 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[2];
            float _Split_309789363bdd5f8290502c29b06d6a6d_A_4 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[3];
            float _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2;
            Unity_Multiply_float_float(_Step_e655333b01bcb48c9149205bff703255_Out_2, _Split_309789363bdd5f8290502c29b06d6a6d_A_4, _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2);
            float4 _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3;
            Unity_Lerp_float4(_Lerp_f491185183c8e782a72120b241f273a6_Out_3, _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0, (_Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2.xxxx), _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3);
            float _Split_f5939beaede5f9818e310a8dd500a731_R_1 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[0];
            float _Split_f5939beaede5f9818e310a8dd500a731_G_2 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[1];
            float _Split_f5939beaede5f9818e310a8dd500a731_B_3 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[2];
            float _Split_f5939beaede5f9818e310a8dd500a731_A_4 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[3];
            float3 _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3;
            Unity_Lerp_float3(_SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1, (_Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3.xyz), (_Split_f5939beaede5f9818e310a8dd500a731_A_4.xxx), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3);
            float3 _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            Unity_Add_float3((_Multiply_efd37e41e298a180aae7170273f98134_Out_2.xyz), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3, _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2);
            float2 _Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0 = Vector2_CFDAA394;
            float2 _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2;
            Unity_Multiply_float2_float2(_Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0, (IN.TimeParameters.x.xx), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2);
            float2 _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2, _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3);
            float _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3, 40, _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1;
            float3x3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2,0.01,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix, _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1);
            float _Property_12f1488766297b8f84fcba9575ef837c_Out_0 = _Normal_Strength;
            float3 _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2;
            Unity_NormalStrength_float(_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1, _Property_12f1488766297b8f84fcba9575ef837c_Out_0, _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1;
            float3x3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2,0.01,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix, _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1);
            float3 _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2;
            Unity_NormalStrength_float((_Property_12f1488766297b8f84fcba9575ef837c_Out_0.xxx), (_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1).x, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2);
            float3 _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            Unity_NormalBlend_float(_NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2, _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2);
            float _Property_97af932ebaae8d8795e67d59640792fb_Out_0 = _Metallic;
            float _Property_b52d5aeca1969188916a21bba68944c9_Out_0 = _;
            surface.BaseColor = _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            surface.NormalTS = _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = _Property_97af932ebaae8d8795e67d59640792fb_Out_0;
            surface.Occlusion = _Property_b52d5aeca1969188916a21bba68944c9_Out_0;
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
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
        Cull Back
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
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
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
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
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        
        inline float Unity_SimpleNoise_RandomValue_float (float2 uv)
        {
            float angle = dot(uv, float2(12.9898, 78.233));
            #if defined(SHADER_API_MOBILE) && (defined(SHADER_API_GLES) || defined(SHADER_API_GLES3) || defined(SHADER_API_VULKAN))
                // 'sin()' has bad precision on Mali GPUs for inputs > 10000
                angle = fmod(angle, TWO_PI); // Avoid large inputs to sin()
            #endif
            return frac(sin(angle)*43758.5453);
        }
        
        inline float Unity_SimpleNnoise_Interpolate_float (float a, float b, float t)
        {
            return (1.0-t)*a + (t*b);
        }
        
        
        inline float Unity_SimpleNoise_ValueNoise_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
        
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0 = Unity_SimpleNoise_RandomValue_float(c0);
            float r1 = Unity_SimpleNoise_RandomValue_float(c1);
            float r2 = Unity_SimpleNoise_RandomValue_float(c2);
            float r3 = Unity_SimpleNoise_RandomValue_float(c3);
        
            float bottomOfGrid = Unity_SimpleNnoise_Interpolate_float(r0, r1, f.x);
            float topOfGrid = Unity_SimpleNnoise_Interpolate_float(r2, r3, f.x);
            float t = Unity_SimpleNnoise_Interpolate_float(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        void Unity_SimpleNoise_float(float2 UV, float Scale, out float Out)
        {
            float t = 0.0;
        
            float freq = pow(2.0, float(0));
            float amp = pow(0.5, float(3-0));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            t += Unity_SimpleNoise_ValueNoise_float(float2(UV.x*Scale/freq, UV.y*Scale/freq))*amp;
        
            Out = t;
        }
        
        void Unity_NormalFromHeight_Tangent_float(float In, float Strength, float3 Position, float3x3 TangentMatrix, out float3 Out)
        {
            
                    #if defined(SHADER_STAGE_RAY_TRACING)
                    #error 'Normal From Height' node is not supported in ray tracing, please provide an alternate implementation, relying for instance on the 'Raytracing Quality' keyword
                    #endif
            float3 worldDerivativeX = ddx(Position);
            float3 worldDerivativeY = ddy(Position);
        
            float3 crossX = cross(TangentMatrix[2].xyz, worldDerivativeX);
            float3 crossY = cross(worldDerivativeY, TangentMatrix[2].xyz);
            float d = dot(worldDerivativeX, crossY);
            float sgn = d < 0.0 ? (-1.0f) : 1.0f;
            float surface = sgn / max(0.000000000000001192093f, abs(d));
        
            float dHdx = ddx(In);
            float dHdy = ddy(In);
            float3 surfGrad = surface * (dHdx*crossY + dHdy*crossX);
            Out = SafeNormalize(TangentMatrix[2].xyz - (Strength * surfGrad));
            Out = TransformWorldToTangent(Out, TangentMatrix);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0 = Vector2_CFDAA394;
            float2 _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2;
            Unity_Multiply_float2_float2(_Property_eb2a63cf2f318f8b8dc2156b9216e084_Out_0, (IN.TimeParameters.x.xx), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2);
            float2 _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Multiply_60f87dc9cbd33b8099a2743cf5bfb3d4_Out_2, _TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3);
            float _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2;
            Unity_SimpleNoise_float(_TilingAndOffset_de38aeba73e6dd84b73c67558b12093f_Out_3, 40, _SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1;
            float3x3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_SimpleNoise_f7d4d6ee280766848a01977e84faf122_Out_2,0.01,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Position,_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_TangentMatrix, _NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1);
            float _Property_12f1488766297b8f84fcba9575ef837c_Out_0 = _Normal_Strength;
            float3 _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2;
            Unity_NormalStrength_float(_NormalFromHeight_1a7d31c3bf0f858abbada1427054b18b_Out_1, _Property_12f1488766297b8f84fcba9575ef837c_Out_0, _NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2);
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1;
            float3x3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position = IN.WorldSpacePosition;
            Unity_NormalFromHeight_Tangent_float(_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2,0.01,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Position,_NormalFromHeight_fbb8b27134a429838686354ae758b41c_TangentMatrix, _NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1);
            float3 _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2;
            Unity_NormalStrength_float((_Property_12f1488766297b8f84fcba9575ef837c_Out_0.xxx), (_NormalFromHeight_fbb8b27134a429838686354ae758b41c_Out_1).x, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2);
            float3 _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            Unity_NormalBlend_float(_NormalStrength_9015a9ac697eb78391f9cd5ecba4bd28_Out_2, _NormalStrength_5b93256bdd96018e8718b3095fa55059_Out_2, _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2);
            surface.NormalTS = _NormalBlend_b03b642104abad84a893de7b6d7fd32c_Out_2;
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpacePosition = input.positionWS;
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
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
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
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
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
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
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
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
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
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
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float
        {
        float4 ScreenPosition;
        half4 uv0;
        float3 TimeParameters;
        };
        
        void SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(float Vector1_D6A021C1, float Vector1_7F016ED2, float Vector1_593139BD, Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float IN, out float4 Out_1)
        {
        float4 _ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
        float _Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0 = Vector1_D6A021C1;
        float _Property_7641a75fa136178980ef0f71543b4842_Out_0 = Vector1_7F016ED2;
        float _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2;
        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7641a75fa136178980ef0f71543b4842_Out_0, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _Vector2_a4431f26994ba7889cc452d61527c795_Out_0 = float2(_Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0.xx), _Vector2_a4431f26994ba7889cc452d61527c795_Out_0, _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3);
        float _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2;
        Unity_GradientNoise_float(_TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3, 1, _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2);
        float _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3;
        Unity_Remap_float(_GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2, float2 (0, 1), float2 (-1, 1), _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3);
        float _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0 = Vector1_593139BD;
        float _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2;
        Unity_Multiply_float_float(_Remap_6cb2a701b12b968297835aadb1af8d23_Out_3, _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0, _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2);
        float4 _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        Unity_Add_float4(_ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0, (_Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2.xxxx), _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2);
        Out_1 = _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_Depth_26425acd5373460488e4601693660775_float
        {
        float4 ScreenPosition;
        };
        
        void SG_Depth_26425acd5373460488e4601693660775_float(float Vector1_A1A19221, Bindings_Depth_26425acd5373460488e4601693660775_float IN, out float Out_0)
        {
        float _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1;
        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1);
        float4 _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0 = IN.ScreenPosition;
        float _Split_431c5cd2a23e7182953afde936a4f0a8_R_1 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[0];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_G_2 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[1];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_B_3 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[2];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_A_4 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[3];
        float _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2;
        Unity_Subtract_float(_SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1, _Split_431c5cd2a23e7182953afde936a4f0a8_A_4, _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2);
        float _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0 = Vector1_A1A19221;
        float _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2;
        Unity_Divide_float(_Subtract_378f3f64d807428c9214b1ff245c1615_Out_2, _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0, _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2);
        float _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        Unity_Saturate_float(_Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2, _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1);
        Out_0 = _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float4 _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0 = _Ripple_Color;
            float4 _Multiply_efd37e41e298a180aae7170273f98134_Out_2;
            Unity_Multiply_float4_float4((_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2.xxxx), _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0, _Multiply_efd37e41e298a180aae7170273f98134_Out_2);
            float _Property_b2da54079c7c358e8b9ee590868ad868_Out_0 = _Refraction_Scale;
            float _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0 = _Refraction_Speed;
            float _Property_e658d9258101a18989f8d60f4a34a87c_Out_0 = _Refraction_Strength;
            Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float _RefractedUV_2437b98a074d4c3690ffa214ba089bfd;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.ScreenPosition = IN.ScreenPosition;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.uv0 = IN.uv0;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.TimeParameters = IN.TimeParameters;
            float4 _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1;
            SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(_Property_b2da54079c7c358e8b9ee590868ad868_Out_0, _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0, _Property_e658d9258101a18989f8d60f4a34a87c_Out_0, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1);
            float3 _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1;
            Unity_SceneColor_float(_RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1, _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1);
            float4 _Property_d3d71c6de499188899bad2a5c30484fd_Out_0 = _Shallow_Water_Color;
            float4 _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0 = _Deep_Water_Color;
            float _Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0 = _Distance;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_d765df70b51d40f6928ff436f6005c4e;
            _Depth_d765df70b51d40f6928ff436f6005c4e.ScreenPosition = IN.ScreenPosition;
            float _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0, _Depth_d765df70b51d40f6928ff436f6005c4e, _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0);
            float4 _Lerp_f491185183c8e782a72120b241f273a6_Out_3;
            Unity_Lerp_float4(_Property_d3d71c6de499188899bad2a5c30484fd_Out_0, _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0, (_Depth_d765df70b51d40f6928ff436f6005c4e_Out_0.xxxx), _Lerp_f491185183c8e782a72120b241f273a6_Out_3);
            float4 _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0 = _Edge_Color;
            float _Property_914b41f3b6198389a525cf47d0a6644c_Out_0 = _Edge_Amount;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_7044a59df6c84c518575deb57e0a0d87;
            _Depth_7044a59df6c84c518575deb57e0a0d87.ScreenPosition = IN.ScreenPosition;
            float _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_914b41f3b6198389a525cf47d0a6644c_Out_0, _Depth_7044a59df6c84c518575deb57e0a0d87, _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0);
            float _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0 = _Edge_Cutoff;
            float _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2;
            Unity_Multiply_float_float(_Depth_7044a59df6c84c518575deb57e0a0d87_Out_0, _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0, _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2);
            float _Property_375b7da9ae3b6a8982da168b2575178e_Out_0 = _Edge_Scale;
            float _Property_1721828d6fc5608c9268aa0e2126475d_Out_0 = _Edge_Speed;
            float _Multiply_c4e49439b4c290819b17080b35542f45_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_1721828d6fc5608c9268aa0e2126475d_Out_0, _Multiply_c4e49439b4c290819b17080b35542f45_Out_2);
            float2 _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_375b7da9ae3b6a8982da168b2575178e_Out_0.xx), (_Multiply_c4e49439b4c290819b17080b35542f45_Out_2.xx), _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3);
            float _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3, 1, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2);
            float _Step_e655333b01bcb48c9149205bff703255_Out_2;
            Unity_Step_float(_Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2, _Step_e655333b01bcb48c9149205bff703255_Out_2);
            float4 _Property_fae886207afb9388a0700603d53b1a67_Out_0 = _Edge_Color;
            float _Split_309789363bdd5f8290502c29b06d6a6d_R_1 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[0];
            float _Split_309789363bdd5f8290502c29b06d6a6d_G_2 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[1];
            float _Split_309789363bdd5f8290502c29b06d6a6d_B_3 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[2];
            float _Split_309789363bdd5f8290502c29b06d6a6d_A_4 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[3];
            float _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2;
            Unity_Multiply_float_float(_Step_e655333b01bcb48c9149205bff703255_Out_2, _Split_309789363bdd5f8290502c29b06d6a6d_A_4, _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2);
            float4 _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3;
            Unity_Lerp_float4(_Lerp_f491185183c8e782a72120b241f273a6_Out_3, _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0, (_Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2.xxxx), _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3);
            float _Split_f5939beaede5f9818e310a8dd500a731_R_1 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[0];
            float _Split_f5939beaede5f9818e310a8dd500a731_G_2 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[1];
            float _Split_f5939beaede5f9818e310a8dd500a731_B_3 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[2];
            float _Split_f5939beaede5f9818e310a8dd500a731_A_4 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[3];
            float3 _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3;
            Unity_Lerp_float3(_SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1, (_Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3.xyz), (_Split_f5939beaede5f9818e310a8dd500a731_A_4.xxx), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3);
            float3 _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            Unity_Add_float3((_Multiply_efd37e41e298a180aae7170273f98134_Out_2.xyz), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3, _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2);
            surface.BaseColor = _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        Cull Back
        
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
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        #define REQUIRE_OPAQUE_TEXTURE
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
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
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
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
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
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
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
            output.texCoord0 = input.interp1.xyzw;
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
        float _Distance;
        float _Water_Tiling_Speed;
        float _Ripple_Density;
        float _Ripple_Slimness;
        float4 _Ripple_Color;
        float _Displacement_Multiplier;
        float4 _Deep_Water_Color;
        float4 _Shallow_Water_Color;
        float2 _Radial_Shear;
        float _Metallic;
        float _;
        float _Normal_Strength;
        float2 Vector2_CFDAA394;
        float4 _Edge_Color;
        float _Edge_Amount;
        float _Edge_Speed;
        float _Edge_Scale;
        float _Edge_Cutoff;
        float _Refraction_Speed;
        float _Refraction_Strength;
        float _Refraction_Scale;
        float Vector1_3A4931B2;
        float Vector1_F1E786B1;
        float Vector1_A9532B28;
        CBUFFER_END
        
        // Object and Global properties
        
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
        
        void Unity_RadialShear_float(float2 UV, float2 Center, float2 Strength, float2 Offset, out float2 Out)
        {
            float2 delta = UV - Center;
            float delta2 = dot(delta.xy, delta.xy);
            float2 delta_offset = delta2 * Strength;
            Out = UV + float2(delta.y, -delta.x) * delta_offset + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        
        inline float2 Unity_Voronoi_RandomVector_float (float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)));
            return float2(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5);
        }
        
        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
        
            for(int y=-1; y<=1; y++)
            {
                for(int x=-1; x<=1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
        
                    if(d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
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
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float
        {
        float4 ScreenPosition;
        half4 uv0;
        float3 TimeParameters;
        };
        
        void SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(float Vector1_D6A021C1, float Vector1_7F016ED2, float Vector1_593139BD, Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float IN, out float4 Out_1)
        {
        float4 _ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
        float _Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0 = Vector1_D6A021C1;
        float _Property_7641a75fa136178980ef0f71543b4842_Out_0 = Vector1_7F016ED2;
        float _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2;
        Unity_Multiply_float_float(IN.TimeParameters.x, _Property_7641a75fa136178980ef0f71543b4842_Out_0, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _Vector2_a4431f26994ba7889cc452d61527c795_Out_0 = float2(_Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2, _Multiply_77a30736027be2899e5bfde8a176bd4a_Out_2);
        float2 _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3;
        Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_bf9ec0518baffe8f80e9680d915a6dc4_Out_0.xx), _Vector2_a4431f26994ba7889cc452d61527c795_Out_0, _TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3);
        float _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2;
        Unity_GradientNoise_float(_TilingAndOffset_2e443f024520cd8dbedea1d34e86245f_Out_3, 1, _GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2);
        float _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3;
        Unity_Remap_float(_GradientNoise_e4ea147069e27e8787d890fdf9fa5c97_Out_2, float2 (0, 1), float2 (-1, 1), _Remap_6cb2a701b12b968297835aadb1af8d23_Out_3);
        float _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0 = Vector1_593139BD;
        float _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2;
        Unity_Multiply_float_float(_Remap_6cb2a701b12b968297835aadb1af8d23_Out_3, _Property_411e68f9a8bb728dabaf4eaeb773f4d8_Out_0, _Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2);
        float4 _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        Unity_Add_float4(_ScreenPosition_6ebca4cfef93588a8099700070295cc1_Out_0, (_Multiply_5dcb3115d205e68bacfd81fb1f471954_Out_2.xxxx), _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2);
        Out_1 = _Add_d90b71e6cfd1bc87930917457243d1b5_Out_2;
        }
        
        void Unity_SceneColor_float(float4 UV, out float3 Out)
        {
            Out = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV.xy);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        struct Bindings_Depth_26425acd5373460488e4601693660775_float
        {
        float4 ScreenPosition;
        };
        
        void SG_Depth_26425acd5373460488e4601693660775_float(float Vector1_A1A19221, Bindings_Depth_26425acd5373460488e4601693660775_float IN, out float Out_0)
        {
        float _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1;
        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1);
        float4 _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0 = IN.ScreenPosition;
        float _Split_431c5cd2a23e7182953afde936a4f0a8_R_1 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[0];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_G_2 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[1];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_B_3 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[2];
        float _Split_431c5cd2a23e7182953afde936a4f0a8_A_4 = _ScreenPosition_b22ae75a8a711385b46b369d1e18f8e0_Out_0[3];
        float _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2;
        Unity_Subtract_float(_SceneDepth_4dbd1181a03d5488bbdd3124f8db8f3e_Out_1, _Split_431c5cd2a23e7182953afde936a4f0a8_A_4, _Subtract_378f3f64d807428c9214b1ff245c1615_Out_2);
        float _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0 = Vector1_A1A19221;
        float _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2;
        Unity_Divide_float(_Subtract_378f3f64d807428c9214b1ff245c1615_Out_2, _Property_e2c7a58660028188a149e68ccbfd38ef_Out_0, _Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2);
        float _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        Unity_Saturate_float(_Divide_6d7d679d22e5fb8a8039c8568c6859d7_Out_2, _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1);
        Out_0 = _Saturate_9e4cbb017d17168fadcdd5793bd085b8_Out_1;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
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
            float _Split_5f33f21fce29268ea098c3eaadb612f6_R_1 = IN.ObjectSpacePosition[0];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_G_2 = IN.ObjectSpacePosition[1];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_B_3 = IN.ObjectSpacePosition[2];
            float _Split_5f33f21fce29268ea098c3eaadb612f6_A_4 = 0;
            float _Property_44496037cfe12084858dade4f666b55b_Out_0 = _Displacement_Multiplier;
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2;
            Unity_Multiply_float_float(_Property_44496037cfe12084858dade4f666b55b_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2);
            float4 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4;
            float3 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5;
            float2 _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6;
            Unity_Combine_float(_Split_5f33f21fce29268ea098c3eaadb612f6_R_1, _Multiply_5ae1514ec4b34580844a36289498e3c2_Out_2, _Split_5f33f21fce29268ea098c3eaadb612f6_B_3, 0, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RGB_5, _Combine_1d838225541d5789bf8c79f5f3a23bd3_RG_6);
            description.Position = (_Combine_1d838225541d5789bf8c79f5f3a23bd3_RGBA_4.xyz);
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
            float2 _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0 = _Radial_Shear;
            float2 _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4;
            Unity_RadialShear_float(IN.uv0.xy, float2 (0.5, 0.5), _Property_c19bb67d630a9b87bfb6aa3ca41d5a88_Out_0, float2 (0, 0), _RadialShear_2a9990abf1284686a94b3ade26400422_Out_4);
            float _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0 = _Water_Tiling_Speed;
            float _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_f8a9c09653e78683b41b8ecd85444bd2_Out_0, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2);
            float _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0 = _Ripple_Density;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3;
            float _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4;
            Unity_Voronoi_float(_RadialShear_2a9990abf1284686a94b3ade26400422_Out_4, _Multiply_8fc030b0945ebd83b3c65972cbd4b5f1_Out_2, _Property_b1fb952a15147d88b63d5ef3cd988a0e_Out_0, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Voronoi_c9e24fedd6b4128c825424ad65f5a403_Cells_4);
            float _Property_641cefb6adc913888d480b2aff91e086_Out_0 = _Ripple_Slimness;
            float _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2;
            Unity_Power_float(_Voronoi_c9e24fedd6b4128c825424ad65f5a403_Out_3, _Property_641cefb6adc913888d480b2aff91e086_Out_0, _Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2);
            float4 _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0 = _Ripple_Color;
            float4 _Multiply_efd37e41e298a180aae7170273f98134_Out_2;
            Unity_Multiply_float4_float4((_Power_bb8208f487a60b89bc0dde9e01de0b05_Out_2.xxxx), _Property_199edb1a0c2d3687a8e34ccffae81298_Out_0, _Multiply_efd37e41e298a180aae7170273f98134_Out_2);
            float _Property_b2da54079c7c358e8b9ee590868ad868_Out_0 = _Refraction_Scale;
            float _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0 = _Refraction_Speed;
            float _Property_e658d9258101a18989f8d60f4a34a87c_Out_0 = _Refraction_Strength;
            Bindings_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float _RefractedUV_2437b98a074d4c3690ffa214ba089bfd;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.ScreenPosition = IN.ScreenPosition;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.uv0 = IN.uv0;
            _RefractedUV_2437b98a074d4c3690ffa214ba089bfd.TimeParameters = IN.TimeParameters;
            float4 _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1;
            SG_RefractedUV_cbff7a1a9a3c7fb408ec895a1e675faf_float(_Property_b2da54079c7c358e8b9ee590868ad868_Out_0, _Property_a4c78d2363fd6c829a3c9d08fb50e30f_Out_0, _Property_e658d9258101a18989f8d60f4a34a87c_Out_0, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd, _RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1);
            float3 _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1;
            Unity_SceneColor_float(_RefractedUV_2437b98a074d4c3690ffa214ba089bfd_Out_1, _SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1);
            float4 _Property_d3d71c6de499188899bad2a5c30484fd_Out_0 = _Shallow_Water_Color;
            float4 _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0 = _Deep_Water_Color;
            float _Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0 = _Distance;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_d765df70b51d40f6928ff436f6005c4e;
            _Depth_d765df70b51d40f6928ff436f6005c4e.ScreenPosition = IN.ScreenPosition;
            float _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_7dcdbf421885df8b86404d5cc10a9b3b_Out_0, _Depth_d765df70b51d40f6928ff436f6005c4e, _Depth_d765df70b51d40f6928ff436f6005c4e_Out_0);
            float4 _Lerp_f491185183c8e782a72120b241f273a6_Out_3;
            Unity_Lerp_float4(_Property_d3d71c6de499188899bad2a5c30484fd_Out_0, _Property_05f960249d607b8f8acc1b16d4e4c29a_Out_0, (_Depth_d765df70b51d40f6928ff436f6005c4e_Out_0.xxxx), _Lerp_f491185183c8e782a72120b241f273a6_Out_3);
            float4 _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0 = _Edge_Color;
            float _Property_914b41f3b6198389a525cf47d0a6644c_Out_0 = _Edge_Amount;
            Bindings_Depth_26425acd5373460488e4601693660775_float _Depth_7044a59df6c84c518575deb57e0a0d87;
            _Depth_7044a59df6c84c518575deb57e0a0d87.ScreenPosition = IN.ScreenPosition;
            float _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0;
            SG_Depth_26425acd5373460488e4601693660775_float(_Property_914b41f3b6198389a525cf47d0a6644c_Out_0, _Depth_7044a59df6c84c518575deb57e0a0d87, _Depth_7044a59df6c84c518575deb57e0a0d87_Out_0);
            float _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0 = _Edge_Cutoff;
            float _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2;
            Unity_Multiply_float_float(_Depth_7044a59df6c84c518575deb57e0a0d87_Out_0, _Property_2245c1d56af3538594c74d3b2fa04e22_Out_0, _Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2);
            float _Property_375b7da9ae3b6a8982da168b2575178e_Out_0 = _Edge_Scale;
            float _Property_1721828d6fc5608c9268aa0e2126475d_Out_0 = _Edge_Speed;
            float _Multiply_c4e49439b4c290819b17080b35542f45_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_1721828d6fc5608c9268aa0e2126475d_Out_0, _Multiply_c4e49439b4c290819b17080b35542f45_Out_2);
            float2 _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, (_Property_375b7da9ae3b6a8982da168b2575178e_Out_0.xx), (_Multiply_c4e49439b4c290819b17080b35542f45_Out_2.xx), _TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3);
            float _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_b15c834184095c8691abff5fc87d7242_Out_3, 1, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2);
            float _Step_e655333b01bcb48c9149205bff703255_Out_2;
            Unity_Step_float(_Multiply_07add27787e3f88dbc858ad4eec74fd4_Out_2, _GradientNoise_615703f091143b8dbe9ac734484a4726_Out_2, _Step_e655333b01bcb48c9149205bff703255_Out_2);
            float4 _Property_fae886207afb9388a0700603d53b1a67_Out_0 = _Edge_Color;
            float _Split_309789363bdd5f8290502c29b06d6a6d_R_1 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[0];
            float _Split_309789363bdd5f8290502c29b06d6a6d_G_2 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[1];
            float _Split_309789363bdd5f8290502c29b06d6a6d_B_3 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[2];
            float _Split_309789363bdd5f8290502c29b06d6a6d_A_4 = _Property_fae886207afb9388a0700603d53b1a67_Out_0[3];
            float _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2;
            Unity_Multiply_float_float(_Step_e655333b01bcb48c9149205bff703255_Out_2, _Split_309789363bdd5f8290502c29b06d6a6d_A_4, _Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2);
            float4 _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3;
            Unity_Lerp_float4(_Lerp_f491185183c8e782a72120b241f273a6_Out_3, _Property_7d9af3f687a1178ca3955b0c196d7876_Out_0, (_Multiply_586f2b9a7be70481abe4b69d79770f60_Out_2.xxxx), _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3);
            float _Split_f5939beaede5f9818e310a8dd500a731_R_1 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[0];
            float _Split_f5939beaede5f9818e310a8dd500a731_G_2 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[1];
            float _Split_f5939beaede5f9818e310a8dd500a731_B_3 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[2];
            float _Split_f5939beaede5f9818e310a8dd500a731_A_4 = _Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3[3];
            float3 _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3;
            Unity_Lerp_float3(_SceneColor_5818ffe9c7035b8c95a8bf7a7e9cb319_Out_1, (_Lerp_cdd23b6be8f8cd8db365b76481bf3967_Out_3.xyz), (_Split_f5939beaede5f9818e310a8dd500a731_A_4.xxx), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3);
            float3 _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            Unity_Add_float3((_Multiply_efd37e41e298a180aae7170273f98134_Out_2.xyz), _Lerp_699c244c25d23e849b9586ce6c89be19_Out_3, _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2);
            surface.BaseColor = _Add_bbfd2a16e2ae1b8488d01ed5d14aded0_Out_2;
            surface.Alpha = 1;
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
            output.uv0 =                                        input.uv0;
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
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}