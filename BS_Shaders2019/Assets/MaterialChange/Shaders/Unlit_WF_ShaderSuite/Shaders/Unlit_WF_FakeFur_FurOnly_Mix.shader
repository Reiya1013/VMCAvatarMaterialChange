﻿/*
 *  The MIT License
 *
 *  Copyright 2018-2022 whiteflare.
 *  Copyright 2021 ma1on.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 *  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
Shader "BeatSaber/UnlitWF/WF_FakeFur_FurOnly_Mix" {

    Properties {
        // 基本
        [WFHeader(Base)]
            _MainTex                ("Main Texture", 2D) = "white" {}
        [HDR]
            _Color                  ("Color", Color) = (1, 1, 1, 1)
            _Cutoff                 ("Alpha CutOff Level", Range(0, 1)) = 0.2
        [Toggle(_)]
            _AL_AlphaToMask         ("Alpha-To-Coverage (use MSAA)", Float) = 0

        // ファー設定
        [WFHeader(Fake Fur)]
            _FR_Height              ("[FR] Fur Height (Cutout)", Range(0, 0.2)) = 0.04
            _FR_Height2             ("[FR] Fur Height (Transparent)", Range(0, 0.2)) = 0.05
        [IntRange]
            _FR_Repeat              ("[FR] Fur Repeat (Cutout)", Range(1, 6)) = 3
        [IntRange]
            _FR_Repeat2             ("[FR] Fur Repeat (Transparent)", Range(1, 6)) = 2
        [Header(Fur Shape)]
            _FR_NoiseTex            ("[FR] Fur Noise Texture", 2D) = "white" {}
        [WF_Vector3]
            _FR_Vector              ("[FR] Fur Vector", Vector) = (0, 0, 1, 0)
        [NoScaleOffset]
        [Normal]
            _FR_BumpMap             ("[FR] NormalMap Texture", 2D) = "bump" {}
        [Enum(NONE,0,X,1,Y,2,XY,3)]
            _FR_FlipMirror          ("[FR] Flip Mirror", Float) = 0
        [Header(Fur Color)]
            _FR_ShadowPower         ("[FR] Fur ShadowPower", Range(0, 1)) = 0
            _FR_TintColorBase       ("[FR] Tint Color (Base)", Color) = (1, 1, 1, 1)
            _FR_TintColorTip        ("[FR] Tint Color (Tip)", Color) = (1, 1, 1, 1)
        [Header(Fur Mask Texture)]
        [NoScaleOffset]
            _FR_MaskTex             ("[FR] Mask Texture", 2D) = "white" {}
        [Toggle(_)]
            _FR_InvMaskVal          ("[FR] Invert Mask Value", Range(0, 1)) = 0

        // 色変換
        [WFHeaderToggle(Color Change)]
            _CL_Enable              ("[CL] Enable", Float) = 0
        [Toggle(_)]
            _CL_Monochrome          ("[CL] monochrome", Range(0, 1)) = 0
            _CL_DeltaH              ("[CL] Hur", Range(0, 1)) = 0
            _CL_DeltaS              ("[CL] Saturation", Range(-1, 1)) = 0
            _CL_DeltaV              ("[CL] Brightness", Range(-1, 1)) = 0

        // 階調影
        [WFHeaderToggle(ToonShade)]
            _TS_Enable              ("[SH] Enable", Float) = 0
        [IntRange]
            _TS_Steps               ("[SH] Steps", Range(1, 3)) = 2
            _TS_BaseColor           ("[SH] Base Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]
            _TS_BaseTex             ("[SH] Base Shade Texture", 2D) = "white" {}
            _TS_1stColor            ("[SH] 1st Shade Color", Color) = (0.81, 0.81, 0.9, 1)
        [NoScaleOffset]
            _TS_1stTex              ("[SH] 1st Shade Texture", 2D) = "white" {}
            _TS_2ndColor            ("[SH] 2nd Shade Color", Color) = (0.68, 0.68, 0.8, 1)
        [NoScaleOffset]
            _TS_2ndTex              ("[SH] 2nd Shade Texture", 2D) = "white" {}
            _TS_3rdColor            ("[SH] 3rd Shade Color", Color) = (0.595, 0.595, 0.7, 1)
        [NoScaleOffset]
            _TS_3rdTex              ("[SH] 3rd Shade Texture", 2D) = "white" {}
            _TS_Power               ("[SH] Shade Power", Range(0, 2)) = 1
        [Toggle(_)]
            _TS_FixContrast         ("[SH] Dont Ajust Contrast", Range(0, 1)) = 0
            _TS_1stBorder           ("[SH] 1st Border", Range(0, 1)) = 0.4
            _TS_2ndBorder           ("[SH] 2nd Border", Range(0, 1)) = 0.2
            _TS_3rdBorder           ("[SH] 3rd Border", Range(0, 1)) = 0.1
            _TS_Feather             ("[SH] Feather", Range(0, 0.2)) = 0.05
            _TS_BlendNormal         ("[SH] Blend Normal", Range(0, 1)) = 0.1
        [NoScaleOffset]
            _TS_MaskTex             ("[SH] Anti-Shadow Mask Texture (R)", 2D) = "black" {}
        [Toggle(_)]
            _TS_InvMaskVal          ("[SH] Invert Mask Value", Range(0, 1)) = 0

        // Distance Fade
        [WFHeaderToggle(Distance Fade)]
            _DF_Enable              ("[DF] Enable", Float) = 0
            _DF_Color               ("[DF] Color", Color) = (0.1, 0.1, 0.1, 1)
            _DF_MinDist             ("[DF] Fade Distance (Near)", Range(0, 0.5)) = 0.02
            _DF_MaxDist             ("[DF] Fade Distance (Far)", Range(0, 0.5)) = 0.08
            _DF_Power               ("[DF] Power", Range(0, 1)) = 1
        [Toggle(_)]
            _DF_BackShadow          ("[DF] BackFace Shadow", Float) = 1

        // Lit
        [WFHeader(Lit)]
        [Gamma]
            _GL_LevelMin            ("Unlit Intensity", Range(0, 1)) = 0.125
        [Gamma]
            _GL_LevelMax            ("Saturate Intensity", Range(0, 1)) = 0.8
            _GL_BlendPower          ("Chroma Reaction", Range(0, 1)) = 0.8

        [WFHeader(Lit Advance)]
        [Enum(AUTO,0,ONLY_DIRECTIONAL_LIT,1,ONLY_POINT_LIT,2,CUSTOM_WORLDSPACE,3,CUSTOM_LOCALSPACE,4)]
            _GL_LightMode           ("Sun Source", Float) = 0
            _GL_CustomAzimuth       ("Custom Sun Azimuth", Range(0, 360)) = 0
            _GL_CustomAltitude      ("Custom Sun Altitude", Range(-90, 90)) = 45
        [Toggle(_)]
            _GL_DisableBackLit      ("Disable BackLit", Range(0, 1)) = 0
        [Toggle(_)]
            _GL_DisableBasePos      ("Disable ObjectBasePos", Range(0, 1)) = 0

        [HideInInspector]
        [WF_FixFloat(0.0)]
            _CurrentVersion         ("2022/02/13", Float) = 0
    }

    SubShader {
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "DisableBatching" = "True"
            "IgnoreProjector" = "True"
            "VRCFallback" = "Hidden"
        }

        Pass {
            Name "FUR"
            Tags { "LightMode" = "ForwardBase" }

            Cull OFF
            AlphaToMask [_AL_AlphaToMask]

            CGPROGRAM

            #pragma vertex vert_fakefur
            #pragma geometry geom_fakefur
            #pragma fragment frag_fakefur_cutoff

            #pragma shader_feature_local _ _TS_FIXC_ENABLE
            #pragma shader_feature_local _TS_ENABLE
            #pragma shader_feature_local_fragment _ _TS_STEP1_ENABLE _TS_STEP2_ENABLE _TS_STEP3_ENABLE
            #pragma shader_feature_local_fragment _CL_ENABLE
            #pragma shader_feature_local_fragment _DF_ENABLE

            #pragma target 5.0
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            #include "WF_FakeFur.cginc"

            ENDCG
        }

        Pass {
            Name "FUR2"
            Tags { "LightMode" = "ForwardBase" }

            Cull OFF
            ZWrite OFF
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #pragma vertex vert_fakefur
            #pragma geometry geom_fakefur
            #pragma fragment frag_fakefur

            #pragma shader_feature_local _ _TS_FIXC_ENABLE
            #pragma shader_feature_local _TS_ENABLE
            #pragma shader_feature_local_fragment _ _TS_STEP1_ENABLE _TS_STEP2_ENABLE _TS_STEP3_ENABLE
            #pragma shader_feature_local_fragment _CL_ENABLE
            #pragma shader_feature_local_fragment _DF_ENABLE

            #define _FR_HEIGHT_PARAM _FR_Height2
            #define _FR_REPEAT_PARAM _FR_Repeat2

            #pragma target 5.0
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            #include "WF_FakeFur.cginc"

            ENDCG
        }

        Pass {
            Name "FUR3"
            Tags { "LightMode" = "ForwardBase" }

            Blend Zero One,One Zero //Alphaだけ上書き
            Cull Off
            ZWrite Off

            CGPROGRAM

            #pragma vertex vert_fakefur
            #pragma geometry geom_fakefur
            #pragma fragment frag_fakefur_Beatsaber

            #pragma shader_feature_local _ _TS_FIXC_ENABLE
            #pragma shader_feature_local _TS_ENABLE
            #pragma shader_feature_local_fragment _ _TS_STEP1_ENABLE _TS_STEP2_ENABLE _TS_STEP3_ENABLE
            #pragma shader_feature_local_fragment _CL_ENABLE
            #pragma shader_feature_local_fragment _DF_ENABLE

            #define _FR_HEIGHT_PARAM _FR_Height2
            #define _FR_REPEAT_PARAM _FR_Repeat2

            #pragma target 5.0
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            #include "WF_FakeFur.cginc"

            ENDCG
        }

        UsePass "Hidden/UnlitWF/WF_UnToon_Hidden/META"
    }

    FallBack "Hidden/UnlitWF/WF_UnToon_Hidden"

    CustomEditor "BeatSaber/UnlitWF.ShaderCustomEditor"
}
