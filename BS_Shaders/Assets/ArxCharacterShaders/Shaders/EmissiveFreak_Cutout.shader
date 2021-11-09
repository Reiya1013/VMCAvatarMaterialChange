Shader "ArxCharacterShaders/_EmissiveFreak/AlphaCutout" {
    Properties {
        // Double Sided
        [Enum(None,0, Front,1, Back,2)] _Cull("Cull", Int) = 2
        [AXCSToggle]_DoubleSidedFlipBackfaceNormal ("Flip backface normal", Float ) = 0
        _DoubleSidedBackfaceLightIntensity ("Backface Light intensity", Range(0, 2) ) = 0.5
        [AXCSToggle]_DoubleSidedBackfaceUseColorShift("Backface Use Color Shift", Int) = 0
        [PowerSlider(2.0)]_DoubleSidedBackfaceHueShiftFromBase("Backface Hue Shift From Base", Range(-0.5, 0.5)) = 0
        _DoubleSidedBackfaceSaturationFromBase("Backface Saturation From Base", Range(0, 2)) = 1
        _DoubleSidedBackfaceValueFromBase("Backface Value From Base", Range(0, 2)) = 1
        // Common
        _MainTex ("[Common] Base Texture", 2D) = "white" {}
        _Color ("[Common] Base Color", Color) = (1,1,1,1)
        _BumpMap ("[Common] Normal map", 2D) = "bump" {}
        _BumpScale ("[Common] Normal scale", Range(0,2)) = 1
        _EmissionMap ("[Common] Emission map", 2D) = "white" {}
        [HDR]_EmissionColor ("[Common] Emission Color", Color) = (0,0,0,1)
        // DetailMap
        _DetailMask ("[Detail] Mask texture", 2D) = "white" {}
        _DetailAlbedoMap ("[Detail] Albedo map ", 2D) = "gray" {}
        _DetailAlbedoScale ("[Detail] Albedo map scale", Range(0, 1)) = 1
        _DetailNormalMap ("[Detail] Normal map", 2D) = "bump" {}
        _DetailNormalMapScale ("[Detail] Normal scale", Range(0, 2)) = 1
        // Emission Parallax
        [AXCSToggle]_UseEmissionParallax ("[Emission Parallax] Use Emission Parallax", Int ) = 0
        _EmissionParallaxTex ("[Emission Parallax] Texture", 2D ) = "black" {}
        [HDR]_EmissionParallaxColor ("[Emission Parallax] Color", Color ) = (1,1,1,1)
        _EmissionParallaxMask ("[Emission Parallax] Emission Mask", 2D ) = "white" {}
        _EmissionParallaxDepth ("[Emission Parallax] Depth", Range(-1, 1) ) = 0
        _EmissionParallaxDepthMask ("[Emission Parallax] Depth Mask", 2D ) = "white" {}
        [AXCSToggle]_EmissionParallaxDepthMaskInvert ("[Emission Parallax] Invert Depth Mask", Float ) = 0
        // Cutout
        _CutoutCutoutAdjust ("Cutout Border Adjust", Range(0, 1)) = 0.5
        // Shadow (received from DirectionalLight, other Indirect(baked) Lights, including SH)
        _Shadowborder ("[Shadow] border ", Range(0, 1)) = 0.6
        _ShadowborderBlur ("[Shadow] border Blur", Range(0, 1)) = 0.05
        _ShadowborderBlurMask ("[Shadow] border Blur Mask", 2D) = "white" {}
        _ShadowStrength ("[Shadow] Strength", Range(0, 1)) = 0.5
        _ShadowStrengthMask ("[Shadow] Strength Mask", 2D) = "white" {}
        _ShadowAmbientIntensity ("[Shadow] Ambient Intensity", Range(0, 1)) = 0.75
        [AXCSRamp]_ShadowRamp("[Shadow] Ramp Texture", 2D) = "white"  {}
        [HideInInspector]_ShadowRampInit("[Shadow] Ramp Texture Initialized", Int) = 0
        // PointShadow (received from Point/Spot Lights as Pixel/Vertex Lights)
        _PointAddIntensity ("[PointShadow] Light Intensity", Range(0,1)) = 1
        _PointShadowStrength ("[PointShadow] Strength", Range(0, 1)) = 0.5
        _PointShadowborder ("[PointShadow] border ", Range(0, 1)) = 0.5
        _PointShadowborderBlur ("[PointShadow] border Blur", Range(0, 1)) = 0.01
        _PointShadowborderBlurMask ("[PointShadow] border Blur Mask", 2D) = "white" {}
        // Plan B
        [AXCSToggle] _ShadowPlanBUseCustomShadowTexture ("[Plan B] Use Custom Shadow Texture", Int ) = 0
        [PowerSlider(2.0)]_ShadowPlanBHueShiftFromBase ("[Plan B] Hue Shift From Base", Range(-0.5, 0.5)) = 0
        _ShadowPlanBSaturationFromBase ("[Plan B] Saturation From Base", Range(0, 2)) = 1
        _ShadowPlanBValueFromBase ("[Plan B] Value From Base", Range(0, 2)) = 1
        _ShadowPlanBCustomShadowTexture ("[Plan B] Custom Shadow Texture", 2D) = "black" {}
        _ShadowPlanBCustomShadowDetailMap ("[Plan B] Custom Shadow Detail Texture ", 2D) = "gray" {}
        _ShadowPlanBCustomShadowTextureRGB ("[Plan B] Custom Shadow Texture RGB", Color) = (1,1,1,1)
        // Shadow Receiving
        _ShadowReceivingIntensity ("[Shadow Receiving] Intensity", Range(0, 1)) = 1
        _ShadowReceivingMask ("[Shadow Receiving] Mask", 2D) = "white"  {}
        // Gloss
        [AXCSToggle]_UseGloss ("[Gloss] Enabled", Int) = 0
        _GlossBlend ("[Gloss] Smoothness", Range(0, 1)) = 0.5
        _GlossBlendMask ("[Gloss] Smoothness Mask", 2D) = "white" {}
        _GlossPower ("[Gloss] Metallic", Range(0, 1)) = 0.5
        _GlossColor ("[Gloss] Color", Color) = (1,1,1,1)
        // AXCS_GENERATOR:OUTLINE_PROPERTIES
        // MatCap
        [Enum(Add,0, Lighten,1, Screen,2, Unused,3)] _MatcapBlendMode ("[MatCap] Blend Mode", Int) = 3
        _MatcapBlend ("[MatCap] Blend", Range(0, 3)) = 1
        _MatcapBlendMask ("[MatCap] Blend Mask", 2D) = "white" {}
        _MatcapNormalMix ("[MatCap] Normal map mix", Range(0, 2)) = 1
        _MatcapShadeMix ("[MatCap] Shade Mix", Range(0, 1)) = 0
        _MatcapTexture ("[MatCap] Texture", 2D) = "black" {}
        _MatcapColor ("[MatCap] Color", Color) = (1,1,1,1)
        // Reflection
        [AXCSToggle]_UseReflection ("[Reflection] Enabled", Int) = 0
        [AXCSToggle]_UseReflectionProbe ("[Reflection] Use Reflection Probe", Int) = 1
        _ReflectionReflectionPower ("[Reflection] Reflection Power", Range(0, 1)) = 1
        _ReflectionReflectionMask ("[Reflection] Reflection Mask", 2D) = "white" {}
        _ReflectionNormalMix ("[Reflection] Normal Map Mix", Range(0,2)) = 1
        _ReflectionShadeMix ("[Reflection] Shade Mix", Range(0, 1)) = 0
        _ReflectionSuppressBaseColorValue ("[Reflection] Suppress Base Color", Range(0, 1)) = 1
        _ReflectionCubemap ("[Reflection] Cubemap", Cube) = "" {}
        // Rim
        [AXCSToggle]_UseRim ("[Rim] Enabled", Int) = 0
        _RimBlend ("[Rim] Blend", Range(0, 3)) = 1
        _RimBlendMask ("[Rim] Blend Mask", 2D) = "white" {}
        _RimShadeMix("[Rim] Shade Mix", Range(0, 1)) = 0
        _RimBlendStart("[Rim] Blend start", Range(0, 1)) = 0
        _RimBlendEnd("[Rim] Blend end", Range(0, 1)) = 1
        [Enum(Linear,0, Pow3,1, Pow5,2)] _RimPow ("[Rim] Power Type", Int) = 1
        [HDR]_RimColor ("[Rim] Color", Color) = (1,1,1,1)
        _RimTexture ("[Rim] Texture", 2D) = "white" {}
        [AXCSToggle] _RimUseBaseTexture ("[Rim] Use Base Texture", Float ) = 0
        // ShadowCap
        [Enum(Darken,0, Multiply,1, Light Shutter,2, Unused,3)] _ShadowCapBlendMode ("[ShadowCap] Blend Mode", Int) = 3
        _ShadowCapBlend ("[ShadowCap] Blend", Range(0, 3)) = 1
        _ShadowCapBlendMask ("[ShadowCap] Blend Mask", 2D) = "white" {}
        _ShadowCapNormalMix ("[ShadowCap] Normal map mix", Range(0, 2)) = 1
        _ShadowCapTexture ("[ShadowCap] Texture", 2D) = "white" {}
        // AXCS_GENERATOR:STENCIL_READER_PROPERTIES
        // AXCS_GENERATOR:STENCIL_WRITER_PROPERTIES
        // vertex color blend
        _VertexColorBlendDiffuse ("[VertexColor] Blend to diffuse", Range(0,1)) = 0
        _VertexColorBlendEmissive ("[VertexColor] Blend to emissive", Range(0,1)) = 0
        // EmissiveFreak
        _EmissiveFreak1Tex ("[EmissiveFreak] Texture", 2D ) = "white" {}
        [HDR]_EmissiveFreak1Color ("[EmissiveFreak] Color", Color ) = (0,0,0,1)
        _EmissiveFreak1Mask ("[EmissiveFreak] Mask", 2D ) = "white" {}
        _EmissiveFreak1U ("[EmissiveFreak] U Scroll", Float ) = 0
        _EmissiveFreak1V ("[EmissiveFreak] V Scroll", Float ) = 0
        _EmissiveFreak1Depth ("[EmissiveFreak] Depth", Range(-1, 1) ) = 0
        _EmissiveFreak1DepthMask ("[EmissiveFreak] Depth Mask", 2D ) = "white" {}
        [AXCSToggle]_EmissiveFreak1DepthMaskInvert ("[EmissiveFreak] Invert Depth Mask", Float ) = 0
        _EmissiveFreak1Breathing ("[EmissiveFreak] Breathing Speed", Float ) = 0
        _EmissiveFreak1BreathingMix ("[EmissiveFreak] Breathing Factor", Range(0, 1) ) = 0
        _EmissiveFreak1BlinkOut ("[EmissiveFreak] Blink Out Speed", Float ) = 0
        _EmissiveFreak1BlinkOutMix ("[EmissiveFreak] Blink Out Factor", Range(0, 1) ) = 0
        _EmissiveFreak1BlinkIn ("[EmissiveFreak] Blink In", Float ) = 0
        _EmissiveFreak1BlinkInMix ("[EmissiveFreak] Blink In Factor", Range(0, 1) ) = 0
        _EmissiveFreak1HueShift ("[EmissiveFreak] Hue Shift Speed", Float ) = 0
        _EmissiveFreak2Tex ("[EmissiveFreak2] Texture", 2D ) = "white" {}
        [HDR]_EmissiveFreak2Color ("[EmissiveFreak2] Color", Color ) = (0,0,0,1)
        _EmissiveFreak2Mask ("[EmissiveFreak2] Mask", 2D ) = "white" {}
        _EmissiveFreak2U ("[EmissiveFreak2] U Scroll", Float ) = 0
        _EmissiveFreak2V ("[EmissiveFreak2] V Scroll", Float ) = 0
        _EmissiveFreak2Depth ("[EmissiveFreak2] Depth", Range(-1, 1) ) = 0
        _EmissiveFreak2DepthMask ("[EmissiveFreak2] Depth Mask", 2D ) = "white" {}
        [AXCSToggle]_EmissiveFreak2DepthMaskInvert ("[EmissiveFreak2] Invert Depth Mask", Float ) = 0
        _EmissiveFreak2Breathing ("[EmissiveFreak2] Breathing Speed", Float ) = 0
        _EmissiveFreak2BreathingMix ("[EmissiveFreak2] Breathing Factor", Range(0, 1) ) = 0
        _EmissiveFreak2BlinkOut ("[EmissiveFreak2] Blink Out Speed", Float ) = 0
        _EmissiveFreak2BlinkOutMix ("[EmissiveFreak2] Blink Out Factor", Range(0, 1) ) = 0
        _EmissiveFreak2BlinkIn ("[EmissiveFreak2] Blink In", Float ) = 0
        _EmissiveFreak2BlinkInMix ("[EmissiveFreak2] Blink In Factor", Range(0, 1) ) = 0
        _EmissiveFreak2HueShift ("[EmissiveFreak2] Hue Shift Speed", Float ) = 0
        // Proximity color override
        [AXCSToggle]_UseProximityOverride ("[ProximityOverride] Enabled", Int) = 0
        _ProximityOverrideBegin ("[ProximityOverride] Begin", Range(0.0, 1.0)) = 0.10
        _ProximityOverrideEnd ("[ProximityOverride] End", Range(0.0, 1.0)) = 0.01
        [PowerSlider(2.0)]_ProximityOverrideHueShiftFromBase ("[ProximityOverride] Hue Shift From Base", Range(-0.5, 0.5)) = -0.01
        _ProximityOverrideSaturationFromBase ("[ProximityOverride] Saturation From Base", Range(0, 2)) = 1.5
        _ProximityOverrideValueFromBase ("[ProximityOverride] Value From Base", Range(0, 2)) = 0
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest" // AXCS_GENERATOR:STENCIL_READER_QUEUE
            "RenderType" = "TransparentCutout"
            "IgnoreProjector"="True"
        }
        // AXCS_GENERATOR:STENCIL_WRITER_SHADER_PASS
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull [_Cull]

            // AXCS_GENERATOR:STENCIL_READER_STATEMENT
            CGPROGRAM

            #pragma vertex vert
            // AXCS_GENERATOR:OUTLINE_USE_GEOM
            #pragma fragment frag
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 3.0 // AXCS_GENERATOR:OUTLINE_SHADER_MODEL
            #define AXCS_CUTOUT
            #define AXCS_EMISSIVE_FREAK
            // AXCS_GENERATOR:OUTLINE_DEFINE

            #include "cginc/arkludeDecl.cginc"
            #include "cginc/arkludeOther.cginc"
            #include "cginc/arkludeVertGeom.cginc"
            #include "cginc/arkludeFrag.cginc"
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Cull [_Cull]
            Blend One One

            // AXCS_GENERATOR:STENCIL_READER_STATEMENT
            CGPROGRAM

            #pragma vertex vert
            // AXCS_GENERATOR:OUTLINE_USE_GEOM
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 3.0 // AXCS_GENERATOR:OUTLINE_SHADER_MODEL
            #define AXCS_CUTOUT
            #define AXCS_ADD
            // AXCS_GENERATOR:OUTLINE_DEFINE

            #include "cginc/arkludeDecl.cginc"
            #include "cginc/arkludeOther.cginc"
            #include "cginc/arkludeVertGeom.cginc"
            #include "cginc/arkludeAdd.cginc"
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull [_Cull]

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 3.0 // AXCS_GENERATOR:OUTLINE_SHADER_MODEL

            uniform float _CutoutCutoutAdjust;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _Color;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct g2f {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            g2f vert (VertexInput v) {
                g2f o = (g2f)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(g2f i) : COLOR {
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                clip((_MainTex_var.a * _Color.a) - _CutoutCutoutAdjust);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Standard"
    CustomEditor "AxCharacterShaders.AxInspector"
}
