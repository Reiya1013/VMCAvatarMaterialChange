// Copyright (c) 2020 thakyuu
//
// This code is under MIT licence, see LICENSE
//
// 本コード は MIT License を使用して公開しています。
// 詳細はLICENSEか、https://opensource.org/licenses/mit-license.php を参照してください。


// This Code Based on Arktoon-Shader
//
// Original code is under MIT license
//
// Original code Copyright (c) 2018 synqark
// Original code and repos（https://github.com/synqark/Arktoon-Shader) is under MIT licence, see LICENSE
//
// 本コード は Arktoon-Shaderをベースとしています
// Arktoon-Shader は MIT License を使用して公開されています。
//

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"


#if defined(GAMINGEFFECT_SECONDARY)
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

//----ジオメトリシェーダー用
	uniform bool      _EnableGeometry;
	uniform float     _Destruction;
	uniform float     _ScaleFactor;
	uniform float     _RotationFactor;
	uniform float     _PositionFactor;
	uniform float     _PositionAdd;


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
uniform int _UseDoubleSided;
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
uniform float _ShadowIndirectIntensity;
uniform float _ShadowUseStep;
uniform int _ShadowSteps;
uniform sampler2D _ShadowStrengthMask; uniform float4 _ShadowStrengthMask_ST;

// Custom shade1
uniform int _ShadowPlanBUsePlanB;
uniform float _ShadowPlanBDefaultShadowMix;
uniform float _ShadowPlanBHueShiftFromBase;
uniform float _ShadowPlanBSaturationFromBase;
uniform float _ShadowPlanBValueFromBase;
uniform int _ShadowPlanBUseCustomShadowTexture;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowPlanBCustomShadowTexture); uniform float4 _ShadowPlanBCustomShadowTexture_ST;
uniform float4 _ShadowPlanBCustomShadowTextureRGB;

// Cutsom shade2
uniform int _CustomShadow2nd;
uniform float _ShadowPlanB2border;
uniform float _ShadowPlanB2borderBlur;
uniform float _ShadowPlanB2HueShiftFromBase;
uniform float _ShadowPlanB2SaturationFromBase;
uniform float _ShadowPlanB2ValueFromBase;
uniform int _ShadowPlanB2UseCustomShadowTexture;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowPlanB2CustomShadowTexture); uniform float4 _ShadowPlanB2CustomShadowTexture_ST;
uniform float4 _ShadowPlanB2CustomShadowTextureRGB;

// Outline
uniform int _UseOutline;
UNITY_DECLARE_TEX2D_NOSAMPLER(_OutlineMask); uniform float4 _OutlineMask_ST;
uniform float _OutlineCutoffRange;
uniform float _OutlineTextureColorRate;
uniform float _OutlineShadeMix;
uniform float _OutlineWidth;
uniform float4 _OutlineColor;
uniform sampler2D _OutlineTexture; uniform float4 _OutlineTexture_ST;
uniform sampler2D _OutlineWidthMask; uniform float4 _OutlineWidthMask_ST; // FIXME:tex2dLodはUNITY_SAMPLE_TEX2D_SAMPLERの代用が判らないためいったん保留
uniform float _OutlineUseColorShift;
uniform float _OutlineHueShiftFromBase;
uniform float _OutlineSaturationFromBase;
uniform float _OutlineValueFromBase;

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
uniform float _PointShadowUseStep;
uniform int _PointShadowSteps;

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
uniform float _RimFresnelPower;
uniform float _RimUpperSideWidth;
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

// Use vertexLight
uniform int _UseVertexLight;

// Vertex Color Blend
uniform float _VertexColorBlendDiffuse;
uniform float _VertexColorBlendEmissive;

// Shade from other objects.
uniform float _OtherShadowAdjust;
uniform float _OtherShadowBorderSharpness;

// Experimental Cap calculation
uniform int _UsePositionRelatedCalc;

// light sampling
uniform int _LightSampling;

// Refraction IF refracted
#ifdef GAMINGEFFECT_REFRACTED
uniform sampler2D _GrabTexture;
uniform float _RefractionFresnelExp;
uniform float _RefractionStrength;
#endif

// ScrolledEmission
#ifdef GAMINGEFFECT_EMISSIVE_FREAK
uniform int _EmissiveFreak1UVMap;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1Tex); uniform float4 _EmissiveFreak1Tex_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1Tex2); uniform float4 _EmissiveFreak1Tex2_ST;
uniform float _EmissiveFreak1TexTransitionSpeed;
uniform float4 _EmissiveFreak1Color;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1ColorGradientTex); uniform float4 _EmissiveFreak1ColorGradientTex_ST;
uniform float _EmissiveFreak1ColorChangeSpeed;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1Mask); uniform float4 _EmissiveFreak1Mask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1Mask2); uniform float4 _EmissiveFreak1Mask2_ST;
uniform float _EmissiveFreak1MaskTransitionSpeed;
uniform float _EmissiveFreak1U;
uniform float _EmissiveFreak1USinAmp;
uniform float _EmissiveFreak1USinFreq;
uniform float _EmissiveFreak1V;
uniform float _EmissiveFreak1VSinAmp;
uniform float _EmissiveFreak1VSinFreq;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1ScrollMask); uniform float4 _EmissiveFreak1ScrollMask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak1ScrollMask2); uniform float4 _EmissiveFreak1ScrollMask2_ST;
uniform float _EmissiveFreak1ScrollMaskTransitionSpeed;
uniform float _EmissiveFreak1MaskU;
uniform float _EmissiveFreak1MaskUSinAmp;
uniform float _EmissiveFreak1MaskUSinFreq;
uniform float _EmissiveFreak1MaskV;
uniform float _EmissiveFreak1MaskVSinAmp;
uniform float _EmissiveFreak1MaskVSinFreq;
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



uniform int _EmissiveFreak2UVMap;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2Tex); uniform float4 _EmissiveFreak2Tex_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2Tex2); uniform float4 _EmissiveFreak2Tex2_ST;
uniform float _EmissiveFreak2TexTransitionSpeed;
uniform float4 _EmissiveFreak2Color;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2ColorGradientTex); uniform float4 _EmissiveFreak2ColorGradientTex_ST;
uniform float _EmissiveFreak2ColorChangeSpeed;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2Mask); uniform float4 _EmissiveFreak2Mask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2Mask2); uniform float4 _EmissiveFreak2Mask2_ST;
uniform float _EmissiveFreak2MaskTransitionSpeed;
uniform float _EmissiveFreak2U;
uniform float _EmissiveFreak2USinAmp;
uniform float _EmissiveFreak2USinFreq;
uniform float _EmissiveFreak2V;
uniform float _EmissiveFreak2VSinAmp;
uniform float _EmissiveFreak2VSinFreq;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2ScrollMask); uniform float4 _EmissiveFreak2ScrollMask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak2ScrollMask2); uniform float4 _EmissiveFreak2ScrollMask2_ST;
uniform float _EmissiveFreak2ScrollMaskTransitionSpeed;
uniform float _EmissiveFreak2MaskU;
uniform float _EmissiveFreak2MaskUSinAmp;
uniform float _EmissiveFreak2MaskUSinFreq;
uniform float _EmissiveFreak2MaskV;
uniform float _EmissiveFreak2MaskVSinAmp;
uniform float _EmissiveFreak2MaskVSinFreq;
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



uniform int _EmissiveFreak3UVMap;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3Tex); uniform float4 _EmissiveFreak3Tex_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3Tex2); uniform float4 _EmissiveFreak3Tex2_ST;
uniform float _EmissiveFreak3TexTransitionSpeed;
uniform float4 _EmissiveFreak3Color;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3ColorGradientTex); uniform float4 _EmissiveFreak3ColorGradientTex_ST;
uniform float _EmissiveFreak3ColorChangeSpeed;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3Mask); uniform float4 _EmissiveFreak3Mask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3Mask2); uniform float4 _EmissiveFreak3Mask2_ST;
uniform float _EmissiveFreak3MaskTransitionSpeed;
uniform float _EmissiveFreak3U;
uniform float _EmissiveFreak3USinAmp;
uniform float _EmissiveFreak3USinFreq;
uniform float _EmissiveFreak3V;
uniform float _EmissiveFreak3VSinAmp;
uniform float _EmissiveFreak3VSinFreq;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3ScrollMask); uniform float4 _EmissiveFreak3ScrollMask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3ScrollMask2); uniform float4 _EmissiveFreak3ScrollMask2_ST;
uniform float _EmissiveFreak3ScrollMaskTransitionSpeed;
uniform float _EmissiveFreak3MaskU;
uniform float _EmissiveFreak3MaskUSinAmp;
uniform float _EmissiveFreak3MaskUSinFreq;
uniform float _EmissiveFreak3MaskV;
uniform float _EmissiveFreak3MaskVSinAmp;
uniform float _EmissiveFreak3MaskVSinFreq;
uniform float _EmissiveFreak3Depth;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak3DepthMask); uniform float4 _EmissiveFreak3DepthMask_ST;
uniform float _EmissiveFreak3DepthMaskInvert;
uniform float _EmissiveFreak3Breathing;
uniform float _EmissiveFreak3BreathingMix;
uniform float _EmissiveFreak3BlinkOut;
uniform float _EmissiveFreak3BlinkOutMix;
uniform float _EmissiveFreak3BlinkIn;
uniform float _EmissiveFreak3BlinkInMix;
uniform float _EmissiveFreak3HueShift;



uniform int _EmissiveFreak4UVMap;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4Tex); uniform float4 _EmissiveFreak4Tex_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4Tex2); uniform float4 _EmissiveFreak4Tex2_ST;
uniform float _EmissiveFreak4TexTransitionSpeed;
uniform float4 _EmissiveFreak4Color;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4ColorGradientTex); uniform float4 _EmissiveFreak4ColorGradientTex_ST;
uniform float _EmissiveFreak4ColorChangeSpeed;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4Mask); uniform float4 _EmissiveFreak4Mask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4Mask2); uniform float4 _EmissiveFreak4Mask2_ST;
uniform float _EmissiveFreak4MaskTransitionSpeed;
uniform float _EmissiveFreak4U;
uniform float _EmissiveFreak4USinAmp;
uniform float _EmissiveFreak4USinFreq;
uniform float _EmissiveFreak4V;
uniform float _EmissiveFreak4VSinAmp;
uniform float _EmissiveFreak4VSinFreq;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4ScrollMask); uniform float4 _EmissiveFreak4ScrollMask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4ScrollMask2); uniform float4 _EmissiveFreak4ScrollMask2_ST;
uniform float _EmissiveFreak4ScrollMaskTransitionSpeed;
uniform float _EmissiveFreak4MaskU;
uniform float _EmissiveFreak4MaskUSinAmp;
uniform float _EmissiveFreak4MaskUSinFreq;
uniform float _EmissiveFreak4MaskV;
uniform float _EmissiveFreak4MaskVSinAmp;
uniform float _EmissiveFreak4MaskVSinFreq;
uniform float _EmissiveFreak4Depth;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak4DepthMask); uniform float4 _EmissiveFreak4DepthMask_ST;
uniform float _EmissiveFreak4DepthMaskInvert;
uniform float _EmissiveFreak4Breathing;
uniform float _EmissiveFreak4BreathingMix;
uniform float _EmissiveFreak4BlinkOut;
uniform float _EmissiveFreak4BlinkOutMix;
uniform float _EmissiveFreak4BlinkIn;
uniform float _EmissiveFreak4BlinkInMix;
uniform float _EmissiveFreak4HueShift;



uniform int _EmissiveFreak5UVMap;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5Tex); uniform float4 _EmissiveFreak5Tex_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5Tex2); uniform float4 _EmissiveFreak5Tex2_ST;
uniform float _EmissiveFreak5TexTransitionSpeed;
uniform float4 _EmissiveFreak5Color;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5ColorGradientTex); uniform float4 _EmissiveFreak5ColorGradientTex_ST;
uniform float _EmissiveFreak5ColorChangeSpeed;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5Mask); uniform float4 _EmissiveFreak5Mask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5Mask2); uniform float4 _EmissiveFreak5Mask2_ST;
uniform float _EmissiveFreak5MaskTransitionSpeed;
uniform float _EmissiveFreak5U;
uniform float _EmissiveFreak5USinAmp;
uniform float _EmissiveFreak5USinFreq;
uniform float _EmissiveFreak5V;
uniform float _EmissiveFreak5VSinAmp;
uniform float _EmissiveFreak5VSinFreq;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5ScrollMask); uniform float4 _EmissiveFreak5ScrollMask_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5ScrollMask2); uniform float4 _EmissiveFreak5ScrollMask2_ST;
uniform float _EmissiveFreak5ScrollMaskTransitionSpeed;
uniform float _EmissiveFreak5MaskU;
uniform float _EmissiveFreak5MaskUSinAmp;
uniform float _EmissiveFreak5MaskUSinFreq;
uniform float _EmissiveFreak5MaskV;
uniform float _EmissiveFreak5MaskVSinAmp;
uniform float _EmissiveFreak5MaskVSinFreq;
uniform float _EmissiveFreak5Depth;
UNITY_DECLARE_TEX2D_NOSAMPLER(_EmissiveFreak5DepthMask); uniform float4 _EmissiveFreak5DepthMask_ST;
uniform float _EmissiveFreak5DepthMaskInvert;
uniform float _EmissiveFreak5Breathing;
uniform float _EmissiveFreak5BreathingMix;
uniform float _EmissiveFreak5BlinkOut;
uniform float _EmissiveFreak5BlinkOutMix;
uniform float _EmissiveFreak5BlinkIn;
uniform float _EmissiveFreak5BlinkInMix;
uniform float _EmissiveFreak5HueShift;


#endif