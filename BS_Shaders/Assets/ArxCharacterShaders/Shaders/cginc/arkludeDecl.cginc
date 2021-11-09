#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"


#if defined(AXCS_SECONDARY)
    // Secondary
    UNITY_DECLARE_TEX2D(_MainTexSecondary); uniform float4 _MainTexSecondary_ST;
    uniform float4 _ColorSecondary;
    uniform sampler2D _BumpMapSecondary; uniform float4 _BumpMapSecondary_ST;
    uniform float _BumpScaleSecondary;
    uniform sampler2D _EmissionMapSecondary; uniform float4 _EmissionMapSecondary_ST;
    uniform float4 _EmissionColorSecondary;
#   define REF_MAINTEX _MainTexSecondary
#   define REF_COLOR _ColorSecondary
#   define REF_BUMPMAP _BumpMapSecondary
#   define REF_BUMPSCALE _BumpScaleSecondary
#   define REF_EMISSIONMAP _EmissionMapSecondary
#   define REF_EMISSIONCOLOR _EmissionColorSecondary
#else
    // Main, Normal, Emission
    UNITY_DECLARE_TEX2D(_MainTex); uniform float4 _MainTex_ST;
    uniform float4 _Color;
    uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
    uniform float _BumpScale;
    uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
    uniform float4 _EmissionColor;
#   define REF_MAINTEX _MainTex
#   define REF_COLOR _Color
#   define REF_BUMPMAP _BumpMap
#   define REF_BUMPSCALE _BumpScale
#   define REF_EMISSIONMAP _EmissionMap
#   define REF_EMISSIONCOLOR _EmissionColor
#endif

// Detail
UNITY_DECLARE_TEX2D(_DetailAlbedoMap); uniform float4 _DetailAlbedoMap_ST;
UNITY_DECLARE_TEX2D(_DetailNormalMap); uniform float4 _DetailNormalMap_ST;
uniform float _DetailNormalMapScale;
UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMask); uniform float4 _DetailMask_ST;
uniform float _DetailAlbedoScale;

// Alpha Mask
UNITY_DECLARE_TEX2D_NOSAMPLER(_AlphaMask); uniform float4 _AlphaMask_ST;

// Emission Parallax
uniform float _UseEmissionParallax;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionParallaxTex); uniform float4 _EmissionParallaxTex_ST;
uniform float4 _EmissionParallaxColor;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionParallaxMask); uniform float4 _EmissionParallaxMask_ST;
uniform float _EmissionParallaxDepth;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissionParallaxDepthMask); uniform float4 _EmissionParallaxDepthMask_ST;
uniform float _EmissionParallaxDepthMaskInvert;

// Double Side
uniform float _DoubleSidedBackfaceLightIntensity;
uniform int _DoubleSidedBackfaceUseColorShift;
uniform float _DoubleSidedBackfaceHueShiftFromBase;
uniform float _DoubleSidedBackfaceSaturationFromBase;
uniform float _DoubleSidedBackfaceValueFromBase;
uniform float _DoubleSidedFlipBackfaceNormal;

// Shadow
uniform float _Shadowborder;
uniform float _ShadowborderBlur;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowborderBlurMask); uniform float4 _ShadowborderBlurMask_ST;
uniform float _ShadowStrength;
uniform texture2D _ShadowRamp; SamplerState my_linear_clamp_sampler;
uniform sampler2D _ShadowStrengthMask; uniform float4 _ShadowStrengthMask_ST;
uniform float _ShadowAmbientIntensity;

// Custom shade
uniform float _ShadowPlanBHueShiftFromBase;
uniform float _ShadowPlanBSaturationFromBase;
uniform float _ShadowPlanBValueFromBase;
uniform int _ShadowPlanBUseCustomShadowTexture;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowPlanBCustomShadowTexture); uniform float4 _ShadowPlanBCustomShadowTexture_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowPlanBCustomShadowDetailMap); /* _DetailAlbedoMap_ST を使う*/
uniform float4 _ShadowPlanBCustomShadowTextureRGB;

// Outline
#ifdef AXCS_OUTLINE
UNITY_DECLARE_TEX2D_NOSAMPLER(_OutlineMask); uniform float4 _OutlineMask_ST;
uniform float _OutlineCutoffRange;
uniform float _OutlineTextureColorRate;
uniform float _OutlineWidth;
uniform float4 _OutlineColor;
UNITY_DECLARE_TEX2D_NOSAMPLER(_OutlineTexture); uniform float4 _OutlineTexture_ST;
uniform sampler2D _OutlineWidthMask; uniform float4 _OutlineWidthMask_ST; // FIXME:tex2dLodはUNITY_SAMPLE_TEX2D_SAMPLERの代用が判らないためいったん保留
uniform float _OutlineUseColorShift;
uniform float _OutlineHueShiftFromBase;
uniform float _OutlineSaturationFromBase;
uniform float _OutlineValueFromBase;
#endif

// Shadow Receiving
uniform float _ShadowReceivingIntensity;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowReceivingMask); uniform float4 _ShadowReceivingMask_ST;

// Gloss
uniform int _UseGloss;
uniform float _GlossBlend;
UNITY_DECLARE_TEX2D_NOSAMPLER(_GlossBlendMask); uniform float4 _GlossBlendMask_ST;
uniform float _GlossPower;
uniform float4 _GlossColor;
uniform float _CutoutCutoutAdjust;

// Point lights
uniform float _PointAddIntensity;
uniform float _PointShadowStrength;
uniform float _PointShadowborder;
uniform float _PointShadowborderBlur;
UNITY_DECLARE_TEX2D_NOSAMPLER(_PointShadowborderBlurMask); uniform float4 _PointShadowborderBlurMask_ST;

// MatCap
uniform int _MatcapBlendMode;
UNITY_DECLARE_TEX2D_NOSAMPLER(_MatcapTexture); uniform float4 _MatcapTexture_ST;
uniform float _MatcapBlend;
UNITY_DECLARE_TEX2D_NOSAMPLER(_MatcapBlendMask); uniform float4 _MatcapBlendMask_ST;
uniform float4 _MatcapColor;
uniform float _MatcapNormalMix;
uniform float _MatcapShadeMix;

// Reflection
uniform int _UseReflection;
uniform int _UseReflectionProbe;
uniform float _ReflectionReflectionPower;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ReflectionReflectionMask); uniform float4 _ReflectionReflectionMask_ST;
uniform float _ReflectionNormalMix;
uniform float _ReflectionShadeMix;
uniform float _ReflectionSuppressBaseColorValue;
uniform samplerCUBE _ReflectionCubemap;
uniform half4  _ReflectionCubemap_HDR;

// Rim
uniform int _UseRim;
uniform float _RimBlendStart;
uniform float _RimBlendEnd;
uniform float _RimPow;
uniform float4 _RimColor;
uniform fixed _RimUseBaseTexture;
uniform float _RimBlend;
uniform float _RimShadeMix;
UNITY_DECLARE_TEX2D_NOSAMPLER(_RimBlendMask); uniform float4 _RimBlendMask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_RimTexture); uniform float4 _RimTexture_ST;

// Shade cap (Shadow cap)
uniform int _ShadowCapBlendMode;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowCapTexture); uniform float4 _ShadowCapTexture_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowCapBlendMask); uniform float4 _ShadowCapBlendMask_ST;
uniform float _ShadowCapBlend;
uniform float _ShadowCapNormalMix;

// Vertex Color Blend
uniform float _VertexColorBlendDiffuse;
uniform float _VertexColorBlendEmissive;

// Refraction IF refracted
#ifdef AXCS_REFRACTED
uniform sampler2D _GrabTexture;
uniform float _RefractionFresnelExp;
uniform float _RefractionStrength;
#endif

// ScrolledEmission
#ifdef AXCS_EMISSIVE_FREAK
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1Tex); uniform float4 _EmissiveFreak1Tex_ST;
uniform float4 _EmissiveFreak1Color;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1Mask); uniform float4 _EmissiveFreak1Mask_ST;
uniform float _EmissiveFreak1U;
uniform float _EmissiveFreak1V;
uniform float _EmissiveFreak1Depth;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1DepthMask); uniform float4 _EmissiveFreak1DepthMask_ST;
uniform float _EmissiveFreak1DepthMaskInvert;
uniform float _EmissiveFreak1Breathing;
uniform float _EmissiveFreak1BreathingMix;
uniform float _EmissiveFreak1BlinkOut;
uniform float _EmissiveFreak1BlinkOutMix;
uniform float _EmissiveFreak1BlinkIn;
uniform float _EmissiveFreak1BlinkInMix;
uniform float _EmissiveFreak1HueShift;

UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2Tex); uniform float4 _EmissiveFreak2Tex_ST;
uniform float4 _EmissiveFreak2Color;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2Mask); uniform float4 _EmissiveFreak2Mask_ST;
uniform float _EmissiveFreak2U;
uniform float _EmissiveFreak2V;
uniform float _EmissiveFreak2Depth;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2DepthMask); uniform float4 _EmissiveFreak2DepthMask_ST;
uniform float _EmissiveFreak2DepthMaskInvert;
uniform float _EmissiveFreak2Breathing;
uniform float _EmissiveFreak2BreathingMix;
uniform float _EmissiveFreak2BlinkOut;
uniform float _EmissiveFreak2BlinkOutMix;
uniform float _EmissiveFreak2BlinkIn;
uniform float _EmissiveFreak2BlinkInMix;
uniform float _EmissiveFreak2HueShift;
#endif

// Proximity color override
uniform int _UseProximityOverride;
uniform float _ProximityOverrideBegin;
uniform float _ProximityOverrideEnd;
uniform float4 _ProximityOverrideColor;
uniform int _ProximityOverrideAlphaOnly;
uniform float _ProximityOverrideHueShiftFromBase;
uniform float _ProximityOverrideSaturationFromBase;
uniform float _ProximityOverrideValueFromBase;
uniform float _ProximityOverrideAlphaScale;
