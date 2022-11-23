Shader "Custom/Shader_Hp"
{
    Properties
    {
        [NoScaleOffset] _MainTex("_MainTex", 2D) = "white" {}
        Fill("Fill", Float) = 0.38
        BlendFill("BlendFill", Float) = 0.42
        FillColor("FillColor", Color) = (1, 0, 0, 1)
        BlendColor("BlendColor", Color) = (0.9427509, 1, 0, 0.5960785)
        BlankColor("BlankColor", Color) = (0.4433962, 0.4433962, 0.4433962, 0)
        _Angle("Angle", Float) = -90
        _Border("Border", Vector) = (0.1, 0.09, 0, 0)
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 1
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 0
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
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
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Transparent"
            "ShaderGraphShader" = "true"
            "ShaderGraphTargetId" = "UniversalUnlitSubTarget"
            "DisableBatching" = "True"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        Cull[_Cull]
        Blend[_SrcBlend][_DstBlend]
        ZTest[_ZTest]
        ZWrite[_ZWrite]

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
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>

        // Defines

        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
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
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 WorldSpaceTangent;
             float3 ObjectSpaceBiTangent;
             float3 WorldSpaceBiTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float3 interp3 : INTERP3;
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

        PackedVaryings PackVaryings(Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz = input.positionWS;
            output.interp1.xyz = input.normalWS;
            output.interp2.xyzw = input.texCoord0;
            output.interp3.xyz = input.viewDirectionWS;
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

        Varyings UnpackVaryings(PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.viewDirectionWS = input.interp3.xyz;
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
        float4 _MainTex_TexelSize;
        float Fill;
        float BlendFill;
        float4 FillColor;
        float4 BlendColor;
        float4 BlankColor;
        float _Angle;
        float2 _Border;
        CBUFFER_END

            // Object and Global properties
            SAMPLER(SamplerState_Linear_Repeat);
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

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

            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }

            void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
            {
                Out = mul(A, B);
            }

            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }

            void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
            {
                //rotation matrix
                Rotation = Rotation * (3.1415926f / 180.0f);
                UV -= Center;
                float s = sin(Rotation);
                float c = cos(Rotation);

                //center rotation matrix
                float2x2 rMatrix = float2x2(c, -s, s, c);
                rMatrix *= 0.5;
                rMatrix += 0.5;
                rMatrix = rMatrix * 2 - 1;

                //multiply the UVs by the rotation matrix
                UV.xy = mul(UV.xy, rMatrix);
                UV += Center;

                Out = UV;
            }

            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }

            void Unity_Step_float(float Edge, float In, out float Out)
            {
                Out = step(Edge, In);
            }

            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }

            void Unity_Floor_float(float In, out float Out)
            {
                Out = floor(In);
            }

            void Unity_Multiply_float_float(float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }

            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }

            void Unity_Preview_float(float In, out float Out)
            {
                Out = In;
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
                float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                         length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                         length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                float AlphaClipThreshold;
            };

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                surface.BaseColor = (_Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3.xyz);
                surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                surface.AlphaClipThreshold = 0.5;
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

                output.ObjectSpaceNormal = input.normalOS;
                output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent = input.tangentOS.xyz;
                output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                output.ObjectSpacePosition = input.positionOS;

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
                Name "DepthOnly"
                Tags
                {
                    "LightMode" = "DepthOnly"
                }

                // Render State
                Cull[_Cull]
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
                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                // GraphKeywords: <None>

                // Defines

                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_TEXCOORD0
                #define FEATURES_GRAPH_VERTEX
                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                #define SHADERPASS SHADERPASS_DEPTHONLY
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
                     float4 uv0;
                };
                struct VertexDescriptionInputs
                {
                     float3 ObjectSpaceNormal;
                     float3 WorldSpaceNormal;
                     float3 ObjectSpaceTangent;
                     float3 WorldSpaceTangent;
                     float3 ObjectSpaceBiTangent;
                     float3 WorldSpaceBiTangent;
                     float3 ObjectSpacePosition;
                };
                struct PackedVaryings
                {
                     float4 positionCS : SV_POSITION;
                     float4 interp0 : INTERP0;
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

                PackedVaryings PackVaryings(Varyings input)
                {
                    PackedVaryings output;
                    ZERO_INITIALIZE(PackedVaryings, output);
                    output.positionCS = input.positionCS;
                    output.interp0.xyzw = input.texCoord0;
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

                Varyings UnpackVaryings(PackedVaryings input)
                {
                    Varyings output;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp0.xyzw;
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
                float4 _MainTex_TexelSize;
                float Fill;
                float BlendFill;
                float4 FillColor;
                float4 BlendColor;
                float4 BlankColor;
                float _Angle;
                float2 _Border;
                CBUFFER_END

                    // Object and Global properties
                    SAMPLER(SamplerState_Linear_Repeat);
                    TEXTURE2D(_MainTex);
                    SAMPLER(sampler_MainTex);

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

                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                    {
                        Out = mul(A, B);
                    }

                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }

                    void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                    {
                        //rotation matrix
                        Rotation = Rotation * (3.1415926f / 180.0f);
                        UV -= Center;
                        float s = sin(Rotation);
                        float c = cos(Rotation);

                        //center rotation matrix
                        float2x2 rMatrix = float2x2(c, -s, s, c);
                        rMatrix *= 0.5;
                        rMatrix += 0.5;
                        rMatrix = rMatrix * 2 - 1;

                        //multiply the UVs by the rotation matrix
                        UV.xy = mul(UV.xy, rMatrix);
                        UV += Center;

                        Out = UV;
                    }

                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }

                    void Unity_Step_float(float Edge, float In, out float Out)
                    {
                        Out = step(Edge, In);
                    }

                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }

                    void Unity_Floor_float(float In, out float Out)
                    {
                        Out = floor(In);
                    }

                    void Unity_Multiply_float_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }

                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }

                    void Unity_Preview_float(float In, out float Out)
                    {
                        Out = In;
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
                        float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                        Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                        float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                        float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                        float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                        float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                        float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                        float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                        Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                        float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                        Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                        float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                        description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                        float AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                        UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                        float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                        float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                        float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                        Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                        float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                        float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                        Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                        float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                        float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                        float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                        Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                        float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                        float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                        float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                        float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                        float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                        float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                        Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                        float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                        Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                        float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                        Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                        float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                        Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                        float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                        float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                        float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                        float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                        float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                        float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                        float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                        float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                        Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                        float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                        float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                        Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                        float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                        float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                        Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                        float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                        float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                        Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                        float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                        float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                        Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                        float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                        float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                        Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                        float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                        Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                        float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                        float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                        Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                        float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                        float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                        Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                        float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                        Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                        float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                        Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                        float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                        Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                        float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                        Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                        float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                        Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                        float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                        Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                        float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                        float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                        float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                        float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                        float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                        Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                        surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                        surface.AlphaClipThreshold = 0.5;
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

                        output.ObjectSpaceNormal = input.normalOS;
                        output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                        output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                        output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                        output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                        output.ObjectSpacePosition = input.positionOS;

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
                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

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
                        Cull[_Cull]
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
                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                        // GraphKeywords: <None>

                        // Defines

                        #define ATTRIBUTES_NEED_NORMAL
                        #define ATTRIBUTES_NEED_TANGENT
                        #define ATTRIBUTES_NEED_TEXCOORD0
                        #define ATTRIBUTES_NEED_TEXCOORD1
                        #define VARYINGS_NEED_NORMAL_WS
                        #define VARYINGS_NEED_TANGENT_WS
                        #define VARYINGS_NEED_TEXCOORD0
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
                        };
                        struct VertexDescriptionInputs
                        {
                             float3 ObjectSpaceNormal;
                             float3 WorldSpaceNormal;
                             float3 ObjectSpaceTangent;
                             float3 WorldSpaceTangent;
                             float3 ObjectSpaceBiTangent;
                             float3 WorldSpaceBiTangent;
                             float3 ObjectSpacePosition;
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

                        PackedVaryings PackVaryings(Varyings input)
                        {
                            PackedVaryings output;
                            ZERO_INITIALIZE(PackedVaryings, output);
                            output.positionCS = input.positionCS;
                            output.interp0.xyz = input.normalWS;
                            output.interp1.xyzw = input.tangentWS;
                            output.interp2.xyzw = input.texCoord0;
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

                        Varyings UnpackVaryings(PackedVaryings input)
                        {
                            Varyings output;
                            output.positionCS = input.positionCS;
                            output.normalWS = input.interp0.xyz;
                            output.tangentWS = input.interp1.xyzw;
                            output.texCoord0 = input.interp2.xyzw;
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
                        float4 _MainTex_TexelSize;
                        float Fill;
                        float BlendFill;
                        float4 FillColor;
                        float4 BlendColor;
                        float4 BlankColor;
                        float _Angle;
                        float2 _Border;
                        CBUFFER_END

                            // Object and Global properties
                            SAMPLER(SamplerState_Linear_Repeat);
                            TEXTURE2D(_MainTex);
                            SAMPLER(sampler_MainTex);

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

                            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                            {
                                Out = A * B;
                            }

                            void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                            {
                                Out = mul(A, B);
                            }

                            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                            {
                                Out = A + B;
                            }

                            void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                            {
                                //rotation matrix
                                Rotation = Rotation * (3.1415926f / 180.0f);
                                UV -= Center;
                                float s = sin(Rotation);
                                float c = cos(Rotation);

                                //center rotation matrix
                                float2x2 rMatrix = float2x2(c, -s, s, c);
                                rMatrix *= 0.5;
                                rMatrix += 0.5;
                                rMatrix = rMatrix * 2 - 1;

                                //multiply the UVs by the rotation matrix
                                UV.xy = mul(UV.xy, rMatrix);
                                UV += Center;

                                Out = UV;
                            }

                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                            {
                                Out = A * B;
                            }

                            void Unity_Subtract_float(float A, float B, out float Out)
                            {
                                Out = A - B;
                            }

                            void Unity_Step_float(float Edge, float In, out float Out)
                            {
                                Out = step(Edge, In);
                            }

                            void Unity_Saturate_float(float In, out float Out)
                            {
                                Out = saturate(In);
                            }

                            void Unity_Floor_float(float In, out float Out)
                            {
                                Out = floor(In);
                            }

                            void Unity_Multiply_float_float(float A, float B, out float Out)
                            {
                                Out = A * B;
                            }

                            void Unity_Add_float(float A, float B, out float Out)
                            {
                                Out = A + B;
                            }

                            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                            {
                                Out = lerp(A, B, T);
                            }

                            void Unity_Preview_float(float In, out float Out)
                            {
                                Out = In;
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
                                float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                         length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                         length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                float AlphaClipThreshold;
                            };

                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                            {
                                SurfaceDescription surface = (SurfaceDescription)0;
                                float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                surface.AlphaClipThreshold = 0.5;
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

                                output.ObjectSpaceNormal = input.normalOS;
                                output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                output.ObjectSpacePosition = input.positionOS;

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
                                Cull[_Cull]
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
                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                // GraphKeywords: <None>

                                // Defines

                                #define ATTRIBUTES_NEED_NORMAL
                                #define ATTRIBUTES_NEED_TANGENT
                                #define ATTRIBUTES_NEED_TEXCOORD0
                                #define VARYINGS_NEED_NORMAL_WS
                                #define VARYINGS_NEED_TEXCOORD0
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
                                     float4 uv0;
                                };
                                struct VertexDescriptionInputs
                                {
                                     float3 ObjectSpaceNormal;
                                     float3 WorldSpaceNormal;
                                     float3 ObjectSpaceTangent;
                                     float3 WorldSpaceTangent;
                                     float3 ObjectSpaceBiTangent;
                                     float3 WorldSpaceBiTangent;
                                     float3 ObjectSpacePosition;
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

                                PackedVaryings PackVaryings(Varyings input)
                                {
                                    PackedVaryings output;
                                    ZERO_INITIALIZE(PackedVaryings, output);
                                    output.positionCS = input.positionCS;
                                    output.interp0.xyz = input.normalWS;
                                    output.interp1.xyzw = input.texCoord0;
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

                                Varyings UnpackVaryings(PackedVaryings input)
                                {
                                    Varyings output;
                                    output.positionCS = input.positionCS;
                                    output.normalWS = input.interp0.xyz;
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
                                float4 _MainTex_TexelSize;
                                float Fill;
                                float BlendFill;
                                float4 FillColor;
                                float4 BlendColor;
                                float4 BlankColor;
                                float _Angle;
                                float2 _Border;
                                CBUFFER_END

                                    // Object and Global properties
                                    SAMPLER(SamplerState_Linear_Repeat);
                                    TEXTURE2D(_MainTex);
                                    SAMPLER(sampler_MainTex);

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

                                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                    {
                                        Out = A * B;
                                    }

                                    void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                    {
                                        Out = mul(A, B);
                                    }

                                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                    {
                                        Out = A + B;
                                    }

                                    void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                    {
                                        //rotation matrix
                                        Rotation = Rotation * (3.1415926f / 180.0f);
                                        UV -= Center;
                                        float s = sin(Rotation);
                                        float c = cos(Rotation);

                                        //center rotation matrix
                                        float2x2 rMatrix = float2x2(c, -s, s, c);
                                        rMatrix *= 0.5;
                                        rMatrix += 0.5;
                                        rMatrix = rMatrix * 2 - 1;

                                        //multiply the UVs by the rotation matrix
                                        UV.xy = mul(UV.xy, rMatrix);
                                        UV += Center;

                                        Out = UV;
                                    }

                                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                    {
                                        Out = A * B;
                                    }

                                    void Unity_Subtract_float(float A, float B, out float Out)
                                    {
                                        Out = A - B;
                                    }

                                    void Unity_Step_float(float Edge, float In, out float Out)
                                    {
                                        Out = step(Edge, In);
                                    }

                                    void Unity_Saturate_float(float In, out float Out)
                                    {
                                        Out = saturate(In);
                                    }

                                    void Unity_Floor_float(float In, out float Out)
                                    {
                                        Out = floor(In);
                                    }

                                    void Unity_Multiply_float_float(float A, float B, out float Out)
                                    {
                                        Out = A * B;
                                    }

                                    void Unity_Add_float(float A, float B, out float Out)
                                    {
                                        Out = A + B;
                                    }

                                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                    {
                                        Out = lerp(A, B, T);
                                    }

                                    void Unity_Preview_float(float In, out float Out)
                                    {
                                        Out = In;
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
                                        float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                        Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                        float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                        float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                        float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                        float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                        float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                        float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                        Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                        float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                        Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                        float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                        description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                        float AlphaClipThreshold;
                                    };

                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                    {
                                        SurfaceDescription surface = (SurfaceDescription)0;
                                        float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                        UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                        float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                        float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                        float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                        Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                        float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                        float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                        Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                        float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                        float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                        float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                        Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                        float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                        float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                        float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                        float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                        float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                        float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                        Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                        float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                        Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                        float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                        Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                        float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                        Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                        float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                        float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                        float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                        float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                        Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                        float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                        float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                        Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                        float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                        float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                        Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                        float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                        float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                        Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                        float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                        float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                        Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                        float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                        float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                        Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                        float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                        Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                        float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                        float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                        Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                        float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                        float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                        Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                        float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                        Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                        float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                        Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                        float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                        Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                        float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                        Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                        float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                        Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                        float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                        Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                        float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                        float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                        float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                        float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                        float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                        Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                        surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                        surface.AlphaClipThreshold = 0.5;
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

                                        output.ObjectSpaceNormal = input.normalOS;
                                        output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                        output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                        output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                        output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                        output.ObjectSpacePosition = input.positionOS;

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
                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                        // GraphKeywords: <None>

                                        // Defines

                                        #define ATTRIBUTES_NEED_NORMAL
                                        #define ATTRIBUTES_NEED_TANGENT
                                        #define ATTRIBUTES_NEED_TEXCOORD0
                                        #define VARYINGS_NEED_TEXCOORD0
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
                                             float4 uv0;
                                        };
                                        struct VertexDescriptionInputs
                                        {
                                             float3 ObjectSpaceNormal;
                                             float3 WorldSpaceNormal;
                                             float3 ObjectSpaceTangent;
                                             float3 WorldSpaceTangent;
                                             float3 ObjectSpaceBiTangent;
                                             float3 WorldSpaceBiTangent;
                                             float3 ObjectSpacePosition;
                                        };
                                        struct PackedVaryings
                                        {
                                             float4 positionCS : SV_POSITION;
                                             float4 interp0 : INTERP0;
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

                                        PackedVaryings PackVaryings(Varyings input)
                                        {
                                            PackedVaryings output;
                                            ZERO_INITIALIZE(PackedVaryings, output);
                                            output.positionCS = input.positionCS;
                                            output.interp0.xyzw = input.texCoord0;
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

                                        Varyings UnpackVaryings(PackedVaryings input)
                                        {
                                            Varyings output;
                                            output.positionCS = input.positionCS;
                                            output.texCoord0 = input.interp0.xyzw;
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
                                        float4 _MainTex_TexelSize;
                                        float Fill;
                                        float BlendFill;
                                        float4 FillColor;
                                        float4 BlendColor;
                                        float4 BlankColor;
                                        float _Angle;
                                        float2 _Border;
                                        CBUFFER_END

                                            // Object and Global properties
                                            SAMPLER(SamplerState_Linear_Repeat);
                                            TEXTURE2D(_MainTex);
                                            SAMPLER(sampler_MainTex);

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

                                            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                            {
                                                Out = A * B;
                                            }

                                            void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                            {
                                                Out = mul(A, B);
                                            }

                                            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                            {
                                                Out = A + B;
                                            }

                                            void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                            {
                                                //rotation matrix
                                                Rotation = Rotation * (3.1415926f / 180.0f);
                                                UV -= Center;
                                                float s = sin(Rotation);
                                                float c = cos(Rotation);

                                                //center rotation matrix
                                                float2x2 rMatrix = float2x2(c, -s, s, c);
                                                rMatrix *= 0.5;
                                                rMatrix += 0.5;
                                                rMatrix = rMatrix * 2 - 1;

                                                //multiply the UVs by the rotation matrix
                                                UV.xy = mul(UV.xy, rMatrix);
                                                UV += Center;

                                                Out = UV;
                                            }

                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                            {
                                                Out = A * B;
                                            }

                                            void Unity_Subtract_float(float A, float B, out float Out)
                                            {
                                                Out = A - B;
                                            }

                                            void Unity_Step_float(float Edge, float In, out float Out)
                                            {
                                                Out = step(Edge, In);
                                            }

                                            void Unity_Saturate_float(float In, out float Out)
                                            {
                                                Out = saturate(In);
                                            }

                                            void Unity_Floor_float(float In, out float Out)
                                            {
                                                Out = floor(In);
                                            }

                                            void Unity_Multiply_float_float(float A, float B, out float Out)
                                            {
                                                Out = A * B;
                                            }

                                            void Unity_Add_float(float A, float B, out float Out)
                                            {
                                                Out = A + B;
                                            }

                                            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                            {
                                                Out = lerp(A, B, T);
                                            }

                                            void Unity_Preview_float(float In, out float Out)
                                            {
                                                Out = In;
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
                                                float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                         length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                         length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                float AlphaClipThreshold;
                                            };

                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                            {
                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                surface.AlphaClipThreshold = 0.5;
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

                                                output.ObjectSpaceNormal = input.normalOS;
                                                output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                output.ObjectSpacePosition = input.positionOS;

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
                                                Cull[_Cull]

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
                                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                // GraphKeywords: <None>

                                                // Defines

                                                #define ATTRIBUTES_NEED_NORMAL
                                                #define ATTRIBUTES_NEED_TANGENT
                                                #define ATTRIBUTES_NEED_TEXCOORD0
                                                #define VARYINGS_NEED_TEXCOORD0
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
                                                     float4 uv0;
                                                };
                                                struct VertexDescriptionInputs
                                                {
                                                     float3 ObjectSpaceNormal;
                                                     float3 WorldSpaceNormal;
                                                     float3 ObjectSpaceTangent;
                                                     float3 WorldSpaceTangent;
                                                     float3 ObjectSpaceBiTangent;
                                                     float3 WorldSpaceBiTangent;
                                                     float3 ObjectSpacePosition;
                                                };
                                                struct PackedVaryings
                                                {
                                                     float4 positionCS : SV_POSITION;
                                                     float4 interp0 : INTERP0;
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

                                                PackedVaryings PackVaryings(Varyings input)
                                                {
                                                    PackedVaryings output;
                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                    output.positionCS = input.positionCS;
                                                    output.interp0.xyzw = input.texCoord0;
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

                                                Varyings UnpackVaryings(PackedVaryings input)
                                                {
                                                    Varyings output;
                                                    output.positionCS = input.positionCS;
                                                    output.texCoord0 = input.interp0.xyzw;
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
                                                float4 _MainTex_TexelSize;
                                                float Fill;
                                                float BlendFill;
                                                float4 FillColor;
                                                float4 BlendColor;
                                                float4 BlankColor;
                                                float _Angle;
                                                float2 _Border;
                                                CBUFFER_END

                                                    // Object and Global properties
                                                    SAMPLER(SamplerState_Linear_Repeat);
                                                    TEXTURE2D(_MainTex);
                                                    SAMPLER(sampler_MainTex);

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

                                                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                    {
                                                        Out = A * B;
                                                    }

                                                    void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                    {
                                                        Out = mul(A, B);
                                                    }

                                                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                    {
                                                        Out = A + B;
                                                    }

                                                    void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                    {
                                                        //rotation matrix
                                                        Rotation = Rotation * (3.1415926f / 180.0f);
                                                        UV -= Center;
                                                        float s = sin(Rotation);
                                                        float c = cos(Rotation);

                                                        //center rotation matrix
                                                        float2x2 rMatrix = float2x2(c, -s, s, c);
                                                        rMatrix *= 0.5;
                                                        rMatrix += 0.5;
                                                        rMatrix = rMatrix * 2 - 1;

                                                        //multiply the UVs by the rotation matrix
                                                        UV.xy = mul(UV.xy, rMatrix);
                                                        UV += Center;

                                                        Out = UV;
                                                    }

                                                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                    {
                                                        Out = A * B;
                                                    }

                                                    void Unity_Subtract_float(float A, float B, out float Out)
                                                    {
                                                        Out = A - B;
                                                    }

                                                    void Unity_Step_float(float Edge, float In, out float Out)
                                                    {
                                                        Out = step(Edge, In);
                                                    }

                                                    void Unity_Saturate_float(float In, out float Out)
                                                    {
                                                        Out = saturate(In);
                                                    }

                                                    void Unity_Floor_float(float In, out float Out)
                                                    {
                                                        Out = floor(In);
                                                    }

                                                    void Unity_Multiply_float_float(float A, float B, out float Out)
                                                    {
                                                        Out = A * B;
                                                    }

                                                    void Unity_Add_float(float A, float B, out float Out)
                                                    {
                                                        Out = A + B;
                                                    }

                                                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                    {
                                                        Out = lerp(A, B, T);
                                                    }

                                                    void Unity_Preview_float(float In, out float Out)
                                                    {
                                                        Out = In;
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
                                                        float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                        Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                        float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                        float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                        Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                        float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                        Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                        float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                        description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                        float AlphaClipThreshold;
                                                    };

                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                    {
                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                        float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                        UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                        float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                        float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                        float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                        Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                        float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                        float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                        Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                        float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                        float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                        float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                        Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                        float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                        float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                        float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                        float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                        float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                        float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                        Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                        float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                        Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                        float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                        Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                        float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                        Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                        float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                        float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                        float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                        float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                        Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                        float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                        float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                        Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                        float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                        float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                        Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                        float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                        float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                        Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                        float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                        float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                        Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                        float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                        float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                        Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                        float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                        Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                        float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                        float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                        Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                        float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                        float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                        Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                        float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                        Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                        float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                        Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                        float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                        Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                        float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                        Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                        float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                        Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                        float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                        Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                        float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                        float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                        float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                        float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                        float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                        Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                        surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                        surface.AlphaClipThreshold = 0.5;
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

                                                        output.ObjectSpaceNormal = input.normalOS;
                                                        output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                        output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                        output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                        output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                        output.ObjectSpacePosition = input.positionOS;

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
                                                        Cull[_Cull]
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
                                                        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
                                                        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
                                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                        // GraphKeywords: <None>

                                                        // Defines

                                                        #define ATTRIBUTES_NEED_NORMAL
                                                        #define ATTRIBUTES_NEED_TANGENT
                                                        #define ATTRIBUTES_NEED_TEXCOORD0
                                                        #define VARYINGS_NEED_NORMAL_WS
                                                        #define VARYINGS_NEED_TEXCOORD0
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
                                                            #if UNITY_ANY_INSTANCING_ENABLED
                                                             uint instanceID : INSTANCEID_SEMANTIC;
                                                            #endif
                                                        };
                                                        struct Varyings
                                                        {
                                                             float4 positionCS : SV_POSITION;
                                                             float3 normalWS;
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
                                                             float4 uv0;
                                                        };
                                                        struct VertexDescriptionInputs
                                                        {
                                                             float3 ObjectSpaceNormal;
                                                             float3 WorldSpaceNormal;
                                                             float3 ObjectSpaceTangent;
                                                             float3 WorldSpaceTangent;
                                                             float3 ObjectSpaceBiTangent;
                                                             float3 WorldSpaceBiTangent;
                                                             float3 ObjectSpacePosition;
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

                                                        PackedVaryings PackVaryings(Varyings input)
                                                        {
                                                            PackedVaryings output;
                                                            ZERO_INITIALIZE(PackedVaryings, output);
                                                            output.positionCS = input.positionCS;
                                                            output.interp0.xyz = input.normalWS;
                                                            output.interp1.xyzw = input.texCoord0;
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

                                                        Varyings UnpackVaryings(PackedVaryings input)
                                                        {
                                                            Varyings output;
                                                            output.positionCS = input.positionCS;
                                                            output.normalWS = input.interp0.xyz;
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
                                                        float4 _MainTex_TexelSize;
                                                        float Fill;
                                                        float BlendFill;
                                                        float4 FillColor;
                                                        float4 BlendColor;
                                                        float4 BlankColor;
                                                        float _Angle;
                                                        float2 _Border;
                                                        CBUFFER_END

                                                            // Object and Global properties
                                                            SAMPLER(SamplerState_Linear_Repeat);
                                                            TEXTURE2D(_MainTex);
                                                            SAMPLER(sampler_MainTex);

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

                                                            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                            {
                                                                Out = A * B;
                                                            }

                                                            void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                            {
                                                                Out = mul(A, B);
                                                            }

                                                            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                            {
                                                                Out = A + B;
                                                            }

                                                            void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                            {
                                                                //rotation matrix
                                                                Rotation = Rotation * (3.1415926f / 180.0f);
                                                                UV -= Center;
                                                                float s = sin(Rotation);
                                                                float c = cos(Rotation);

                                                                //center rotation matrix
                                                                float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                rMatrix *= 0.5;
                                                                rMatrix += 0.5;
                                                                rMatrix = rMatrix * 2 - 1;

                                                                //multiply the UVs by the rotation matrix
                                                                UV.xy = mul(UV.xy, rMatrix);
                                                                UV += Center;

                                                                Out = UV;
                                                            }

                                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                            {
                                                                Out = A * B;
                                                            }

                                                            void Unity_Subtract_float(float A, float B, out float Out)
                                                            {
                                                                Out = A - B;
                                                            }

                                                            void Unity_Step_float(float Edge, float In, out float Out)
                                                            {
                                                                Out = step(Edge, In);
                                                            }

                                                            void Unity_Saturate_float(float In, out float Out)
                                                            {
                                                                Out = saturate(In);
                                                            }

                                                            void Unity_Floor_float(float In, out float Out)
                                                            {
                                                                Out = floor(In);
                                                            }

                                                            void Unity_Multiply_float_float(float A, float B, out float Out)
                                                            {
                                                                Out = A * B;
                                                            }

                                                            void Unity_Add_float(float A, float B, out float Out)
                                                            {
                                                                Out = A + B;
                                                            }

                                                            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                            {
                                                                Out = lerp(A, B, T);
                                                            }

                                                            void Unity_Preview_float(float In, out float Out)
                                                            {
                                                                Out = In;
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
                                                                float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                         length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                         length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                float AlphaClipThreshold;
                                                            };

                                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                            {
                                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                                float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                surface.AlphaClipThreshold = 0.5;
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

                                                                output.ObjectSpaceNormal = input.normalOS;
                                                                output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                output.ObjectSpacePosition = input.positionOS;

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
                                                                    "RenderPipeline" = "UniversalPipeline"
                                                                    "RenderType" = "Transparent"
                                                                    "UniversalMaterialType" = "Unlit"
                                                                    "Queue" = "Transparent"
                                                                    "ShaderGraphShader" = "true"
                                                                    "ShaderGraphTargetId" = "UniversalUnlitSubTarget"
                                                                }
                                                                Pass
                                                                {
                                                                    Name "Universal Forward"
                                                                    Tags
                                                                    {
                                                                    // LightMode: <None>
                                                                }

                                                                // Render State
                                                                Cull[_Cull]
                                                                Blend[_SrcBlend][_DstBlend]
                                                                ZTest[_ZTest]
                                                                ZWrite[_ZWrite]

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
                                                                #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
                                                                #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
                                                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                // GraphKeywords: <None>

                                                                // Defines

                                                                #define ATTRIBUTES_NEED_NORMAL
                                                                #define ATTRIBUTES_NEED_TANGENT
                                                                #define ATTRIBUTES_NEED_TEXCOORD0
                                                                #define VARYINGS_NEED_POSITION_WS
                                                                #define VARYINGS_NEED_NORMAL_WS
                                                                #define VARYINGS_NEED_TEXCOORD0
                                                                #define VARYINGS_NEED_VIEWDIRECTION_WS
                                                                #define FEATURES_GRAPH_VERTEX
                                                                /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                                #define SHADERPASS SHADERPASS_UNLIT
                                                                #define _FOG_FRAGMENT 1
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
                                                                     float4 uv0;
                                                                };
                                                                struct VertexDescriptionInputs
                                                                {
                                                                     float3 ObjectSpaceNormal;
                                                                     float3 WorldSpaceNormal;
                                                                     float3 ObjectSpaceTangent;
                                                                     float3 WorldSpaceTangent;
                                                                     float3 ObjectSpaceBiTangent;
                                                                     float3 WorldSpaceBiTangent;
                                                                     float3 ObjectSpacePosition;
                                                                };
                                                                struct PackedVaryings
                                                                {
                                                                     float4 positionCS : SV_POSITION;
                                                                     float3 interp0 : INTERP0;
                                                                     float3 interp1 : INTERP1;
                                                                     float4 interp2 : INTERP2;
                                                                     float3 interp3 : INTERP3;
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

                                                                PackedVaryings PackVaryings(Varyings input)
                                                                {
                                                                    PackedVaryings output;
                                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                                    output.positionCS = input.positionCS;
                                                                    output.interp0.xyz = input.positionWS;
                                                                    output.interp1.xyz = input.normalWS;
                                                                    output.interp2.xyzw = input.texCoord0;
                                                                    output.interp3.xyz = input.viewDirectionWS;
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

                                                                Varyings UnpackVaryings(PackedVaryings input)
                                                                {
                                                                    Varyings output;
                                                                    output.positionCS = input.positionCS;
                                                                    output.positionWS = input.interp0.xyz;
                                                                    output.normalWS = input.interp1.xyz;
                                                                    output.texCoord0 = input.interp2.xyzw;
                                                                    output.viewDirectionWS = input.interp3.xyz;
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
                                                                float4 _MainTex_TexelSize;
                                                                float Fill;
                                                                float BlendFill;
                                                                float4 FillColor;
                                                                float4 BlendColor;
                                                                float4 BlankColor;
                                                                float _Angle;
                                                                float2 _Border;
                                                                CBUFFER_END

                                                                    // Object and Global properties
                                                                    SAMPLER(SamplerState_Linear_Repeat);
                                                                    TEXTURE2D(_MainTex);
                                                                    SAMPLER(sampler_MainTex);

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

                                                                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                    {
                                                                        Out = A * B;
                                                                    }

                                                                    void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                                    {
                                                                        Out = mul(A, B);
                                                                    }

                                                                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                                    {
                                                                        Out = A + B;
                                                                    }

                                                                    void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                                    {
                                                                        //rotation matrix
                                                                        Rotation = Rotation * (3.1415926f / 180.0f);
                                                                        UV -= Center;
                                                                        float s = sin(Rotation);
                                                                        float c = cos(Rotation);

                                                                        //center rotation matrix
                                                                        float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                        rMatrix *= 0.5;
                                                                        rMatrix += 0.5;
                                                                        rMatrix = rMatrix * 2 - 1;

                                                                        //multiply the UVs by the rotation matrix
                                                                        UV.xy = mul(UV.xy, rMatrix);
                                                                        UV += Center;

                                                                        Out = UV;
                                                                    }

                                                                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                    {
                                                                        Out = A * B;
                                                                    }

                                                                    void Unity_Subtract_float(float A, float B, out float Out)
                                                                    {
                                                                        Out = A - B;
                                                                    }

                                                                    void Unity_Step_float(float Edge, float In, out float Out)
                                                                    {
                                                                        Out = step(Edge, In);
                                                                    }

                                                                    void Unity_Saturate_float(float In, out float Out)
                                                                    {
                                                                        Out = saturate(In);
                                                                    }

                                                                    void Unity_Floor_float(float In, out float Out)
                                                                    {
                                                                        Out = floor(In);
                                                                    }

                                                                    void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                    {
                                                                        Out = A * B;
                                                                    }

                                                                    void Unity_Add_float(float A, float B, out float Out)
                                                                    {
                                                                        Out = A + B;
                                                                    }

                                                                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                                    {
                                                                        Out = lerp(A, B, T);
                                                                    }

                                                                    void Unity_Preview_float(float In, out float Out)
                                                                    {
                                                                        Out = In;
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
                                                                        float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                        Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                        float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                        float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                        Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                        float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                        Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                        float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                        description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                        float AlphaClipThreshold;
                                                                    };

                                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                    {
                                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                                        float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                        UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                        float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                        float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                        float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                        Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                        float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                        float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                        Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                        float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                        float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                        float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                        Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                        float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                        float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                        float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                        float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                        float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                        float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                        Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                        float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                        Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                        float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                        Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                        float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                        Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                        float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                        float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                        float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                        float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                        Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                        float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                        float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                        Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                        float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                        float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                        Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                        float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                        float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                        Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                        float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                        float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                        Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                        float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                        float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                        Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                        float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                        Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                        float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                        float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                        Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                        float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                        float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                        Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                        float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                        Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                        float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                        Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                        float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                        Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                        float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                        Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                        float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                        Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                        float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                        Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                        float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                        float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                        float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                        float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                        float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                        Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                        surface.BaseColor = (_Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3.xyz);
                                                                        surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                        surface.AlphaClipThreshold = 0.5;
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

                                                                        output.ObjectSpaceNormal = input.normalOS;
                                                                        output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                        output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                        output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                        output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                        output.ObjectSpacePosition = input.positionOS;

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
                                                                        Name "DepthOnly"
                                                                        Tags
                                                                        {
                                                                            "LightMode" = "DepthOnly"
                                                                        }

                                                                        // Render State
                                                                        Cull[_Cull]
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
                                                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                        // GraphKeywords: <None>

                                                                        // Defines

                                                                        #define ATTRIBUTES_NEED_NORMAL
                                                                        #define ATTRIBUTES_NEED_TANGENT
                                                                        #define ATTRIBUTES_NEED_TEXCOORD0
                                                                        #define VARYINGS_NEED_TEXCOORD0
                                                                        #define FEATURES_GRAPH_VERTEX
                                                                        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
                                                                        #define SHADERPASS SHADERPASS_DEPTHONLY
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
                                                                             float4 uv0;
                                                                        };
                                                                        struct VertexDescriptionInputs
                                                                        {
                                                                             float3 ObjectSpaceNormal;
                                                                             float3 WorldSpaceNormal;
                                                                             float3 ObjectSpaceTangent;
                                                                             float3 WorldSpaceTangent;
                                                                             float3 ObjectSpaceBiTangent;
                                                                             float3 WorldSpaceBiTangent;
                                                                             float3 ObjectSpacePosition;
                                                                        };
                                                                        struct PackedVaryings
                                                                        {
                                                                             float4 positionCS : SV_POSITION;
                                                                             float4 interp0 : INTERP0;
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

                                                                        PackedVaryings PackVaryings(Varyings input)
                                                                        {
                                                                            PackedVaryings output;
                                                                            ZERO_INITIALIZE(PackedVaryings, output);
                                                                            output.positionCS = input.positionCS;
                                                                            output.interp0.xyzw = input.texCoord0;
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

                                                                        Varyings UnpackVaryings(PackedVaryings input)
                                                                        {
                                                                            Varyings output;
                                                                            output.positionCS = input.positionCS;
                                                                            output.texCoord0 = input.interp0.xyzw;
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
                                                                        float4 _MainTex_TexelSize;
                                                                        float Fill;
                                                                        float BlendFill;
                                                                        float4 FillColor;
                                                                        float4 BlendColor;
                                                                        float4 BlankColor;
                                                                        float _Angle;
                                                                        float2 _Border;
                                                                        CBUFFER_END

                                                                            // Object and Global properties
                                                                            SAMPLER(SamplerState_Linear_Repeat);
                                                                            TEXTURE2D(_MainTex);
                                                                            SAMPLER(sampler_MainTex);

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

                                                                            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                            {
                                                                                Out = A * B;
                                                                            }

                                                                            void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                                            {
                                                                                Out = mul(A, B);
                                                                            }

                                                                            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                                            {
                                                                                Out = A + B;
                                                                            }

                                                                            void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                                            {
                                                                                //rotation matrix
                                                                                Rotation = Rotation * (3.1415926f / 180.0f);
                                                                                UV -= Center;
                                                                                float s = sin(Rotation);
                                                                                float c = cos(Rotation);

                                                                                //center rotation matrix
                                                                                float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                                rMatrix *= 0.5;
                                                                                rMatrix += 0.5;
                                                                                rMatrix = rMatrix * 2 - 1;

                                                                                //multiply the UVs by the rotation matrix
                                                                                UV.xy = mul(UV.xy, rMatrix);
                                                                                UV += Center;

                                                                                Out = UV;
                                                                            }

                                                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                            {
                                                                                Out = A * B;
                                                                            }

                                                                            void Unity_Subtract_float(float A, float B, out float Out)
                                                                            {
                                                                                Out = A - B;
                                                                            }

                                                                            void Unity_Step_float(float Edge, float In, out float Out)
                                                                            {
                                                                                Out = step(Edge, In);
                                                                            }

                                                                            void Unity_Saturate_float(float In, out float Out)
                                                                            {
                                                                                Out = saturate(In);
                                                                            }

                                                                            void Unity_Floor_float(float In, out float Out)
                                                                            {
                                                                                Out = floor(In);
                                                                            }

                                                                            void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                            {
                                                                                Out = A * B;
                                                                            }

                                                                            void Unity_Add_float(float A, float B, out float Out)
                                                                            {
                                                                                Out = A + B;
                                                                            }

                                                                            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                                            {
                                                                                Out = lerp(A, B, T);
                                                                            }

                                                                            void Unity_Preview_float(float In, out float Out)
                                                                            {
                                                                                Out = In;
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
                                                                                float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                                Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                                         length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                                         length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                                float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                                float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                                Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                                float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                                Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                                float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                                description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                                float AlphaClipThreshold;
                                                                            };

                                                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                            {
                                                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                                                float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                                UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                                float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                                float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                                float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                                Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                                float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                                float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                                Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                                float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                                float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                                float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                                Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                                float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                                float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                                float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                                float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                                float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                                float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                                Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                                float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                                Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                                float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                                Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                                float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                                Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                                float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                                float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                                float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                                float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                                Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                                float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                                float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                                Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                                float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                                float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                                Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                                float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                                float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                                Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                                float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                                float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                                Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                                float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                                float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                                Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                                float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                                Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                                float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                                float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                                Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                                float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                                float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                                Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                                float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                                Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                                float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                                Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                                float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                                Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                                float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                                Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                                float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                                Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                                float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                                Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                                float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                                float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                                float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                                float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                                float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                                surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                surface.AlphaClipThreshold = 0.5;
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

                                                                                output.ObjectSpaceNormal = input.normalOS;
                                                                                output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                                output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                                output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                                output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                                output.ObjectSpacePosition = input.positionOS;

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
                                                                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

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
                                                                                Cull[_Cull]
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
                                                                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                                // GraphKeywords: <None>

                                                                                // Defines

                                                                                #define ATTRIBUTES_NEED_NORMAL
                                                                                #define ATTRIBUTES_NEED_TANGENT
                                                                                #define ATTRIBUTES_NEED_TEXCOORD0
                                                                                #define ATTRIBUTES_NEED_TEXCOORD1
                                                                                #define VARYINGS_NEED_NORMAL_WS
                                                                                #define VARYINGS_NEED_TANGENT_WS
                                                                                #define VARYINGS_NEED_TEXCOORD0
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
                                                                                };
                                                                                struct VertexDescriptionInputs
                                                                                {
                                                                                     float3 ObjectSpaceNormal;
                                                                                     float3 WorldSpaceNormal;
                                                                                     float3 ObjectSpaceTangent;
                                                                                     float3 WorldSpaceTangent;
                                                                                     float3 ObjectSpaceBiTangent;
                                                                                     float3 WorldSpaceBiTangent;
                                                                                     float3 ObjectSpacePosition;
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

                                                                                PackedVaryings PackVaryings(Varyings input)
                                                                                {
                                                                                    PackedVaryings output;
                                                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                                                    output.positionCS = input.positionCS;
                                                                                    output.interp0.xyz = input.normalWS;
                                                                                    output.interp1.xyzw = input.tangentWS;
                                                                                    output.interp2.xyzw = input.texCoord0;
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

                                                                                Varyings UnpackVaryings(PackedVaryings input)
                                                                                {
                                                                                    Varyings output;
                                                                                    output.positionCS = input.positionCS;
                                                                                    output.normalWS = input.interp0.xyz;
                                                                                    output.tangentWS = input.interp1.xyzw;
                                                                                    output.texCoord0 = input.interp2.xyzw;
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
                                                                                float4 _MainTex_TexelSize;
                                                                                float Fill;
                                                                                float BlendFill;
                                                                                float4 FillColor;
                                                                                float4 BlendColor;
                                                                                float4 BlankColor;
                                                                                float _Angle;
                                                                                float2 _Border;
                                                                                CBUFFER_END

                                                                                    // Object and Global properties
                                                                                    SAMPLER(SamplerState_Linear_Repeat);
                                                                                    TEXTURE2D(_MainTex);
                                                                                    SAMPLER(sampler_MainTex);

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

                                                                                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                                    {
                                                                                        Out = A * B;
                                                                                    }

                                                                                    void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                                                    {
                                                                                        Out = mul(A, B);
                                                                                    }

                                                                                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                                                    {
                                                                                        Out = A + B;
                                                                                    }

                                                                                    void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                                                    {
                                                                                        //rotation matrix
                                                                                        Rotation = Rotation * (3.1415926f / 180.0f);
                                                                                        UV -= Center;
                                                                                        float s = sin(Rotation);
                                                                                        float c = cos(Rotation);

                                                                                        //center rotation matrix
                                                                                        float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                                        rMatrix *= 0.5;
                                                                                        rMatrix += 0.5;
                                                                                        rMatrix = rMatrix * 2 - 1;

                                                                                        //multiply the UVs by the rotation matrix
                                                                                        UV.xy = mul(UV.xy, rMatrix);
                                                                                        UV += Center;

                                                                                        Out = UV;
                                                                                    }

                                                                                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                                    {
                                                                                        Out = A * B;
                                                                                    }

                                                                                    void Unity_Subtract_float(float A, float B, out float Out)
                                                                                    {
                                                                                        Out = A - B;
                                                                                    }

                                                                                    void Unity_Step_float(float Edge, float In, out float Out)
                                                                                    {
                                                                                        Out = step(Edge, In);
                                                                                    }

                                                                                    void Unity_Saturate_float(float In, out float Out)
                                                                                    {
                                                                                        Out = saturate(In);
                                                                                    }

                                                                                    void Unity_Floor_float(float In, out float Out)
                                                                                    {
                                                                                        Out = floor(In);
                                                                                    }

                                                                                    void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                                    {
                                                                                        Out = A * B;
                                                                                    }

                                                                                    void Unity_Add_float(float A, float B, out float Out)
                                                                                    {
                                                                                        Out = A + B;
                                                                                    }

                                                                                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                                                    {
                                                                                        Out = lerp(A, B, T);
                                                                                    }

                                                                                    void Unity_Preview_float(float In, out float Out)
                                                                                    {
                                                                                        Out = In;
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
                                                                                        float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                                        Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                                        float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                                        float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                                        Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                                        float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                                        Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                                        float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                                        description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                                        float AlphaClipThreshold;
                                                                                    };

                                                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                                    {
                                                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                                                        float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                                        UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                                        float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                                        float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                                        float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                                        Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                                        float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                                        float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                                        Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                                        float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                                        float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                                        float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                                        Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                                        float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                                        float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                                        float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                                        float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                                        float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                                        float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                                        Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                                        float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                                        Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                                        float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                                        Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                                        float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                                        Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                                        float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                                        float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                                        float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                                        float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                                        Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                                        float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                                        float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                                        Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                                        float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                                        float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                                        Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                                        float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                                        float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                                        Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                                        float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                                        float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                                        Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                                        float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                                        float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                                        Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                                        float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                                        Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                                        float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                                        float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                                        Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                                        float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                                        float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                                        Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                                        float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                                        Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                                        float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                                        Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                                        float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                                        Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                                        float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                                        Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                                        float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                                        Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                                        float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                                        Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                                        float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                        Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                                        surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                        surface.AlphaClipThreshold = 0.5;
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

                                                                                        output.ObjectSpaceNormal = input.normalOS;
                                                                                        output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                                        output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                                        output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                                        output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                                        output.ObjectSpacePosition = input.positionOS;

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
                                                                                        Cull[_Cull]
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
                                                                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                                        // GraphKeywords: <None>

                                                                                        // Defines

                                                                                        #define ATTRIBUTES_NEED_NORMAL
                                                                                        #define ATTRIBUTES_NEED_TANGENT
                                                                                        #define ATTRIBUTES_NEED_TEXCOORD0
                                                                                        #define VARYINGS_NEED_NORMAL_WS
                                                                                        #define VARYINGS_NEED_TEXCOORD0
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
                                                                                             float4 uv0;
                                                                                        };
                                                                                        struct VertexDescriptionInputs
                                                                                        {
                                                                                             float3 ObjectSpaceNormal;
                                                                                             float3 WorldSpaceNormal;
                                                                                             float3 ObjectSpaceTangent;
                                                                                             float3 WorldSpaceTangent;
                                                                                             float3 ObjectSpaceBiTangent;
                                                                                             float3 WorldSpaceBiTangent;
                                                                                             float3 ObjectSpacePosition;
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

                                                                                        PackedVaryings PackVaryings(Varyings input)
                                                                                        {
                                                                                            PackedVaryings output;
                                                                                            ZERO_INITIALIZE(PackedVaryings, output);
                                                                                            output.positionCS = input.positionCS;
                                                                                            output.interp0.xyz = input.normalWS;
                                                                                            output.interp1.xyzw = input.texCoord0;
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

                                                                                        Varyings UnpackVaryings(PackedVaryings input)
                                                                                        {
                                                                                            Varyings output;
                                                                                            output.positionCS = input.positionCS;
                                                                                            output.normalWS = input.interp0.xyz;
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
                                                                                        float4 _MainTex_TexelSize;
                                                                                        float Fill;
                                                                                        float BlendFill;
                                                                                        float4 FillColor;
                                                                                        float4 BlendColor;
                                                                                        float4 BlankColor;
                                                                                        float _Angle;
                                                                                        float2 _Border;
                                                                                        CBUFFER_END

                                                                                            // Object and Global properties
                                                                                            SAMPLER(SamplerState_Linear_Repeat);
                                                                                            TEXTURE2D(_MainTex);
                                                                                            SAMPLER(sampler_MainTex);

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

                                                                                            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                                            {
                                                                                                Out = A * B;
                                                                                            }

                                                                                            void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                                                            {
                                                                                                Out = mul(A, B);
                                                                                            }

                                                                                            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                                                            {
                                                                                                Out = A + B;
                                                                                            }

                                                                                            void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                                                            {
                                                                                                //rotation matrix
                                                                                                Rotation = Rotation * (3.1415926f / 180.0f);
                                                                                                UV -= Center;
                                                                                                float s = sin(Rotation);
                                                                                                float c = cos(Rotation);

                                                                                                //center rotation matrix
                                                                                                float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                                                rMatrix *= 0.5;
                                                                                                rMatrix += 0.5;
                                                                                                rMatrix = rMatrix * 2 - 1;

                                                                                                //multiply the UVs by the rotation matrix
                                                                                                UV.xy = mul(UV.xy, rMatrix);
                                                                                                UV += Center;

                                                                                                Out = UV;
                                                                                            }

                                                                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                                            {
                                                                                                Out = A * B;
                                                                                            }

                                                                                            void Unity_Subtract_float(float A, float B, out float Out)
                                                                                            {
                                                                                                Out = A - B;
                                                                                            }

                                                                                            void Unity_Step_float(float Edge, float In, out float Out)
                                                                                            {
                                                                                                Out = step(Edge, In);
                                                                                            }

                                                                                            void Unity_Saturate_float(float In, out float Out)
                                                                                            {
                                                                                                Out = saturate(In);
                                                                                            }

                                                                                            void Unity_Floor_float(float In, out float Out)
                                                                                            {
                                                                                                Out = floor(In);
                                                                                            }

                                                                                            void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                                            {
                                                                                                Out = A * B;
                                                                                            }

                                                                                            void Unity_Add_float(float A, float B, out float Out)
                                                                                            {
                                                                                                Out = A + B;
                                                                                            }

                                                                                            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                                                            {
                                                                                                Out = lerp(A, B, T);
                                                                                            }

                                                                                            void Unity_Preview_float(float In, out float Out)
                                                                                            {
                                                                                                Out = In;
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
                                                                                                float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                                                Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                                                         length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                                                         length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                                                float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                                                float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                                                Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                                                float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                                                Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                                                float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                                                description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                                                float AlphaClipThreshold;
                                                                                            };

                                                                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                                            {
                                                                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                                                                float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                                                UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                                                float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                                                float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                                                float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                                                Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                                                float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                                                float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                                                Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                                                float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                                                float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                                                float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                                                Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                                                float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                                                float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                                                float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                                                float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                                                float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                                                float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                                                Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                                                float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                                                Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                                                float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                                                Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                                                float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                                                Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                                                float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                                                float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                                                float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                                                float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                                                Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                                                float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                                                float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                                                Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                                                float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                                                float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                                                Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                                                float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                                                float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                                                Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                                                float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                                                float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                                                Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                                                float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                                                float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                                                Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                                                float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                                                Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                                                float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                                                float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                                                Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                                                float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                                                float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                                                Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                                                float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                                                Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                                                float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                                                Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                                                float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                                                Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                                                float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                                                Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                                                float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                                                Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                                                float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                                                Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                                                float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                                                surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                surface.AlphaClipThreshold = 0.5;
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

                                                                                                output.ObjectSpaceNormal = input.normalOS;
                                                                                                output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                                                output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                                                output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                                                output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                                                output.ObjectSpacePosition = input.positionOS;

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
                                                                                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                                                // GraphKeywords: <None>

                                                                                                // Defines

                                                                                                #define ATTRIBUTES_NEED_NORMAL
                                                                                                #define ATTRIBUTES_NEED_TANGENT
                                                                                                #define ATTRIBUTES_NEED_TEXCOORD0
                                                                                                #define VARYINGS_NEED_TEXCOORD0
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
                                                                                                     float4 uv0;
                                                                                                };
                                                                                                struct VertexDescriptionInputs
                                                                                                {
                                                                                                     float3 ObjectSpaceNormal;
                                                                                                     float3 WorldSpaceNormal;
                                                                                                     float3 ObjectSpaceTangent;
                                                                                                     float3 WorldSpaceTangent;
                                                                                                     float3 ObjectSpaceBiTangent;
                                                                                                     float3 WorldSpaceBiTangent;
                                                                                                     float3 ObjectSpacePosition;
                                                                                                };
                                                                                                struct PackedVaryings
                                                                                                {
                                                                                                     float4 positionCS : SV_POSITION;
                                                                                                     float4 interp0 : INTERP0;
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

                                                                                                PackedVaryings PackVaryings(Varyings input)
                                                                                                {
                                                                                                    PackedVaryings output;
                                                                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                                                                    output.positionCS = input.positionCS;
                                                                                                    output.interp0.xyzw = input.texCoord0;
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

                                                                                                Varyings UnpackVaryings(PackedVaryings input)
                                                                                                {
                                                                                                    Varyings output;
                                                                                                    output.positionCS = input.positionCS;
                                                                                                    output.texCoord0 = input.interp0.xyzw;
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
                                                                                                float4 _MainTex_TexelSize;
                                                                                                float Fill;
                                                                                                float BlendFill;
                                                                                                float4 FillColor;
                                                                                                float4 BlendColor;
                                                                                                float4 BlankColor;
                                                                                                float _Angle;
                                                                                                float2 _Border;
                                                                                                CBUFFER_END

                                                                                                    // Object and Global properties
                                                                                                    SAMPLER(SamplerState_Linear_Repeat);
                                                                                                    TEXTURE2D(_MainTex);
                                                                                                    SAMPLER(sampler_MainTex);

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

                                                                                                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                                                    {
                                                                                                        Out = A * B;
                                                                                                    }

                                                                                                    void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                                                                    {
                                                                                                        Out = mul(A, B);
                                                                                                    }

                                                                                                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                                                                    {
                                                                                                        Out = A + B;
                                                                                                    }

                                                                                                    void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                                                                    {
                                                                                                        //rotation matrix
                                                                                                        Rotation = Rotation * (3.1415926f / 180.0f);
                                                                                                        UV -= Center;
                                                                                                        float s = sin(Rotation);
                                                                                                        float c = cos(Rotation);

                                                                                                        //center rotation matrix
                                                                                                        float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                                                        rMatrix *= 0.5;
                                                                                                        rMatrix += 0.5;
                                                                                                        rMatrix = rMatrix * 2 - 1;

                                                                                                        //multiply the UVs by the rotation matrix
                                                                                                        UV.xy = mul(UV.xy, rMatrix);
                                                                                                        UV += Center;

                                                                                                        Out = UV;
                                                                                                    }

                                                                                                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                                                    {
                                                                                                        Out = A * B;
                                                                                                    }

                                                                                                    void Unity_Subtract_float(float A, float B, out float Out)
                                                                                                    {
                                                                                                        Out = A - B;
                                                                                                    }

                                                                                                    void Unity_Step_float(float Edge, float In, out float Out)
                                                                                                    {
                                                                                                        Out = step(Edge, In);
                                                                                                    }

                                                                                                    void Unity_Saturate_float(float In, out float Out)
                                                                                                    {
                                                                                                        Out = saturate(In);
                                                                                                    }

                                                                                                    void Unity_Floor_float(float In, out float Out)
                                                                                                    {
                                                                                                        Out = floor(In);
                                                                                                    }

                                                                                                    void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                                                    {
                                                                                                        Out = A * B;
                                                                                                    }

                                                                                                    void Unity_Add_float(float A, float B, out float Out)
                                                                                                    {
                                                                                                        Out = A + B;
                                                                                                    }

                                                                                                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                                                                    {
                                                                                                        Out = lerp(A, B, T);
                                                                                                    }

                                                                                                    void Unity_Preview_float(float In, out float Out)
                                                                                                    {
                                                                                                        Out = In;
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
                                                                                                        float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                                                        Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                                                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                                                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                                                        float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                                                        float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                                                        Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                                                        float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                                                        Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                                                        float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                                                        description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                                                        float AlphaClipThreshold;
                                                                                                    };

                                                                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                                                    {
                                                                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                                                                        float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                                                        UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                                                        float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                                                        float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                                                        float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                                                        Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                                                        float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                                                        float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                                                        Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                                                        float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                                                        float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                                                        float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                                                        Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                                                        float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                                                        float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                                                        Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                                                        float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                                                        Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                                                        float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                                                        Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                                                        float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                                                        Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                                                        float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                                                        float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                                                        float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                                                        float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                                                        Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                                                        float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                                                        float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                                                        Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                                                        float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                                                        float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                                                        Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                                                        float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                                                        float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                                                        Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                                                        float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                                                        float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                                                        Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                                                        float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                                                        float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                                                        Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                                                        float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                                                        Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                                                        float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                                                        float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                                                        Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                                                        float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                                                        float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                                                        Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                                                        float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                                                        Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                                                        float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                                                        Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                                                        float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                                                        Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                                                        float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                                                        Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                                                        float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                                                        Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                                                        float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                                                        Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                                                        float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                        Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                                                        surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                        surface.AlphaClipThreshold = 0.5;
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

                                                                                                        output.ObjectSpaceNormal = input.normalOS;
                                                                                                        output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                                                        output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                                                        output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                                                        output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                                                        output.ObjectSpacePosition = input.positionOS;

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
                                                                                                        Cull[_Cull]

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
                                                                                                        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                                                        // GraphKeywords: <None>

                                                                                                        // Defines

                                                                                                        #define ATTRIBUTES_NEED_NORMAL
                                                                                                        #define ATTRIBUTES_NEED_TANGENT
                                                                                                        #define ATTRIBUTES_NEED_TEXCOORD0
                                                                                                        #define VARYINGS_NEED_TEXCOORD0
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
                                                                                                             float4 uv0;
                                                                                                        };
                                                                                                        struct VertexDescriptionInputs
                                                                                                        {
                                                                                                             float3 ObjectSpaceNormal;
                                                                                                             float3 WorldSpaceNormal;
                                                                                                             float3 ObjectSpaceTangent;
                                                                                                             float3 WorldSpaceTangent;
                                                                                                             float3 ObjectSpaceBiTangent;
                                                                                                             float3 WorldSpaceBiTangent;
                                                                                                             float3 ObjectSpacePosition;
                                                                                                        };
                                                                                                        struct PackedVaryings
                                                                                                        {
                                                                                                             float4 positionCS : SV_POSITION;
                                                                                                             float4 interp0 : INTERP0;
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

                                                                                                        PackedVaryings PackVaryings(Varyings input)
                                                                                                        {
                                                                                                            PackedVaryings output;
                                                                                                            ZERO_INITIALIZE(PackedVaryings, output);
                                                                                                            output.positionCS = input.positionCS;
                                                                                                            output.interp0.xyzw = input.texCoord0;
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

                                                                                                        Varyings UnpackVaryings(PackedVaryings input)
                                                                                                        {
                                                                                                            Varyings output;
                                                                                                            output.positionCS = input.positionCS;
                                                                                                            output.texCoord0 = input.interp0.xyzw;
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
                                                                                                        float4 _MainTex_TexelSize;
                                                                                                        float Fill;
                                                                                                        float BlendFill;
                                                                                                        float4 FillColor;
                                                                                                        float4 BlendColor;
                                                                                                        float4 BlankColor;
                                                                                                        float _Angle;
                                                                                                        float2 _Border;
                                                                                                        CBUFFER_END

                                                                                                            // Object and Global properties
                                                                                                            SAMPLER(SamplerState_Linear_Repeat);
                                                                                                            TEXTURE2D(_MainTex);
                                                                                                            SAMPLER(sampler_MainTex);

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

                                                                                                            void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                                                            {
                                                                                                                Out = A * B;
                                                                                                            }

                                                                                                            void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                                                                            {
                                                                                                                Out = mul(A, B);
                                                                                                            }

                                                                                                            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                                                                            {
                                                                                                                Out = A + B;
                                                                                                            }

                                                                                                            void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                                                                            {
                                                                                                                //rotation matrix
                                                                                                                Rotation = Rotation * (3.1415926f / 180.0f);
                                                                                                                UV -= Center;
                                                                                                                float s = sin(Rotation);
                                                                                                                float c = cos(Rotation);

                                                                                                                //center rotation matrix
                                                                                                                float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                                                                rMatrix *= 0.5;
                                                                                                                rMatrix += 0.5;
                                                                                                                rMatrix = rMatrix * 2 - 1;

                                                                                                                //multiply the UVs by the rotation matrix
                                                                                                                UV.xy = mul(UV.xy, rMatrix);
                                                                                                                UV += Center;

                                                                                                                Out = UV;
                                                                                                            }

                                                                                                            void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                                                            {
                                                                                                                Out = A * B;
                                                                                                            }

                                                                                                            void Unity_Subtract_float(float A, float B, out float Out)
                                                                                                            {
                                                                                                                Out = A - B;
                                                                                                            }

                                                                                                            void Unity_Step_float(float Edge, float In, out float Out)
                                                                                                            {
                                                                                                                Out = step(Edge, In);
                                                                                                            }

                                                                                                            void Unity_Saturate_float(float In, out float Out)
                                                                                                            {
                                                                                                                Out = saturate(In);
                                                                                                            }

                                                                                                            void Unity_Floor_float(float In, out float Out)
                                                                                                            {
                                                                                                                Out = floor(In);
                                                                                                            }

                                                                                                            void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                                                            {
                                                                                                                Out = A * B;
                                                                                                            }

                                                                                                            void Unity_Add_float(float A, float B, out float Out)
                                                                                                            {
                                                                                                                Out = A + B;
                                                                                                            }

                                                                                                            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                                                                            {
                                                                                                                Out = lerp(A, B, T);
                                                                                                            }

                                                                                                            void Unity_Preview_float(float In, out float Out)
                                                                                                            {
                                                                                                                Out = In;
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
                                                                                                                float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                                                                Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                                                                         length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                                                                         length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                                                                float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                                                                float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                                                                float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                                                                Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                                                                float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                                                                Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                                                                float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                                                                description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                                                                float AlphaClipThreshold;
                                                                                                            };

                                                                                                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                                                            {
                                                                                                                SurfaceDescription surface = (SurfaceDescription)0;
                                                                                                                float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                                                                UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                                                                float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                                                                float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                                                                float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                                                                Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                                                                float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                                                                float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                                                                float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                                                                Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                                                                float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                                                                float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                                                                float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                                                                float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                                                                Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                                                                float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                                                                float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                                                                float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                                                                float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                                                                float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                                                                float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                                                                Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                                                                float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                                                                Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                                                                float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                                                                Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                                                                float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                                                                Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                                                                float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                                                                float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                                                                float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                                                                float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                                                                float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                                                                float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                                                                Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                                                                float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                                                                float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                                                                Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                                                                float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                                                                float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                                                                Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                                                                float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                                                                float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                                                                Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                                                                float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                                                                Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                                                                float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                                                                Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                                                                float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                                                                Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                                                                float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                                                                Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                                                                float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                                                                Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                                                                float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                                                                float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                                                                Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                                                                float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                                                                float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                                                                Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                                                                float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                                                                Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                                                                float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                                                                Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                                                                float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                                                                Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                                                                float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                                                                Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                                                                float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                                                                Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                                                                float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                                                                Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                                                                float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                                                                float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                                Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                                                                surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                                surface.AlphaClipThreshold = 0.5;
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

                                                                                                                output.ObjectSpaceNormal = input.normalOS;
                                                                                                                output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                                                                output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                                                                output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                                                                output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                                                                output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                                                                output.ObjectSpacePosition = input.positionOS;

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
                                                                                                                Cull[_Cull]
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
                                                                                                                #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
                                                                                                                #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
                                                                                                                #pragma shader_feature_local_fragment _ _ALPHATEST_ON
                                                                                                                // GraphKeywords: <None>

                                                                                                                // Defines

                                                                                                                #define ATTRIBUTES_NEED_NORMAL
                                                                                                                #define ATTRIBUTES_NEED_TANGENT
                                                                                                                #define ATTRIBUTES_NEED_TEXCOORD0
                                                                                                                #define VARYINGS_NEED_NORMAL_WS
                                                                                                                #define VARYINGS_NEED_TEXCOORD0
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
                                                                                                                    #if UNITY_ANY_INSTANCING_ENABLED
                                                                                                                     uint instanceID : INSTANCEID_SEMANTIC;
                                                                                                                    #endif
                                                                                                                };
                                                                                                                struct Varyings
                                                                                                                {
                                                                                                                     float4 positionCS : SV_POSITION;
                                                                                                                     float3 normalWS;
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
                                                                                                                     float4 uv0;
                                                                                                                };
                                                                                                                struct VertexDescriptionInputs
                                                                                                                {
                                                                                                                     float3 ObjectSpaceNormal;
                                                                                                                     float3 WorldSpaceNormal;
                                                                                                                     float3 ObjectSpaceTangent;
                                                                                                                     float3 WorldSpaceTangent;
                                                                                                                     float3 ObjectSpaceBiTangent;
                                                                                                                     float3 WorldSpaceBiTangent;
                                                                                                                     float3 ObjectSpacePosition;
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

                                                                                                                PackedVaryings PackVaryings(Varyings input)
                                                                                                                {
                                                                                                                    PackedVaryings output;
                                                                                                                    ZERO_INITIALIZE(PackedVaryings, output);
                                                                                                                    output.positionCS = input.positionCS;
                                                                                                                    output.interp0.xyz = input.normalWS;
                                                                                                                    output.interp1.xyzw = input.texCoord0;
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

                                                                                                                Varyings UnpackVaryings(PackedVaryings input)
                                                                                                                {
                                                                                                                    Varyings output;
                                                                                                                    output.positionCS = input.positionCS;
                                                                                                                    output.normalWS = input.interp0.xyz;
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
                                                                                                                float4 _MainTex_TexelSize;
                                                                                                                float Fill;
                                                                                                                float BlendFill;
                                                                                                                float4 FillColor;
                                                                                                                float4 BlendColor;
                                                                                                                float4 BlankColor;
                                                                                                                float _Angle;
                                                                                                                float2 _Border;
                                                                                                                CBUFFER_END

                                                                                                                    // Object and Global properties
                                                                                                                    SAMPLER(SamplerState_Linear_Repeat);
                                                                                                                    TEXTURE2D(_MainTex);
                                                                                                                    SAMPLER(sampler_MainTex);

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

                                                                                                                    void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
                                                                                                                    {
                                                                                                                        Out = A * B;
                                                                                                                    }

                                                                                                                    void Unity_Multiply_float4x4_float4(float4x4 A, float4 B, out float4 Out)
                                                                                                                    {
                                                                                                                        Out = mul(A, B);
                                                                                                                    }

                                                                                                                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                                                                                                                    {
                                                                                                                        Out = A + B;
                                                                                                                    }

                                                                                                                    void Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation, out float2 Out)
                                                                                                                    {
                                                                                                                        //rotation matrix
                                                                                                                        Rotation = Rotation * (3.1415926f / 180.0f);
                                                                                                                        UV -= Center;
                                                                                                                        float s = sin(Rotation);
                                                                                                                        float c = cos(Rotation);

                                                                                                                        //center rotation matrix
                                                                                                                        float2x2 rMatrix = float2x2(c, -s, s, c);
                                                                                                                        rMatrix *= 0.5;
                                                                                                                        rMatrix += 0.5;
                                                                                                                        rMatrix = rMatrix * 2 - 1;

                                                                                                                        //multiply the UVs by the rotation matrix
                                                                                                                        UV.xy = mul(UV.xy, rMatrix);
                                                                                                                        UV += Center;

                                                                                                                        Out = UV;
                                                                                                                    }

                                                                                                                    void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
                                                                                                                    {
                                                                                                                        Out = A * B;
                                                                                                                    }

                                                                                                                    void Unity_Subtract_float(float A, float B, out float Out)
                                                                                                                    {
                                                                                                                        Out = A - B;
                                                                                                                    }

                                                                                                                    void Unity_Step_float(float Edge, float In, out float Out)
                                                                                                                    {
                                                                                                                        Out = step(Edge, In);
                                                                                                                    }

                                                                                                                    void Unity_Saturate_float(float In, out float Out)
                                                                                                                    {
                                                                                                                        Out = saturate(In);
                                                                                                                    }

                                                                                                                    void Unity_Floor_float(float In, out float Out)
                                                                                                                    {
                                                                                                                        Out = floor(In);
                                                                                                                    }

                                                                                                                    void Unity_Multiply_float_float(float A, float B, out float Out)
                                                                                                                    {
                                                                                                                        Out = A * B;
                                                                                                                    }

                                                                                                                    void Unity_Add_float(float A, float B, out float Out)
                                                                                                                    {
                                                                                                                        Out = A + B;
                                                                                                                    }

                                                                                                                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                                                                                                                    {
                                                                                                                        Out = lerp(A, B, T);
                                                                                                                    }

                                                                                                                    void Unity_Preview_float(float In, out float Out)
                                                                                                                    {
                                                                                                                        Out = In;
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
                                                                                                                        float3 _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2;
                                                                                                                        Unity_Multiply_float3_float3(IN.ObjectSpacePosition, float3(length(float3(UNITY_MATRIX_M[0].x, UNITY_MATRIX_M[1].x, UNITY_MATRIX_M[2].x)),
                                                                                                                                                 length(float3(UNITY_MATRIX_M[0].y, UNITY_MATRIX_M[1].y, UNITY_MATRIX_M[2].y)),
                                                                                                                                                 length(float3(UNITY_MATRIX_M[0].z, UNITY_MATRIX_M[1].z, UNITY_MATRIX_M[2].z))), _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2);
                                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_R_1 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[0];
                                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_G_2 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[1];
                                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_B_3 = _Multiply_2ce6725ffa3945c08045305b74f221a0_Out_2[2];
                                                                                                                        float _Split_ebea9b2391a741b489d918f4912cfad6_A_4 = 0;
                                                                                                                        float4 _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0 = float4(_Split_ebea9b2391a741b489d918f4912cfad6_R_1, _Split_ebea9b2391a741b489d918f4912cfad6_G_2, _Split_ebea9b2391a741b489d918f4912cfad6_B_3, 0);
                                                                                                                        float4 _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2;
                                                                                                                        Unity_Multiply_float4x4_float4(UNITY_MATRIX_I_V, _Vector4_0d1e845743e04d5b84d718c21b5745bc_Out_0, _Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2);
                                                                                                                        float3 _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2;
                                                                                                                        Unity_Add_float3((_Multiply_8b40b52ef48440c08b6c1a37567d8c2b_Out_2.xyz), SHADERGRAPH_OBJECT_POSITION, _Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2);
                                                                                                                        float3 _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1 = TransformWorldToObject(_Add_a1c52a66ace440ee940ffe8790f18a0e_Out_2.xyz);
                                                                                                                        description.Position = _Transform_e629a6d4bf2d4b79b77990e4d58b0720_Out_1;
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
                                                                                                                        float AlphaClipThreshold;
                                                                                                                    };

                                                                                                                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                                                                                                                    {
                                                                                                                        SurfaceDescription surface = (SurfaceDescription)0;
                                                                                                                        float4 _Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0 = BlankColor;
                                                                                                                        UnityTexture2D _Property_c11b06c9ceb341869167683c2877edb6_Out_0 = UnityBuildTexture2DStructNoScale(_MainTex);
                                                                                                                        float4 _UV_9e647e635977457eb85c95ec22a79fb2_Out_0 = IN.uv0;
                                                                                                                        float _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0 = _Angle;
                                                                                                                        float2 _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3;
                                                                                                                        Unity_Rotate_Degrees_float((_UV_9e647e635977457eb85c95ec22a79fb2_Out_0.xy), float2 (0.5, 0.5), _Property_a7d278ed970e4180b1d0a6702ad083c2_Out_0, _Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3);
                                                                                                                        float4 _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_R_4 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.r;
                                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_G_5 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.g;
                                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_B_6 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.b;
                                                                                                                        float _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_A_7 = _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0.a;
                                                                                                                        float4 _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2;
                                                                                                                        Unity_Multiply_float4_float4(_Property_a495c8a5ffa141e6a45a9fa8f0eeff26_Out_0, _SampleTexture2D_c0e5b5afe3ab4483887901835ce8d7ad_RGBA_0, _Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2);
                                                                                                                        float4 _Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0 = BlendColor;
                                                                                                                        float4 _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0 = SAMPLE_TEXTURE2D(_Property_c11b06c9ceb341869167683c2877edb6_Out_0.tex, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.samplerstate, _Property_c11b06c9ceb341869167683c2877edb6_Out_0.GetTransformedUV(_Rotate_b5877c884fb24745bfac568c23bd5ab7_Out_3));
                                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_R_4 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.r;
                                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_G_5 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.g;
                                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_B_6 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.b;
                                                                                                                        float _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_A_7 = _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0.a;
                                                                                                                        float4 _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2;
                                                                                                                        Unity_Multiply_float4_float4(_Property_0dc214789ffb44f5ad52d660c038e8b2_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2);
                                                                                                                        float _Property_c74e60128c8d4b9199b400f8f195aedb_Out_0 = BlendFill;
                                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_R_1 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[0];
                                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_G_2 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[1];
                                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_B_3 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[2];
                                                                                                                        float _Split_596cad96f5294550ade775f9514e8311_A_4 = _UV_9e647e635977457eb85c95ec22a79fb2_Out_0[3];
                                                                                                                        float _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2;
                                                                                                                        Unity_Subtract_float(_Property_c74e60128c8d4b9199b400f8f195aedb_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2);
                                                                                                                        float _Step_8fdc271259284b4d9702411e36c45d53_Out_2;
                                                                                                                        Unity_Step_float(0, _Subtract_f48dec45f8fe489d858f49fb0d61bb88_Out_2, _Step_8fdc271259284b4d9702411e36c45d53_Out_2);
                                                                                                                        float _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1;
                                                                                                                        Unity_Saturate_float(_Step_8fdc271259284b4d9702411e36c45d53_Out_2, _Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1);
                                                                                                                        float _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1;
                                                                                                                        Unity_Floor_float(_Saturate_d8beee4cb8e648f2b3ec2b63721d5f79_Out_1, _Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1);
                                                                                                                        float2 _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0 = _Border;
                                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_R_1 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[0];
                                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_G_2 = _Property_c04515bcf2d346cfbde6c3c8daa393f9_Out_0[1];
                                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_B_3 = 0;
                                                                                                                        float _Split_e15ce7dc6d664758a63b2ac5549312c3_A_4 = 0;
                                                                                                                        float4 _UV_81adc2c69f7149e983eac037b92603b7_Out_0 = IN.uv0;
                                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_R_1 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[0];
                                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_G_2 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[1];
                                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_B_3 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[2];
                                                                                                                        float _Split_563566762cfc4b0aad3d1b027789dd0b_A_4 = _UV_81adc2c69f7149e983eac037b92603b7_Out_0[3];
                                                                                                                        float _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, -1, _Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2);
                                                                                                                        float _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2;
                                                                                                                        Unity_Add_float(_Multiply_3e428eb8a3dd4a8786e044a2bd61475e_Out_2, 1, _Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2);
                                                                                                                        float _Multiply_60c09dfc87e843ee851eee95da124491_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_G_2, 1, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2);
                                                                                                                        float _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Add_ecdedf90a3af4637a0a62e8cfa184154_Out_2, _Multiply_60c09dfc87e843ee851eee95da124491_Out_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2);
                                                                                                                        float _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2;
                                                                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_G_2, _Multiply_ab8c028bf11f4c518aa5de0ef837728e_Out_2, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2);
                                                                                                                        float _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Floor_395879a2873044ebaa8b9325ceeb24ba_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_f5597ccc656d463da623ca0667a83b99_Out_2);
                                                                                                                        float _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, -1, _Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2);
                                                                                                                        float _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2;
                                                                                                                        Unity_Add_float(_Multiply_4c469d832a6443ee8501e80ad5a35350_Out_2, 1, _Add_409256c6b4e742bbb44c910ce2d1877f_Out_2);
                                                                                                                        float _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Split_563566762cfc4b0aad3d1b027789dd0b_R_1, 1, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2);
                                                                                                                        float _Multiply_f2090caee3c0451e96312303e578da50_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Add_409256c6b4e742bbb44c910ce2d1877f_Out_2, _Multiply_3e7a077cbefe489a9d255173b15d5956_Out_2, _Multiply_f2090caee3c0451e96312303e578da50_Out_2);
                                                                                                                        float _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2;
                                                                                                                        Unity_Step_float(_Split_e15ce7dc6d664758a63b2ac5549312c3_R_1, _Multiply_f2090caee3c0451e96312303e578da50_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2);
                                                                                                                        float _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Multiply_f5597ccc656d463da623ca0667a83b99_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2);
                                                                                                                        float4 _Lerp_972214ad12c443099be8d017940d81b7_Out_3;
                                                                                                                        Unity_Lerp_float4(_Multiply_3c64da78aaa34eccab91dacd6f342363_Out_2, _Multiply_aae0a6c8901d432a95d709ce5658be5b_Out_2, (_Multiply_5c93a32c3dbe4f46894725793f3d093c_Out_2.xxxx), _Lerp_972214ad12c443099be8d017940d81b7_Out_3);
                                                                                                                        float4 _Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0 = FillColor;
                                                                                                                        float4 _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2;
                                                                                                                        Unity_Multiply_float4_float4(_Property_ed8ff452cf3940d2b46a1c351a3c2539_Out_0, _SampleTexture2D_dd246159d9c247f5a438be1c224a2c30_RGBA_0, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2);
                                                                                                                        float _Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0 = Fill;
                                                                                                                        float _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2;
                                                                                                                        Unity_Subtract_float(_Property_32ab3083b1c2413ba62b8d6ff87295ab_Out_0, _Split_596cad96f5294550ade775f9514e8311_R_1, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2);
                                                                                                                        float _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2;
                                                                                                                        Unity_Step_float(0, _Subtract_2d9030f3742448fe8523f653883f7e30_Out_2, _Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2);
                                                                                                                        float _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1;
                                                                                                                        Unity_Saturate_float(_Step_19f44b5062fd4dba91f9341c9a15cde2_Out_2, _Saturate_ea349926564e43048f1d04168bdddc7e_Out_1);
                                                                                                                        float _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1;
                                                                                                                        Unity_Floor_float(_Saturate_ea349926564e43048f1d04168bdddc7e_Out_1, _Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1);
                                                                                                                        float _Multiply_978b03b11ff345c5a268601820b65929_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Floor_9ec1e0061cd74392b9b3db4c52bc5c10_Out_1, _Step_229b24c786bb4003a22b7f2a61e238c8_Out_2, _Multiply_978b03b11ff345c5a268601820b65929_Out_2);
                                                                                                                        float _Multiply_80c675e0ec414c90828ab4b840034850_Out_2;
                                                                                                                        Unity_Multiply_float_float(_Multiply_978b03b11ff345c5a268601820b65929_Out_2, _Step_55fb0109c7334598a1c63d9fb3bc7117_Out_2, _Multiply_80c675e0ec414c90828ab4b840034850_Out_2);
                                                                                                                        float4 _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3;
                                                                                                                        Unity_Lerp_float4(_Lerp_972214ad12c443099be8d017940d81b7_Out_3, _Multiply_06a8dabc210e4b9fa91985d4ac788d07_Out_2, (_Multiply_80c675e0ec414c90828ab4b840034850_Out_2.xxxx), _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3);
                                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_R_1 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[0];
                                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_G_2 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[1];
                                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_B_3 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[2];
                                                                                                                        float _Split_4d4b1e7d119547d186d709164f564700_A_4 = _Lerp_30f7e6cef8934b0d92d97da587a7dabc_Out_3[3];
                                                                                                                        float _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                                        Unity_Preview_float(_Split_4d4b1e7d119547d186d709164f564700_A_4, _Preview_d110884b276240efa55549d0fb70058d_Out_1);
                                                                                                                        surface.Alpha = _Preview_d110884b276240efa55549d0fb70058d_Out_1;
                                                                                                                        surface.AlphaClipThreshold = 0.5;
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

                                                                                                                        output.ObjectSpaceNormal = input.normalOS;
                                                                                                                        output.WorldSpaceNormal = TransformObjectToWorldNormal(input.normalOS);
                                                                                                                        output.ObjectSpaceTangent = input.tangentOS.xyz;
                                                                                                                        output.WorldSpaceTangent = TransformObjectToWorldDir(input.tangentOS.xyz);
                                                                                                                        output.ObjectSpaceBiTangent = normalize(cross(input.normalOS, input.tangentOS.xyz) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                                                                                                                        output.WorldSpaceBiTangent = TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                                                                                                                        output.ObjectSpacePosition = input.positionOS;

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