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



Shader "BeatSaber/GamingEffect/_Extra/EmissiveFreak/AlphaCutout" {
    Properties 
  { 
      [HideInInspector] shader_is_using_thry_editor("", Float)=0
        [HideInInspector] m_mainOptions ("Main", Float) = 0

          // Common
          [SmallTexture] _MainTex ("Main Texture", 2D) = "white" {}
          _Color ("  Base Color", Color) = (1,1,1,1)

          [Space(10)][SmallTexture][Normal] _BumpMap ("Normal Map", 2D) = "bump" {}
          _BumpScale ("  Normal scale", Range(0,2)) = 1

          [Space(10)][SmallTexture] _EmissionMap ("Emission", 2D) = "white" {}
          [HDR]_EmissionColor ("  Emission Color", Color) = (0,0,0,1)

          [Space(10)][Toggle(_)] _UseDoubleSided ("is Double Sided", Int ) = 0
          // Double Sided
          [HideInInspector] g_start_DoubleSided ("--{condition_show:{type:PROPERTY_BOOL,data:_UseDoubleSided}}", Float) = 0

            [Toggle(_)]_DoubleSidedFlipBackfaceNormal ("  Flip backface normal", Float ) = 0
            _DoubleSidedBackfaceLightIntensity ("  Backface Light intensity", Range(0, 2) ) = 0.5

            [Space(10)][Toggle(_)]_DoubleSidedBackfaceUseColorShift("  Use Backface Color Shift", Int) = 0
            [HideInInspector] g_start_DoubleSidedBackfaceUseColorShift ("--{condition_show:{type:PROPERTY_BOOL,data:_DoubleSidedBackfaceUseColorShift}}", Float) = 0
              [PowerSlider(2.0)]_DoubleSidedBackfaceHueShiftFromBase("    Hue Shift", Range(-0.5, 0.5)) = 0
              _DoubleSidedBackfaceSaturationFromBase("    Saturation", Range(0, 2)) = 1
              _DoubleSidedBackfaceValueFromBase("    Value", Range(0, 2)) = 1
            [HideInInspector] g_end_DoubleSidedBackfaceUseColorShift ("", Float) = 0

            //
            [HideInInspector] _ShadowCasterCulling("Shadow Caster Culling", Int) = 2 // None:0, Front:1, Back:2
          [HideInInspector] g_end_DoubleSided ("", Float) = 0

          [HideInInspector] m_start_AlphaCutout ("AlphaCutout", Float) = 0
            // Alpha Cutout(Cutout)
            _CutoutCutoutAdjust ("Cutoff Adjust", Range(0, 1)) = 0.5
          [HideInInspector] m_end_AlphaCutout ("AlphaCutout", Float) = 0

          // Shadow (received from DirectionalLight, other Indirect(baked) Lights, including SH)
          [HideInInspector] m_start_Shadow ("Shadow", Float) = 0
            _Shadowborder ("Border ", Range(0, 1)) = 0.6

            [Space(10)]_ShadowStrength ("Strength", Range(0, 1)) = 0.5
            _ShadowStrengthMask ("Strength Mask", 2D) = "white" {}

            [Space(10)]_ShadowborderBlur ("Border Blur", Range(0, 1)) = 0.05
            _ShadowborderBlurMask ("Border Blur Mask", 2D) = "white" {}

            // Shadow steps
            [Space(10)][Toggle(_)]_ShadowUseStep ("Use steps", Float ) = 0
            [HideInInspector] g_start_ShadowUseStep ("--{condition_show:{type:PROPERTY_BOOL,data:_ShadowUseStep}}", Float) = 0
              _ShadowSteps("  Steps", Range(2, 10)) = 4
            [HideInInspector] g_end_ShadowUseStep ("", Float) = 0

            // Plan B
            [Space(10)][Toggle(_)]_ShadowPlanBUsePlanB ("Use Custom Shade", Int ) = 0
            [HideInInspector] g_start_ShadowPlanBUsePlanB ("--{condition_show:{type:PROPERTY_BOOL,data:_ShadowPlanBUsePlanB}}", Float) = 0
              [Space(10)]_ShadowPlanBDefaultShadowMix ("  Mix Default Shade", Range(0, 1)) = 1

              [Space(10)][Toggle(_)] _ShadowPlanBUseCustomShadowTexture ("  Use Shade Texture", Int ) = 0
              [HideInInspector] g_start_ShadowPlanBUseCustomShadowTexture ("--{condition_show:{type:PROPERTY_BOOL,data:_ShadowPlanBUseCustomShadowTexture}}", Float) = 0
                _ShadowPlanBCustomShadowTexture ("Shade Texture", 2D) = "black" {}
                _ShadowPlanBCustomShadowTextureRGB ("  Shade Texture RGB", Color) = (1,1,1,1)
              [HideInInspector] g_end_ShadowPlanBUseCustomShadowTexture ("", Float) = 0
              [HideInInspector] g_start_ShadowPlanBUseCustomShadowHSV ("--{condition_show:{type:PROPERTY_BOOL,data:_ShadowPlanBUseCustomShadowTexture==0}}", Float) = 0
                [PowerSlider(2.0)]_ShadowPlanBHueShiftFromBase ("  Hue Shift", Range(-0.5, 0.5)) = 0
                _ShadowPlanBSaturationFromBase ("  Saturation", Range(0, 2)) = 1
                _ShadowPlanBValueFromBase ("  Value", Range(0, 2)) = 1
              [HideInInspector] g_end_ShadowPlanBUseCustomShadowHSV ("", Float) = 0

              // ShadowPlanB-2
              [Space(10)][Toggle(_)]_CustomShadow2nd ("  Use", Int ) = 0
              [HideInInspector] g_start_CustomShadow2nd ("--{condition_show:{type:PROPERTY_BOOL,data:_CustomShadow2nd}}", Float) = 0
                _ShadowPlanB2border ("    Border", Range(0, 1)) = 0.55
                _ShadowPlanB2borderBlur ("    Blur", Range(0, 1)) = 0.55
                [Space(10)][Toggle(_)] _ShadowPlanB2UseCustomShadowTexture ("    Use Shade Texture", Int ) = 0
                [HideInInspector] g_start_ShadowPlanB2UseCustomShadowTexture ("--{condition_show:{type:PROPERTY_BOOL,data:_ShadowPlanB2UseCustomShadowTexture}}", Float) = 0
                  _ShadowPlanB2CustomShadowTexture ("Shade Texture", 2D) = "black" {}
                  _ShadowPlanB2CustomShadowTextureRGB ("    Shade Texture RGB", Color) = (1,1,1,1)
                [HideInInspector] g_end_ShadowPlanB2UseCustomShadowTexture ("", Float) = 0
                [HideInInspector] g_start_ShadowPlanB2UseCustomShadowHSV ("--{condition_show:{type:PROPERTY_BOOL,data:_ShadowPlanB2UseCustomShadowTexture==0}}", Float) = 0
                  [PowerSlider(2.0)]_ShadowPlanB2HueShiftFromBase ("    Hue Shift", Range(-0.5, 0.5)) = 0
                  _ShadowPlanB2SaturationFromBase ("    Saturation", Range(0, 2)) = 1
                  _ShadowPlanB2ValueFromBase ("    Value", Range(0, 2)) = 1
                [HideInInspector] g_end_ShadowPlanB2UseCustomShadowHSV ("", Float) = 0
              [HideInInspector] g_end_CustomShadow2nd ("", Float) = 0
            [HideInInspector] g_end_ShadowPlanBUsePlanB ("", Float) = 0
          [HideInInspector] m_end_Shadow ("Shadow", Float) = 0

          // Gloss
          [HideInInspector] m_start_Gloss ("Gloss", Float) = 0
            [Toggle(_)]_UseGloss ("Enabled", Int) = 0
            [HideInInspector] g_start_UseGloss ("--{condition_show:{type:PROPERTY_BOOL,data:_UseGloss}}", Float) = 0
              _GlossBlend ("  Smoothness", Range(0, 1)) = 0.5
              _GlossBlendMask ("Smoothness Mask", 2D) = "white" {}
              [Space(10)]_GlossPower ("  Metallic", Range(0, 1)) = 0.5
              _GlossColor ("  Color", Color) = (1,1,1,1)
            [HideInInspector] g_end_UseGloss ("", Float) = 0
          [HideInInspector] m_end_Gloss ("Gloss", Float) = 0
          
          // Outline
          [HideInInspector] m_start_Outline ("Outline", Float) = 0
            [Toggle(_)]_UseOutline ("Enabled", Int) = 0
            [HideInInspector] g_start_UseOutline ("--{condition_show:{type:PROPERTY_BOOL,data:_UseOutline}}", Float) = 0
              _OutlineWidth ("Width", Range(0, 20)) = 0.1
              _OutlineWidthMask ("Width Mask", 2D) = "white" {}

              [Space(10)]_OutlineTexture ("Texture", 2D) = "white" {}
              _OutlineColor ("Color", Color) = (0,0,0,1)
              _OutlineTextureColorRate ("Base Color Mix", Range(0, 1)) = 0.05
              
              [Space(10)][Toggle(_)]_OutlineUseColorShift("Use Color Shift", Int) = 0
              [HideInInspector] g_start_OutlineUseColorShift ("--{condition_show:{type:PROPERTY_BOOL,data:_OutlineUseColorShift}}", Float) = 0
                [PowerSlider(2.0)]_OutlineHueShiftFromBase("    Hue Shift", Range(-0.5, 0.5)) = 0
                _OutlineSaturationFromBase("    Saturation", Range(0, 2)) = 1
                _OutlineValueFromBase("    Value", Range(0, 2)) = 1
              [HideInInspector] g_end_OutlineUseColorShift ("", Float) = 0
              
              [Space(10)]_OutlineShadeMix ("Shadow Mix", Range(0, 1)) = 0
            [HideInInspector] g_end_UseOutline ("", Float) = 0
          [HideInInspector] m_end_Outline ("Outline", Float) = 0

          // MatCap
          [HideInInspector] m_start_MatCap ("MatCap", Float) = 0
            [Enum(Add,0, Lighten,1, Screen,2, Unused,3)] _MatcapBlendMode ("Blend Mode", Int) = 3
            [HideInInspector] g_start_MatcapBlendMode ("--{condition_show:{type:PROPERTY_BOOL,data:_MatcapBlendMode!=3}}", Float) = 0
              _MatcapBlend ("  Blend", Range(0, 3)) = 1
              _MatcapBlendMask ("Blend Mask", 2D) = "white" {}

              [Space(10)]_MatcapTexture ("Texture", 2D) = "black" {}
              _MatcapColor ("  Color", Color) = (1,1,1,1)

              [Space(10)]_MatcapNormalMix ("  Normal map mix", Range(0, 2)) = 1
              _MatcapShadeMix ("  Shadow Mix", Range(0, 1)) = 0
            [HideInInspector] g_end_MatcapBlendMode ("", Float) = 0
          [HideInInspector] m_end_MatCap ("MatCap", Float) = 0

          // Reflection
          [HideInInspector] m_start_Reflection ("Reflection", Float) = 0
            [Toggle(_)]_UseReflection ("Enabled", Int) = 0
            [HideInInspector] g_start_UseReflection ("--{condition_show:{type:PROPERTY_BOOL,data:_UseReflection}}", Float) = 0
              [Toggle(_)]_UseReflectionProbe ("Use Reflection Probe", Int) = 1

              [Space(10)]_ReflectionReflectionPower ("  Smoothness", Range(0, 1)) = 1
              _ReflectionReflectionMask ("Smoothness Mask", 2D) = "white" {}

              [Space(10)]_ReflectionCubemap ("Cubemap", Cube) = "" {}

              [Space(10)]_ReflectionNormalMix ("  Normal Map Mix", Range(0,2)) = 1
              _ReflectionShadeMix ("  Shadow Mix", Range(0, 1)) = 0
              _ReflectionSuppressBaseColorValue ("  Suppress Base Color", Range(0, 1)) = 1
            [HideInInspector] g_end_UseReflection ("", Float) = 0
          [HideInInspector] m_end_Reflection ("Reflection", Float) = 0

          // Rim
          [HideInInspector] m_start_Rim ("Rim", Float) = 0
            [Toggle(_)]_UseRim ("Enabled", Int) = 0
            [HideInInspector] g_start_Rim ("--{condition_show:{type:PROPERTY_BOOL,data:_UseRim}}", Float) = 0
              _RimBlend ("  Blend", Range(0, 3)) = 1
              _RimBlendMask ("Blend Mask", 2D) = "white" {}
              
              [Space(10)]_RimTexture ("Texture", 2D) = "white" {}
              [HDR]_RimColor ("  Color", Color) = (1,1,1,1)

              [Space(10)][Toggle(_)] _RimUseBaseTexture ("  Use Base Color", Float ) = 0
                            
              [Space(10)]_RimShadeMix("  Shadow Mix", Range(0, 1)) = 0
              [PowerSlider(3.0)]_RimFresnelPower ("  Fresnel Power", Range(0, 200)) = 1
              _RimUpperSideWidth("  Upper side width", Range(0, 1)) = 0
            [HideInInspector] g_end_Rim ("", Float) = 0
          [HideInInspector] m_end_Rim ("Rim", Float) = 0

          // ShadowCap
          [HideInInspector] m_start_ShadowCap ("Shade Cap", Float) = 0
            [Enum(Darken,0, Multiply,1, Light Shutter,2, Unused,3)] _ShadowCapBlendMode ("Blend Mode", Int) = 3
            [HideInInspector] g_start_ShadowCapBlendMode ("--{condition_show:{type:PROPERTY_BOOL,data:_ShadowCapBlendMode!=3}}", Float) = 0
              _ShadowCapBlend ("  Blend", Range(0, 3)) = 1
              _ShadowCapBlendMask ("Blend Mask", 2D) = "white" {}

              [Space(10)]_ShadowCapTexture ("Texture", 2D) = "white" {}

              [Space(10)]_ShadowCapNormalMix ("  Normal map mix", Range(0, 2)) = 1
            [HideInInspector] g_end_ShadowCapBlendMode ("", Float) = 0
          [HideInInspector] m_end_ShadowCap ("ShadowCap", Float) = 0

        [HideInInspector] m_mainOptions ("Emission", Float) = 0
          // Emission Parallax
          [HideInInspector] m_start_EmissionParallax ("Emission Parallax", Float) = 0
            [Toggle(_)]_UseEmissionParallax ("Enabled", Int ) = 0
            [HideInInspector] g_start_UseEmissionParallax ("--{condition_show:{type:PROPERTY_BOOL,data:_UseEmissionParallax}}", Float) = 0
              _EmissionParallaxTex ("Texture", 2D ) = "black" {}
              [HDR]_EmissionParallaxColor ("  Color", Color ) = (1,1,1,1)
              
              [Space(10)]_EmissionParallaxMask ("Emission Mask", 2D ) = "white" {}
              
              [Space(10)]_EmissionParallaxDepth ("  Depth", Range(-1, 1) ) = 0
              _EmissionParallaxDepthMask ("Depth Mask", 2D ) = "white" {}
              
              [Space(10)][Toggle(_)]_EmissionParallaxDepthMaskInvert ("  Invert Depth Mask", Float ) = 0
            [HideInInspector] g_end_UseEmissionParallax ("", Float) = 0
          [HideInInspector] m_end_EmissionParallax ("Emission Parallax", Float) = 0

          // EmissiveFreak
          [HideInInspector] m_start_EmissiveFreak ("EmissiveFreak", Float) = 0
            [HideInInspector] m_start_EmissiveFreak1 ("EmissiveFreak1", Float) = 0
              [Enum(UV0, 0, UV1, 1)]_EmissiveFreak1UVMap ("    UV Map", Int) = 0
              _EmissiveFreak1Tex ("Texture", 2D ) = "white" {}
              _EmissiveFreak1Tex2 ("Texture2", 2D ) = "white" {}
              _EmissiveFreak1TexTransitionSpeed ("    Tex Transition Speed", Float ) = 0

              [Space(10)][HDR]_EmissiveFreak1Color ("    Base Color", Color ) = (0,0,0,1)
              [Gradient]_EmissiveFreak1ColorGradientTex ("Gradient Color --{texture:{width:512,height:16,filterMode:Point,wrapMode:Repeat}}", 2D ) = "white" { }
              _EmissiveFreak1ColorChangeSpeed ("    Color Change Speed", Float ) = 0

              [Space(10)]_EmissiveFreak1Mask ("Mask", 2D ) = "white" {}
              _EmissiveFreak1Mask2 ("Mask2", 2D ) = "white" {}
              _EmissiveFreak1MaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak1U ("    Base U Scroll", Float ) = 0
              _EmissiveFreak1USinAmp ("    U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak1USinFreq ("    U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak1V ("    Base V Scroll", Float ) = 0
              _EmissiveFreak1VSinAmp ("    V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak1VSinFreq ("    V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak1ScrollMask ("Scroll Mask", 2D ) = "white" {}
              [Space(10)]_EmissiveFreak1ScrollMask2 ("Scroll Mask2", 2D ) = "white" {}
              _EmissiveFreak1ScrollMaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak1MaskU ("    Base Mask U Scroll", Float ) = 0
              _EmissiveFreak1MaskUSinAmp ("    Mask U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak1MaskUSinFreq ("    Mask U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak1MaskV ("    Base Mask V Scroll", Float ) = 0
              _EmissiveFreak1MaskVSinAmp ("    Mask V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak1MaskVSinFreq ("    Mask V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak1Depth ("    Depth", Range(-1, 1) ) = 0
              _EmissiveFreak1DepthMask ("Depth Mask", 2D ) = "white" {}
              [Toggle(_)]_EmissiveFreak1DepthMaskInvert ("    Invert Depth Mask", Float ) = 0

              [Space(10)]_EmissiveFreak1Breathing ("  Breathing", Float ) = 0
              _EmissiveFreak1BreathingMix ("  Breathing Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak1BlinkOut ("  Blink Out", Float ) = 0
              _EmissiveFreak1BlinkOutMix ("  Blink Out Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak1BlinkIn ("  Blink In", Float ) = 0
              _EmissiveFreak1BlinkInMix ("  Blink In Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak1HueShift ("  Hue Shift", Float ) = 0

            [HideInInspector] m_end_EmissiveFreak1 ("EmissiveFreak", Float) = 0



            [HideInInspector] m_start_EmissiveFreak2 ("EmissiveFreak2", Float) = 0
              [Enum(UV0, 0, UV1, 1)]_EmissiveFreak2UVMap ("    UV Map", Int) = 0
              _EmissiveFreak2Tex ("Texture", 2D ) = "white" {}
              _EmissiveFreak2Tex2 ("Texture2", 2D ) = "white" {}
              _EmissiveFreak2TexTransitionSpeed ("    Tex Transition Speed", Float ) = 0

              [Space(10)][HDR]_EmissiveFreak2Color ("    Base Color", Color ) = (0,0,0,1)
              [Gradient]_EmissiveFreak2ColorGradientTex ("Gradient Color --{texture:{width:512,height:16,filterMode:Point,wrapMode:Repeat}}", 2D ) = "white" { }
              _EmissiveFreak2ColorChangeSpeed ("    Color Change Speed", Float ) = 0

              [Space(10)]_EmissiveFreak2Mask ("Mask", 2D ) = "white" {}
              _EmissiveFreak2Mask2 ("Mask2", 2D ) = "white" {}
              _EmissiveFreak2MaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak2U ("    Base U Scroll", Float ) = 0
              _EmissiveFreak2USinAmp ("    U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak2USinFreq ("    U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak2V ("    Base V Scroll", Float ) = 0
              _EmissiveFreak2VSinAmp ("    V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak2VSinFreq ("    V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak2ScrollMask ("Scroll Mask", 2D ) = "white" {}
              [Space(10)]_EmissiveFreak2ScrollMask2 ("Scroll Mask2", 2D ) = "white" {}
              _EmissiveFreak2ScrollMaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak2MaskU ("    Base Mask U Scroll", Float ) = 0
              _EmissiveFreak2MaskUSinAmp ("    Mask U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak2MaskUSinFreq ("    Mask U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak2MaskV ("    Base Mask V Scroll", Float ) = 0
              _EmissiveFreak2MaskVSinAmp ("    Mask V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak2MaskVSinFreq ("    Mask V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak2Depth ("    Depth", Range(-1, 1) ) = 0
              _EmissiveFreak2DepthMask ("Depth Mask", 2D ) = "white" {}
              [Toggle(_)]_EmissiveFreak2DepthMaskInvert ("    Invert Depth Mask", Float ) = 0

              [Space(10)]_EmissiveFreak2Breathing ("  Breathing", Float ) = 0
              _EmissiveFreak2BreathingMix ("  Breathing Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak2BlinkOut ("  Blink Out", Float ) = 0
              _EmissiveFreak2BlinkOutMix ("  Blink Out Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak2BlinkIn ("  Blink In", Float ) = 0
              _EmissiveFreak2BlinkInMix ("  Blink In Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak2HueShift ("  Hue Shift", Float ) = 0

            [HideInInspector] m_end_EmissiveFreak2 ("EmissiveFreak", Float) = 0



            [HideInInspector] m_start_EmissiveFreak3 ("EmissiveFreak3", Float) = 0
              [Enum(UV0, 0, UV1, 1)]_EmissiveFreak3UVMap ("    UV Map", Int) = 0
              _EmissiveFreak3Tex ("Texture", 2D ) = "white" {}
              _EmissiveFreak3Tex2 ("Texture2", 2D ) = "white" {}
              _EmissiveFreak3TexTransitionSpeed ("    Tex Transition Speed", Float ) = 0

              [Space(10)][HDR]_EmissiveFreak3Color ("    Base Color", Color ) = (0,0,0,1)
              [Gradient]_EmissiveFreak3ColorGradientTex ("Gradient Color --{texture:{width:512,height:16,filterMode:Point,wrapMode:Repeat}}", 2D ) = "white" { }
              _EmissiveFreak3ColorChangeSpeed ("    Color Change Speed", Float ) = 0

              [Space(10)]_EmissiveFreak3Mask ("Mask", 2D ) = "white" {}
              _EmissiveFreak3Mask2 ("Mask2", 2D ) = "white" {}
              _EmissiveFreak3MaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak3U ("    Base U Scroll", Float ) = 0
              _EmissiveFreak3USinAmp ("    U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak3USinFreq ("    U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak3V ("    Base V Scroll", Float ) = 0
              _EmissiveFreak3VSinAmp ("    V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak3VSinFreq ("    V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak3ScrollMask ("Scroll Mask", 2D ) = "white" {}
              [Space(10)]_EmissiveFreak3ScrollMask2 ("Scroll Mask2", 2D ) = "white" {}
              _EmissiveFreak3ScrollMaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak3MaskU ("    Base Mask U Scroll", Float ) = 0
              _EmissiveFreak3MaskUSinAmp ("    Mask U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak3MaskUSinFreq ("    Mask U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak3MaskV ("    Base Mask V Scroll", Float ) = 0
              _EmissiveFreak3MaskVSinAmp ("    Mask V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak3MaskVSinFreq ("    Mask V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak3Depth ("    Depth", Range(-1, 1) ) = 0
              _EmissiveFreak3DepthMask ("Depth Mask", 2D ) = "white" {}
              [Toggle(_)]_EmissiveFreak3DepthMaskInvert ("    Invert Depth Mask", Float ) = 0

              [Space(10)]_EmissiveFreak3Breathing ("  Breathing", Float ) = 0
              _EmissiveFreak3BreathingMix ("  Breathing Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak3BlinkOut ("  Blink Out", Float ) = 0
              _EmissiveFreak3BlinkOutMix ("  Blink Out Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak3BlinkIn ("  Blink In", Float ) = 0
              _EmissiveFreak3BlinkInMix ("  Blink In Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak3HueShift ("  Hue Shift", Float ) = 0

            [HideInInspector] m_end_EmissiveFreak3 ("EmissiveFreak", Float) = 0



            [HideInInspector] m_start_EmissiveFreak4 ("EmissiveFreak4", Float) = 0
              [Enum(UV0, 0, UV1, 1)]_EmissiveFreak4UVMap ("    UV Map", Int) = 0
              _EmissiveFreak4Tex ("Texture", 2D ) = "white" {}
              _EmissiveFreak4Tex2 ("Texture2", 2D ) = "white" {}
              _EmissiveFreak4TexTransitionSpeed ("    Tex Transition Speed", Float ) = 0

              [Space(10)][HDR]_EmissiveFreak4Color ("    Base Color", Color ) = (0,0,0,1)
              [Gradient]_EmissiveFreak4ColorGradientTex ("Gradient Color --{texture:{width:512,height:16,filterMode:Point,wrapMode:Repeat}}", 2D ) = "white" { }
              _EmissiveFreak4ColorChangeSpeed ("    Color Change Speed", Float ) = 0

              [Space(10)]_EmissiveFreak4Mask ("Mask", 2D ) = "white" {}
              _EmissiveFreak4Mask2 ("Mask2", 2D ) = "white" {}
              _EmissiveFreak4MaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak4U ("    Base U Scroll", Float ) = 0
              _EmissiveFreak4USinAmp ("    U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak4USinFreq ("    U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak4V ("    Base V Scroll", Float ) = 0
              _EmissiveFreak4VSinAmp ("    V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak4VSinFreq ("    V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak4ScrollMask ("Scroll Mask", 2D ) = "white" {}
              [Space(10)]_EmissiveFreak4ScrollMask2 ("Scroll Mask2", 2D ) = "white" {}
              _EmissiveFreak4ScrollMaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak4MaskU ("    Base Mask U Scroll", Float ) = 0
              _EmissiveFreak4MaskUSinAmp ("    Mask U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak4MaskUSinFreq ("    Mask U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak4MaskV ("    Base Mask V Scroll", Float ) = 0
              _EmissiveFreak4MaskVSinAmp ("    Mask V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak4MaskVSinFreq ("    Mask V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak4Depth ("    Depth", Range(-1, 1) ) = 0
              _EmissiveFreak4DepthMask ("Depth Mask", 2D ) = "white" {}
              [Toggle(_)]_EmissiveFreak4DepthMaskInvert ("    Invert Depth Mask", Float ) = 0

              [Space(10)]_EmissiveFreak4Breathing ("  Breathing", Float ) = 0
              _EmissiveFreak4BreathingMix ("  Breathing Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak4BlinkOut ("  Blink Out", Float ) = 0
              _EmissiveFreak4BlinkOutMix ("  Blink Out Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak4BlinkIn ("  Blink In", Float ) = 0
              _EmissiveFreak4BlinkInMix ("  Blink In Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak4HueShift ("  Hue Shift", Float ) = 0

            [HideInInspector] m_end_EmissiveFreak4 ("EmissiveFreak", Float) = 0



            [HideInInspector] m_start_EmissiveFreak5 ("EmissiveFreak5", Float) = 0
              [Enum(UV0, 0, UV1, 1)]_EmissiveFreak5UVMap ("    UV Map", Int) = 0
              _EmissiveFreak5Tex ("Texture", 2D ) = "white" {}
              _EmissiveFreak5Tex2 ("Texture2", 2D ) = "white" {}
              _EmissiveFreak5TexTransitionSpeed ("    Tex Transition Speed", Float ) = 0

              [Space(10)][HDR]_EmissiveFreak5Color ("    Base Color", Color ) = (0,0,0,1)
              [Gradient]_EmissiveFreak5ColorGradientTex ("Gradient Color --{texture:{width:512,height:16,filterMode:Point,wrapMode:Repeat}}", 2D ) = "white" { }
              _EmissiveFreak5ColorChangeSpeed ("    Color Change Speed", Float ) = 0

              [Space(10)]_EmissiveFreak5Mask ("Mask", 2D ) = "white" {}
              _EmissiveFreak5Mask2 ("Mask2", 2D ) = "white" {}
              _EmissiveFreak5MaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak5U ("    Base U Scroll", Float ) = 0
              _EmissiveFreak5USinAmp ("    U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak5USinFreq ("    U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak5V ("    Base V Scroll", Float ) = 0
              _EmissiveFreak5VSinAmp ("    V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak5VSinFreq ("    V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak5ScrollMask ("Scroll Mask", 2D ) = "white" {}
              [Space(10)]_EmissiveFreak5ScrollMask2 ("Scroll Mask2", 2D ) = "white" {}
              _EmissiveFreak5ScrollMaskTransitionSpeed ("    Mask Transition Speed", Float ) = 0

              [Space(10)]_EmissiveFreak5MaskU ("    Base Mask U Scroll", Float ) = 0
              _EmissiveFreak5MaskUSinAmp ("    Mask U Scroll Sin Amp", Float ) = 0
              _EmissiveFreak5MaskUSinFreq ("    Mask U Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak5MaskV ("    Base Mask V Scroll", Float ) = 0
              _EmissiveFreak5MaskVSinAmp ("    Mask V Scroll Sin Amp", Float ) = 0
              _EmissiveFreak5MaskVSinFreq ("    Mask V Scroll Sin Freq", Float ) = 0

              [Space(10)]_EmissiveFreak5Depth ("    Depth", Range(-1, 1) ) = 0
              _EmissiveFreak5DepthMask ("Depth Mask", 2D ) = "white" {}
              [Toggle(_)]_EmissiveFreak5DepthMaskInvert ("    Invert Depth Mask", Float ) = 0

              [Space(10)]_EmissiveFreak5Breathing ("  Breathing", Float ) = 0
              _EmissiveFreak5BreathingMix ("  Breathing Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak5BlinkOut ("  Blink Out", Float ) = 0
              _EmissiveFreak5BlinkOutMix ("  Blink Out Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak5BlinkIn ("  Blink In", Float ) = 0
              _EmissiveFreak5BlinkInMix ("  Blink In Mix", Range(0, 1) ) = 0
              [Space(10)]_EmissiveFreak5HueShift ("  Hue Shift", Float ) = 0

            [HideInInspector] m_end_EmissiveFreak5 ("EmissiveFreak", Float) = 0
          [HideInInspector] m_end_EmissiveFreak ("EmissiveFreak", Float) = 0

        [HideInInspector] m_mainOptions ("Advanced / Experimental", Float) = 0
        // Advanced / Experimental

          // Light Sampling
          [Enum(Arktoon,0, Cubed,1)]_LightSampling("[Light] Sampling Style", Int) = 0
        
          // Directional Shadow
          _ShadowIndirectIntensity ("Indirect face Intensity (0.25)", Range(0,0.5)) = 0.25

          // vertex color blend
          _VertexColorBlendDiffuse ("[VertexColor] Blend to diffuse", Range(0,1)) = 0
          _VertexColorBlendEmissive ("[VertexColor] Blend to emissive", Range(0,1)) = 0

          // PointShadow (received from Point/Spot Lights as Pixel/Vertex Lights)
          _PointAddIntensity ("[PointShadow] Light Intensity", Range(0,1)) = 1
          _PointShadowStrength ("[PointShadow] Strength", Range(0, 1)) = 0.5
          _PointShadowborder ("[PointShadow] border ", Range(0, 1)) = 0.5
          _PointShadowborderBlur ("[PointShadow] border Blur", Range(0, 1)) = 0.01
          _PointShadowborderBlurMask ("[PointShadow] border Blur Mask", 2D) = "white" {}
          [Toggle(_)]_PointShadowUseStep ("[PointShadow] use step", Float ) = 0
          _PointShadowSteps("[PointShadow] steps between borders", Range(2, 10)) = 2
          // Per-vertex light switching
          [Toggle(_)]_UseVertexLight("[Advanced] Use Per-vertex Lighting", Int) = 1

          // advanced tweaking
          _OtherShadowAdjust ("[Advanced] Other Mesh Shadow Adjust", Range(-0.2, 0.2)) = -0.1
          _OtherShadowBorderSharpness ("[Advanced] Other Mesh Shadow Border Sharpness", Range(1, 5)) = 3

          // Legacy MatCap/ShadeCap Calculation
          [Toggle(_)]_UsePositionRelatedCalc ("[Mat/ShadowCap] Use Position Related Calc (Experimental)", Int) = 0
          
        [SToggle]
		_EnableGeometry     ("Enable Geometry"					, int) = 0
		_Destruction		("Destruction"						, Range(0,1))= 0.0
		_ScaleFactor		("Scale Factor"						, Range(0,1))= 0.0
		_RotationFactor		("Rotation Factor"					, Range(0,1))= 0.0
		_PositionFactor		("Position Factor"					, Range(0,1))= 0.0
		_PositionAdd		("Position AddPoint"				, Range(-1,1))= 0.0

        // Version
        [HideInInspector]_Version("[hidden] Version", int) = 0
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType" = "TransparentCutout"
            "IgnoreProjector"="True"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Back

            CGPROGRAM


            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 4.0
            #define GAMINGEFFECT_CUTOUT
            #define GAMINGEFFECT_EMISSIVE_FREAK

            #include "cginc/gesDecl.cginc"
            #include "cginc/gesOther.cginc"
            #include "cginc/gesVertGeom.cginc"
            #include "cginc/gesFrag.cginc"
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Cull Back
            Blend One One

            CGPROGRAM

            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 4.0
            #define GAMINGEFFECT_CUTOUT
            #define GAMINGEFFECT_ADD

            #include "cginc/gesDecl.cginc"
            #include "cginc/gesOther.cginc"
            #include "cginc/gesVertGeom.cginc"
            #include "cginc/gesAdd.cginc"
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull [_ShadowCasterCulling]

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 4.0
            uniform float _CutoutCutoutAdjust;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _Color;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                clip((_MainTex_var.a * _Color.a) - _CutoutCutoutAdjust);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }

        
        Pass {
            Name "AlphaOff_Reiya_BS"
            Blend Zero One,One Zero //Alphaだけ上書き
            Cull Off
            ZWrite Off

            CGPROGRAM


            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles
            #pragma target 4.0
            #define GAMINGEFFECT_CUTOUT
            #define GAMINGEFFECT_EMISSIVE_FREAK

            #include "cginc/gesDecl.cginc"
            #include "cginc/gesOther.cginc"
            #include "cginc/gesVertGeom.cginc"
            #include "cginc/gesFrag_AlphaOff.cginc"
            ENDCG
        }
    }
    FallBack "Standard"

CustomEditor "ThryEditor_For_GES"
}
