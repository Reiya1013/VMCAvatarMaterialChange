using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using System;

namespace AxCharacterShaders
{
    public class AxInspector : ShaderGUI
    {
        #region MaterialProperties
        MaterialProperty BaseTexture;
        MaterialProperty BaseColor;
        MaterialProperty Normalmap;
        MaterialProperty BumpScale;
        MaterialProperty EmissionMap;
        MaterialProperty EmissionColor;
        MaterialProperty AlphaMask;
        MaterialProperty BaseTextureSecondary;
        MaterialProperty BaseColorSecondary;
        MaterialProperty NormalmapSecondary;
        MaterialProperty BumpScaleSecondary;
        MaterialProperty EmissionMapSecondary;
        MaterialProperty EmissionColorSecondary;
        MaterialProperty UseEmissionParallax;
        MaterialProperty EmissionParallaxColor;
        MaterialProperty EmissionParallaxTex;
        MaterialProperty EmissionParallaxMask;
        MaterialProperty EmissionParallaxDepth;
        MaterialProperty EmissionParallaxDepthMask;
        MaterialProperty EmissionParallaxDepthMaskInvert;
        MaterialProperty DetailMask;
        MaterialProperty DetailAlbedoMap;
        MaterialProperty DetailAlbedoScale;
        MaterialProperty DetailNormalMap;
        MaterialProperty DetailNormalMapScale;
        MaterialProperty Shadowborder;
        MaterialProperty ShadowborderBlur;
        MaterialProperty ShadowborderBlurMask;
        MaterialProperty ShadowRamp;
        MaterialProperty ShadowRampInit;
        MaterialProperty ShadowStrength;
        MaterialProperty ShadowStrengthMask;
        MaterialProperty ShadowAmbientIntensity;
        MaterialProperty PointAddIntensity;
        MaterialProperty PointShadowStrength;
        MaterialProperty PointShadowborder;
        MaterialProperty PointShadowborderBlur;
        MaterialProperty PointShadowborderBlurMask;
        MaterialProperty CutoutCutoutAdjust;
        MaterialProperty ShadowPlanBDefaultShadowMix;
        MaterialProperty ShadowPlanBUseCustomShadowTexture;
        MaterialProperty ShadowPlanBHueShiftFromBase;
        MaterialProperty ShadowPlanBSaturationFromBase;
        MaterialProperty ShadowPlanBValueFromBase;
        MaterialProperty ShadowPlanBCustomShadowTexture;
        MaterialProperty ShadowPlanBCustomShadowDetailMap;
        MaterialProperty ShadowPlanBCustomShadowTextureRGB;
        MaterialProperty ShadowReceivingIntensity;
        MaterialProperty ShadowReceivingMask;
        MaterialProperty UseGloss;
        MaterialProperty GlossBlend;
        MaterialProperty GlossBlendMask;
        MaterialProperty GlossPower;
        MaterialProperty GlossColor;
        MaterialProperty OutlineWidth;
        MaterialProperty OutlineMask;
        MaterialProperty OutlineCutoffRange;
        MaterialProperty OutlineColor;
        MaterialProperty OutlineTexture;
        MaterialProperty OutlineTextureColorRate;
        MaterialProperty OutlineWidthMask;
        MaterialProperty OutlineUseColorShift;
        MaterialProperty OutlineHueShiftFromBase;
        MaterialProperty OutlineSaturationFromBase;
        MaterialProperty OutlineValueFromBase;
        MaterialProperty MatcapBlendMode;
        MaterialProperty MatcapBlend;
        MaterialProperty MatcapTexture;
        MaterialProperty MatcapColor;
        MaterialProperty MatcapBlendMask;
        MaterialProperty MatcapNormalMix;
        MaterialProperty MatcapShadeMix;
        MaterialProperty UseReflection;
        MaterialProperty UseReflectionProbe;
        MaterialProperty ReflectionReflectionPower;
        MaterialProperty ReflectionReflectionMask;
        MaterialProperty ReflectionNormalMix;
        MaterialProperty ReflectionShadeMix;
        MaterialProperty ReflectionCubemap;
        MaterialProperty ReflectionSuppressBaseColorValue;
        MaterialProperty RefractionFresnelExp;
        MaterialProperty RefractionStrength;
        MaterialProperty UseRim;
        MaterialProperty RimBlend;
        MaterialProperty RimBlendMask;
        MaterialProperty RimShadeMix;
        MaterialProperty RimBlendStart;
        MaterialProperty RimBlendEnd;
        MaterialProperty RimPow;
        MaterialProperty RimColor;
        MaterialProperty RimTexture;
        MaterialProperty RimUseBaseTexture;
        MaterialProperty ShadowCapBlendMode;
        MaterialProperty ShadowCapBlend;
        MaterialProperty ShadowCapBlendMask;
        MaterialProperty ShadowCapNormalMix;
        MaterialProperty ShadowCapTexture;
        MaterialProperty StencilNumber;
        MaterialProperty StencilCompareAction;
        MaterialProperty StencilNumberSecondary;
        MaterialProperty StencilCompareActionSecondary;
        MaterialProperty StencilMaskTex;
        MaterialProperty StencilMaskAdjust;
        MaterialProperty StencilMaskAlphaDither;
        MaterialProperty Cull;
        MaterialProperty DoubleSidedFlipBackfaceNormal;
        MaterialProperty DoubleSidedBackfaceLightIntensity;
        MaterialProperty DoubleSidedBackfaceUseColorShift;
        MaterialProperty DoubleSidedBackfaceHueShiftFromBase;
        MaterialProperty DoubleSidedBackfaceSaturationFromBase;
        MaterialProperty DoubleSidedBackfaceValueFromBase;
        MaterialProperty ZWrite;
        MaterialProperty VertexColorBlendDiffuse;
        MaterialProperty VertexColorBlendEmissive;
        MaterialProperty BackfaceColorMultiply;
        MaterialProperty EmissiveFreak1Tex;
        MaterialProperty EmissiveFreak1Mask;
        MaterialProperty EmissiveFreak1Color;
        MaterialProperty EmissiveFreak1U;
        MaterialProperty EmissiveFreak1V;
        MaterialProperty EmissiveFreak1Depth;
        MaterialProperty EmissiveFreak1DepthMask;
        MaterialProperty EmissiveFreak1DepthMaskInvert;
        MaterialProperty EmissiveFreak1Breathing;
        MaterialProperty EmissiveFreak1BreathingMix;
        MaterialProperty EmissiveFreak1BlinkOut;
        MaterialProperty EmissiveFreak1BlinkOutMix;
        MaterialProperty EmissiveFreak1BlinkIn;
        MaterialProperty EmissiveFreak1BlinkInMix;
        MaterialProperty EmissiveFreak1HueShift;
        MaterialProperty EmissiveFreak2Tex;
        MaterialProperty EmissiveFreak2Mask;
        MaterialProperty EmissiveFreak2Color;
        MaterialProperty EmissiveFreak2U;
        MaterialProperty EmissiveFreak2V;
        MaterialProperty EmissiveFreak2Depth;
        MaterialProperty EmissiveFreak2DepthMask;
        MaterialProperty EmissiveFreak2DepthMaskInvert;
        MaterialProperty EmissiveFreak2Breathing;
        MaterialProperty EmissiveFreak2BreathingMix;
        MaterialProperty EmissiveFreak2BlinkOut;
        MaterialProperty EmissiveFreak2BlinkOutMix;
        MaterialProperty EmissiveFreak2BlinkIn;
        MaterialProperty EmissiveFreak2BlinkInMix;
        MaterialProperty EmissiveFreak2HueShift;

        #endregion

        static bool IsShowAdvanced = false;
        static bool IsShowAlphaMask = false;
        static bool IsShowNonRegistered = false;
        static bool IsShowVariationTip = false;
        static bool IsShowDetailMap = false;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
        {
            Material material = materialEditor.target as Material;

            Shader shader = material.shader;

            // shader.nameによって調整可能なプロパティを制御する。
            bool isOpaque = shader.name.Contains("Opaque");
            bool isFade = shader.name.Contains("Fade");
            bool isCutout = shader.name.Contains("Cutout");
            bool isStencilWriter = shader.name.Contains("StencilWriter");
            bool isStencilReader = shader.name.Contains("StencilReader");
            bool isStencilReaderDouble = shader.name.Contains("_StencilReader/Double");
            bool isRefracted = shader.name.Contains("Refracted");
            bool isEmissiveFreak = shader.name.Contains("/_EmissiveFreak/");
            bool isOutline = shader.name.Contains("/_Outline/");

            // Clear regitered props
            ClearRegisteredPropertiesList();

            // FindProperties
            BaseTexture = MatP("_MainTex", props, false);
            BaseColor = MatP("_Color", props, false);
            Normalmap = MatP("_BumpMap", props, false);
            BumpScale = MatP("_BumpScale", props, false);
            EmissionMap = MatP("_EmissionMap", props, false);
            EmissionColor = MatP("_EmissionColor", props, false);
            AlphaMask = MatP("_AlphaMask", props, false);
            BaseTextureSecondary = MatP("_MainTexSecondary", props, false);
            BaseColorSecondary = MatP("_ColorSecondary", props, false);
            NormalmapSecondary = MatP("_BumpMapSecondary", props, false);
            BumpScaleSecondary = MatP("_BumpScaleSecondary", props, false);
            EmissionMapSecondary = MatP("_EmissionMapSecondary", props, false);
            EmissionColorSecondary = MatP("_EmissionColorSecondary", props, false);
            UseEmissionParallax = MatP("_UseEmissionParallax", props, false);
            EmissionParallaxColor = MatP("_EmissionParallaxColor", props, false);
            EmissionParallaxTex = MatP("_EmissionParallaxTex", props, false);
            EmissionParallaxMask = MatP("_EmissionParallaxMask", props, false);
            EmissionParallaxDepth = MatP("_EmissionParallaxDepth", props, false);
            EmissionParallaxDepthMask = MatP("_EmissionParallaxDepthMask", props, false);
            EmissionParallaxDepthMaskInvert = MatP("_EmissionParallaxDepthMaskInvert", props, false);
            DetailMask = MatP("_DetailMask", props, false);
            DetailAlbedoMap = MatP("_DetailAlbedoMap", props, false);
            DetailAlbedoScale = MatP("_DetailAlbedoScale", props, false);
            DetailNormalMap = MatP("_DetailNormalMap", props, false);
            DetailNormalMapScale = MatP("_DetailNormalMapScale", props, false);
            CutoutCutoutAdjust = MatP("_CutoutCutoutAdjust", props, false);
            Shadowborder = MatP("_Shadowborder", props, false);
            ShadowborderBlur = MatP("_ShadowborderBlur", props, false);
            ShadowborderBlurMask = MatP("_ShadowborderBlurMask", props, false);
            ShadowRamp = MatP("_ShadowRamp", props, false);
            ShadowRampInit = MatP("_ShadowRampInit", props, false);
            ShadowStrength = MatP("_ShadowStrength", props, false);
            ShadowStrengthMask = MatP("_ShadowStrengthMask", props, false);
            ShadowAmbientIntensity = MatP("_ShadowAmbientIntensity", props, false);
            PointAddIntensity = MatP("_PointAddIntensity", props, false);
            PointShadowStrength = MatP("_PointShadowStrength", props, false);
            PointShadowborder = MatP("_PointShadowborder", props, false);
            PointShadowborderBlur = MatP("_PointShadowborderBlur", props, false);
            PointShadowborderBlurMask= MatP("_PointShadowborderBlurMask", props, false);
            ShadowPlanBUseCustomShadowTexture = MatP("_ShadowPlanBUseCustomShadowTexture", props, false);
            ShadowPlanBHueShiftFromBase = MatP("_ShadowPlanBHueShiftFromBase", props, false);
            ShadowPlanBSaturationFromBase = MatP("_ShadowPlanBSaturationFromBase", props, false);
            ShadowPlanBValueFromBase = MatP("_ShadowPlanBValueFromBase", props, false);
            ShadowPlanBCustomShadowTexture = MatP("_ShadowPlanBCustomShadowTexture", props, false);
            ShadowPlanBCustomShadowDetailMap = MatP("_ShadowPlanBCustomShadowDetailMap", props, false);
            ShadowPlanBCustomShadowTextureRGB = MatP("_ShadowPlanBCustomShadowTextureRGB", props, false);
            ShadowReceivingIntensity = MatP("_ShadowReceivingIntensity", props, false);
            ShadowReceivingMask = MatP("_ShadowReceivingMask", props, false);
            UseGloss = MatP("_UseGloss", props, false);
            GlossBlend = MatP("_GlossBlend", props, false);
            GlossBlendMask = MatP("_GlossBlendMask", props, false);
            GlossPower = MatP("_GlossPower", props, false);
            GlossColor = MatP("_GlossColor", props, false);
            OutlineWidth = MatP("_OutlineWidth", props, false);
            OutlineMask = MatP("_OutlineMask", props, false);
            OutlineCutoffRange = MatP("_OutlineCutoffRange", props, false);
            OutlineColor = MatP("_OutlineColor", props, false);
            OutlineTexture = MatP("_OutlineTexture", props, false);
            OutlineTextureColorRate = MatP("_OutlineTextureColorRate", props, false);
            OutlineWidthMask = MatP("_OutlineWidthMask", props, false);
            OutlineUseColorShift = MatP("_OutlineUseColorShift", props, false);
            OutlineHueShiftFromBase = MatP("_OutlineHueShiftFromBase", props, false);
            OutlineSaturationFromBase = MatP("_OutlineSaturationFromBase", props, false);
            OutlineValueFromBase = MatP("_OutlineValueFromBase", props, false);
            MatcapBlendMode = MatP("_MatcapBlendMode", props, false);
            MatcapBlend = MatP("_MatcapBlend", props, false);
            MatcapTexture = MatP("_MatcapTexture", props, false);
            MatcapColor = MatP("_MatcapColor", props, false);
            MatcapBlendMask = MatP("_MatcapBlendMask", props, false);
            MatcapNormalMix = MatP("_MatcapNormalMix", props, false);
            MatcapShadeMix = MatP("_MatcapShadeMix", props, false);
            UseReflection = MatP("_UseReflection", props, false);
            UseReflectionProbe = MatP("_UseReflectionProbe", props, false);
            ReflectionReflectionPower = MatP("_ReflectionReflectionPower", props, false);
            ReflectionReflectionMask = MatP("_ReflectionReflectionMask", props, false);
            ReflectionNormalMix = MatP("_ReflectionNormalMix", props, false);
            ReflectionShadeMix = MatP("_ReflectionShadeMix", props, false);
            ReflectionCubemap = MatP("_ReflectionCubemap", props, false);
            ReflectionSuppressBaseColorValue = MatP("_ReflectionSuppressBaseColorValue", props, false);
            RefractionFresnelExp = MatP("_RefractionFresnelExp", props, false);
            RefractionStrength = MatP("_RefractionStrength", props, false);
            UseRim = MatP("_UseRim", props, false);
            RimBlend = MatP("_RimBlend", props, false);
            RimBlendMask = MatP("_RimBlendMask", props, false);
            RimShadeMix = MatP("_RimShadeMix", props, false);
            RimBlendStart = MatP("_RimBlendStart", props, false);
            RimBlendEnd = MatP("_RimBlendEnd", props, false);
            RimPow = MatP("_RimPow", props, false);
            RimColor = MatP("_RimColor", props, false);
            RimTexture = MatP("_RimTexture", props, false);
            RimUseBaseTexture = MatP("_RimUseBaseTexture", props, false);
            ShadowCapBlendMode = MatP("_ShadowCapBlendMode", props, false);
            ShadowCapBlend = MatP("_ShadowCapBlend", props, false);
            ShadowCapBlendMask = MatP("_ShadowCapBlendMask", props, false);
            ShadowCapNormalMix = MatP("_ShadowCapNormalMix", props, false);
            ShadowCapTexture = MatP("_ShadowCapTexture", props, false);
            StencilNumber = MatP("_StencilNumber", props, false);
            StencilMaskTex = MatP("_StencilMaskTex", props, false);
            StencilMaskAdjust = MatP("_StencilMaskAdjust", props, false);
            StencilMaskAlphaDither = MatP("_StencilMaskAlphaDither", props, false);
            StencilCompareAction = MatP("_StencilCompareAction", props, false);
            StencilNumberSecondary = MatP("_StencilNumberSecondary", props, false);
            StencilCompareActionSecondary = MatP("_StencilCompareActionSecondary", props, false);
            Cull = MatP("_Cull", props, false);
            DoubleSidedFlipBackfaceNormal = MatP("_DoubleSidedFlipBackfaceNormal", props, false);
            DoubleSidedBackfaceLightIntensity = MatP("_DoubleSidedBackfaceLightIntensity", props, false);
            DoubleSidedBackfaceUseColorShift = MatP("_DoubleSidedBackfaceUseColorShift", props, false);
            DoubleSidedBackfaceHueShiftFromBase = MatP("_DoubleSidedBackfaceHueShiftFromBase", props, false);
            DoubleSidedBackfaceSaturationFromBase = MatP("_DoubleSidedBackfaceSaturationFromBase", props, false);
            DoubleSidedBackfaceValueFromBase = MatP("_DoubleSidedBackfaceValueFromBase", props, false);
            VertexColorBlendDiffuse = MatP("_VertexColorBlendDiffuse", props, false);
            VertexColorBlendEmissive = MatP("_VertexColorBlendEmissive", props, false);
            ZWrite = MatP("_ZWrite", props, false);

            EmissiveFreak1Tex = MatP("_EmissiveFreak1Tex", props, false);
            EmissiveFreak1Mask = MatP("_EmissiveFreak1Mask", props, false);
            EmissiveFreak1Color = MatP("_EmissiveFreak1Color", props, false);
            EmissiveFreak1U = MatP("_EmissiveFreak1U", props, false);
            EmissiveFreak1V = MatP("_EmissiveFreak1V", props, false);
            EmissiveFreak1Depth = MatP("_EmissiveFreak1Depth", props, false);
            EmissiveFreak1DepthMask = MatP("_EmissiveFreak1DepthMask", props, false);
            EmissiveFreak1DepthMaskInvert = MatP("_EmissiveFreak1DepthMaskInvert", props, false);
            EmissiveFreak1Breathing = MatP("_EmissiveFreak1Breathing", props, false);
            EmissiveFreak1BreathingMix = MatP("_EmissiveFreak1BreathingMix", props, false);
            EmissiveFreak1BlinkOut = MatP("_EmissiveFreak1BlinkOut", props, false);
            EmissiveFreak1BlinkOutMix = MatP("_EmissiveFreak1BlinkOutMix", props, false);
            EmissiveFreak1BlinkIn = MatP("_EmissiveFreak1BlinkIn", props, false);
            EmissiveFreak1BlinkInMix = MatP("_EmissiveFreak1BlinkInMix", props, false);
            EmissiveFreak1HueShift = MatP("_EmissiveFreak1HueShift", props, false);

            EmissiveFreak2Tex = MatP("_EmissiveFreak2Tex", props, false);
            EmissiveFreak2Mask = MatP("_EmissiveFreak2Mask", props, false);
            EmissiveFreak2Color = MatP("_EmissiveFreak2Color", props, false);
            EmissiveFreak2U = MatP("_EmissiveFreak2U", props, false);
            EmissiveFreak2V = MatP("_EmissiveFreak2V", props, false);
            EmissiveFreak2Depth = MatP("_EmissiveFreak2Depth", props, false);
            EmissiveFreak2DepthMask = MatP("_EmissiveFreak2DepthMask", props, false);
            EmissiveFreak2DepthMaskInvert = MatP("_EmissiveFreak2DepthMaskInvert", props, false);
            EmissiveFreak2Breathing = MatP("_EmissiveFreak2Breathing", props, false);
            EmissiveFreak2BreathingMix = MatP("_EmissiveFreak2BreathingMix", props, false);
            EmissiveFreak2BlinkOut = MatP("_EmissiveFreak2BlinkOut", props, false);
            EmissiveFreak2BlinkOutMix = MatP("_EmissiveFreak2BlinkOutMix", props, false);
            EmissiveFreak2BlinkIn = MatP("_EmissiveFreak2BlinkIn", props, false);
            EmissiveFreak2BlinkInMix = MatP("_EmissiveFreak2BlinkInMix", props, false);
            EmissiveFreak2HueShift = MatP("_EmissiveFreak2HueShift", props, false);

            EditorGUIUtility.labelWidth = 0f;

            EditorGUI.BeginChangeCheck();
            {
                // バリエーションの説明
                IsShowVariationTip = UIHelper.ShurikenFoldout(shader.name.Substring(20) + "について", IsShowVariationTip);
                if (IsShowVariationTip) {
                    if (isOutline) {
                        EditorGUILayout.HelpBox("Outlineカテゴリは、メッシュにアウトラインを付けたいときに使用するバリエーションです。"
                        + Environment.NewLine + "アウトラインと半透明（Fade）は相性の問題で使用できません。"
                        + Environment.NewLine + "アウトラインが必要ない場合は、アウトラインカテゴリではない、同名シェーダーを使う方が効率良く描画できます。"
                        , MessageType.Info);
                    }
                    if (isEmissiveFreak) {
                        EditorGUILayout.HelpBox("EmissiveFreakカテゴリは、メッシュの一部分を躍動的に1680万色に光らせたい貴方の為に用意したバリエーションです。"
                        + Environment.NewLine + "1680万色も必要ない場合は、このカテゴリの存在は忘れましょう。"
                        , MessageType.Info);
                    }
                    if (isStencilWriter) {
                        EditorGUILayout.HelpBox("StencilWriterは、空間にステンシルバッファを書き込む機能を持ったシェーダーです。"
                        + Environment.NewLine + "「StencilReader」や、その他ステンシルバッファを参照するシェーダーと合わせて利用することが前提になっています。"
                        + Environment.NewLine + "不透明メッシュでStencilを使用する場合は、Opaqueは無いので代わりにAlphaCutoutを使ってください。"
                        , MessageType.Info);
                    }
                    if (isStencilReader && !isStencilReaderDouble) {
                        EditorGUILayout.HelpBox("StencilReaderは、書き込まれたステンシルバッファを参照し、描画をどうするか設定できるバリエーションです"
                        + Environment.NewLine + "「StencilWriter」やその他ステンシルバッファを操作するシェーダーと合わせて利用することが前提になっています。"
                        + Environment.NewLine + "不透明メッシュでStencilを使用する場合は、Opaqueは無いので代わりにAlphaCutoutを使ってください。"
                        , MessageType.Info);
                    }
                    if (isStencilReaderDouble) {
                        EditorGUILayout.HelpBox("StencilReader/Doubleって何だっけ？？？"
                        + Environment.NewLine + "なんかこう、ステンシルの値を別々に2回参照できて、それぞれで別の色を出すとか、そんな感じで作った気がします。"
                        + Environment.NewLine + "意味が分からない人は通常の「StencilReader」使ってください。私も忘れました。"
                        , MessageType.Info);
                    }
                    if (isCutout) {
                        EditorGUILayout.HelpBox("AlphaCutoutは、メッシュ上に「不透明」と「完全に透明」の２つのパターンがある時に効率よく利用できるバリエーションです"
                        + Environment.NewLine + "メッシュ全体が不透明であれば「Opaque」、半透明な部分を含みたい場合は「Fade」を利用してください。"
                        , MessageType.Info);
                    }
                    if (isOpaque) {
                        EditorGUILayout.HelpBox("Opaqueは、完全に不透明なメッシュに効率よく適用できるバリエーションです。"
                        + Environment.NewLine + "不透明＋完全に透明の２パターンであれば「AlphaCutout」、半透明な部分を含みたい場合は「Fade」を使用してください。"
                        , MessageType.Info);
                    }
                    if (isFade) {
                        EditorGUILayout.HelpBox("Fadeは、メッシュに半透明を部分的に含む場合に使用するバリエーションです。"
                        + (isRefracted ? "" : Environment.NewLine + "デフォルトレンダーキューを「Transparent-100」に設定しています。")
                        + Environment.NewLine + "半透明とアウトラインは相性の問題で使用できません。"
                        + Environment.NewLine + "完全に不透明であれば「Opaque」、不透明＋完全に透明の２パターンであれば「AlphaCutout」を使用すると、効率よく描画できます。"
                        , MessageType.Info);
                    }
                    if (isRefracted) {
                        EditorGUILayout.HelpBox("Refractedは、半透明の奥に見える光景を疑似的に屈折させることのできるバリエーションです。"
                        + Environment.NewLine + "Refractedのみレンダーキューが「Transparent」のままなので注意してください。"
                        + Environment.NewLine + "屈折表現が重要な場合にご利用いただき、そうでない場合は通常の「Fade」の利用を推奨します。"
                        , MessageType.Info);
                    }
                }

                // Common
                UIHelper.ShurikenHeader("Common", "1-common");
                UIHelper.DrawWithGroup(() => {
					UIHelper.DrawWithGroup(() => {
                        materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture", "Base Color Texture (RGB)"), BaseTexture, BaseColor);
                        materialEditor.TextureScaleOffsetPropertyIndent(BaseTexture);
					});
                    UIHelper.DrawWithGroup(() => {
                        materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", "Normal Map (RGB)"), Normalmap, BumpScale);
                        materialEditor.TextureScaleOffsetPropertyIndent(Normalmap);
                    });
                    UIHelper.DrawWithGroup(() => {
                        materialEditor.TexturePropertySingleLine(new GUIContent("Emission", "Emission (RGB)"), EmissionMap, EmissionColor);
                        materialEditor.TextureScaleOffsetPropertyIndent(EmissionMap);
                    });

                    UIHelper.DrawWithGroup(() => {
                        materialEditor.ShaderProperty(Cull, "Cull");
                        var culling = Cull.floatValue;
                        if(culling < 2){
                            EditorGUI.indentLevel ++;
                            materialEditor.ShaderProperty(DoubleSidedFlipBackfaceNormal, "Flip backface normal");
                            materialEditor.ShaderProperty(DoubleSidedBackfaceLightIntensity, "Backface Light Intensity");
                            materialEditor.ShaderProperty(DoubleSidedBackfaceUseColorShift, "Use Backface Color Shift");
                            var backfaceColorShift = DoubleSidedBackfaceUseColorShift.floatValue;
                            if(backfaceColorShift > 0) {
                                EditorGUI.indentLevel ++;
                                materialEditor.ShaderProperty(DoubleSidedBackfaceHueShiftFromBase, "Hue Shift");
                                materialEditor.ShaderProperty(DoubleSidedBackfaceSaturationFromBase, "Saturation");
                                materialEditor.ShaderProperty(DoubleSidedBackfaceValueFromBase, "Value");
                                EditorGUI.indentLevel --;
                            }
                            EditorGUI.indentLevel --;
                        }

                        if(isFade) materialEditor.ShaderProperty(ZWrite, "ZWrite");
                    });
                });

                // Secondary Common
                if(isStencilReaderDouble) {
                    UIHelper.ShurikenHeader("Secondary Common", "1-common");
                    UIHelper.DrawWithGroup(() => {
                        materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture", "Base Color Texture (RGB)"), BaseTextureSecondary, BaseColorSecondary);
                        materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", "Normal Map (RGB)"), NormalmapSecondary, BumpScaleSecondary);
                        materialEditor.TexturePropertySingleLine(new GUIContent("Emission", "Emission (RGB)"), EmissionMapSecondary, EmissionColorSecondary);
                    });
                }

                // AlphaMask
                if(isFade){
                    IsShowAlphaMask = UIHelper.ShurikenFoldout("AlphaMask", IsShowAlphaMask, "3-alphamask");
                    if (IsShowAlphaMask) {
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.ShaderProperty(AlphaMask, "Alpha Mask");
                        });
                    }
                }

                // Refraction
                if(isRefracted){
                    UIHelper.ShurikenHeader("Refraction", "4-refraction");
                    UIHelper.DrawWithGroup(() => {
                        materialEditor.ShaderProperty(RefractionFresnelExp, "Fresnel Exp");
                        materialEditor.ShaderProperty(RefractionStrength, "Strength");
                    });
                }

                // Alpha Cutout
                if(isCutout){
                    UIHelper.ShurikenHeader("Alpha Cutout", "5-alphacutout");
                    UIHelper.DrawWithGroup(() => {
                        materialEditor.ShaderProperty(CutoutCutoutAdjust, "Cutoff Adjust");
                    });
                }

                // Shadow
                UIHelper.ShurikenHeader("Shading / Shadow", "6-shading");
                UIHelper.DrawWithGroup(() => {
                    UIHelper.DrawWithGroup(() => {
                        EditorGUILayout.LabelField("Border & Range", EditorStyles.boldLabel);
                        EditorGUI.indentLevel ++;
                        materialEditor.ShaderProperty(Shadowborder, "Border");
                        materialEditor.TexturePropertySingleLine(new GUIContent("Range & Mask", "Transition Range and Mask Texture"), ShadowborderBlurMask, ShadowborderBlur);
                        materialEditor.TextureScaleOffsetPropertyIndent(ShadowborderBlurMask);

                        // Ramp
                        Rect controlRect = EditorGUILayout.GetControlRect(true, EditorGUIUtility.singleLineHeight, EditorStyles.layerMaskField);
                        GUI.Label(controlRect, "Ramp in Range", EditorStyles.boldLabel);
                        var p = GUI.Button(
                            new Rect(controlRect.x + EditorGUIUtility.labelWidth + EditorGUIUtility.fieldWidth, controlRect.y, controlRect.width - EditorGUIUtility.labelWidth - EditorGUIUtility.fieldWidth, EditorGUIUtility.singleLineHeight),
                            "Revert"
                        );
                        if (p) {
                            AssignDefaultRampTexture(ShadowRamp);
                        }

                        materialEditor.TexturePropertySingleLine(new GUIContent("Texture", "Ramp Texture"), ShadowRamp, ShadowRamp);
                        if (ShadowRamp.textureValue == null) {
                            if (ShadowRampInit.floatValue == 0) {
                                // Rampテクスチャの初期設定処理を行う
                                AssignDefaultRampTexture(ShadowRamp);
                                ShadowRampInit.floatValue = 1;
                            } else {
                                // 初期設定後に削除された可能性があるので警告
                                EditorGUILayout.HelpBox("Rampテクスチャは必ず指定してください。心当たりがない場合は、上の「Revert」を押してください。", MessageType.Warning);
                            }
                        }
                        EditorGUI.indentLevel --;
                    });

                    if(!isFade){
                        UIHelper.DrawWithGroup(() => {
                            EditorGUILayout.LabelField("Shadow Receiving", EditorStyles.boldLabel);
                            EditorGUI.indentLevel ++;
                            materialEditor.TexturePropertySingleLine(new GUIContent("Intensity", "Intensity + Mask"), ShadowReceivingMask, ShadowReceivingIntensity);
                            EditorGUI.indentLevel --;
                        });
                    }

                    UIHelper.DrawWithGroup(() => {
                        EditorGUILayout.LabelField("Default color shading", EditorStyles.boldLabel);
                        EditorGUI.indentLevel ++;
                        materialEditor.TexturePropertySingleLine(new GUIContent("Strength & Mask", "Strength and Mask Texture"), ShadowStrengthMask, ShadowStrength);
                        materialEditor.TextureScaleOffsetPropertyIndent(ShadowStrengthMask);
                        EditorGUI.indentLevel --;

                        EditorGUILayout.LabelField("Custom color shading", EditorStyles.boldLabel);
                        EditorGUI.indentLevel ++;
                        materialEditor.ShaderProperty(ShadowPlanBUseCustomShadowTexture, "Use Texture");
                        var useShadeTexture = ShadowPlanBUseCustomShadowTexture.floatValue;
                        if(useShadeTexture > 0)
                        {
                            materialEditor.ShaderProperty(ShadowPlanBCustomShadowTexture, "Texture");
                            materialEditor.ShaderProperty(ShadowPlanBCustomShadowTextureRGB, "RGB multiply");
                        }
                        else
                        {
                            materialEditor.ShaderProperty(ShadowPlanBHueShiftFromBase, "Hue Shift");
                            materialEditor.ShaderProperty(ShadowPlanBSaturationFromBase, "Saturation");
                            materialEditor.ShaderProperty(ShadowPlanBValueFromBase, "Value");
                        }
                        EditorGUI.indentLevel --;

                        EditorGUILayout.LabelField("Ambient Light", EditorStyles.boldLabel);
                        EditorGUI.indentLevel ++;
                        materialEditor.ShaderProperty(ShadowAmbientIntensity, "Intensity");
                        EditorGUI.indentLevel --;
                    });
                });

                // Advanced / Experimental
                IsShowDetailMap = UIHelper.ShurikenFoldout("Details", IsShowDetailMap, "7-details");
                if (IsShowDetailMap) {
                    UIHelper.DrawWithGroup(() => {
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Mask", "Mask"), DetailMask);
                            materialEditor.TextureScaleOffsetPropertyIndent(DetailMask);
                        });
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Detail Map", "Detail Map"), DetailAlbedoMap, DetailAlbedoScale);
                            materialEditor.TexturePropertySingleLine(new GUIContent("Detail Map (when Shaded) ", "Detail Map (when Shaded)"), ShadowPlanBCustomShadowDetailMap);
                            materialEditor.TextureScaleOffsetPropertyIndent(DetailAlbedoMap);
                        });
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map", "Normal Map (RGB)"), DetailNormalMap, DetailNormalMapScale);
                            materialEditor.TextureScaleOffsetPropertyIndent(DetailNormalMap);
                        });
                    });
                }

                // Outline
                if(!isRefracted && isOutline) {
                    UIHelper.ShurikenHeader("Outline", "8-outline");
                    {
                        UIHelper.DrawWithGroup(() => {
                            UIHelper.DrawWithGroup(() => {
                                materialEditor.TexturePropertySingleLine(new GUIContent("Width & Mask", "Width and Mask Texture"), OutlineWidthMask, OutlineWidth);
                                materialEditor.TextureScaleOffsetPropertyIndent(OutlineWidthMask);
                            });
                            UIHelper.DrawWithGroup(() => {
                                if(!isOpaque) {
                                        materialEditor.TexturePropertySingleLine(new GUIContent("Cutoff Mask & Range", "Cutoff Mask Texture & Range"), OutlineMask, OutlineCutoffRange);
                                        materialEditor.TextureScaleOffsetPropertyIndent(OutlineMask);
                                }else{
                                    EditorGUILayout.LabelField("Cutoff Mask & Range","Unavailable in Opaque", EditorStyles.centeredGreyMiniLabel);
                                }
                            });
                            UIHelper.DrawWithGroup(() => {
                                materialEditor.TexturePropertySingleLine(new GUIContent("Texture & Color", "Texture and Color"), OutlineTexture, OutlineColor);
                                materialEditor.TextureScaleOffsetPropertyIndent(OutlineTexture);
                                materialEditor.ShaderProperty(OutlineTextureColorRate,"Base & Shading Mix");
                                materialEditor.ShaderProperty(OutlineUseColorShift, "Use Color Shift");
                                var isEnabledOutlineColorShift = OutlineUseColorShift.floatValue;
                                if(isEnabledOutlineColorShift > 0) {
                                    EditorGUI.indentLevel ++;
                                    materialEditor.ShaderProperty(OutlineHueShiftFromBase, "Hue Shift");
                                    materialEditor.ShaderProperty(OutlineSaturationFromBase, "Saturation");
                                    materialEditor.ShaderProperty(OutlineValueFromBase, "Value");
                                    EditorGUI.indentLevel --;
                                }
                            });
                        });
                    }
                }

                // Gloss
                UIHelper.ShurikenHeader("Gloss", "9-gloss");
                materialEditor.DrawShaderPropertySameLine(UseGloss, true);
                var isEnabledGloss = UseGloss.floatValue;
                if(isEnabledGloss > 0)
                {
                    UIHelper.DrawWithGroup(() => {
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Smoothness & Mask", "Smoothness and Mask Texture"), GlossBlendMask, GlossBlend);
                            materialEditor.TextureScaleOffsetPropertyIndent(GlossBlendMask);
                        });
                        materialEditor.ShaderProperty(GlossPower, "Metallic");
                        materialEditor.ShaderProperty(GlossColor, "Color");
                    });
                }

                // MatCap
                UIHelper.ShurikenHeader("MatCap", "10-matcap");
                materialEditor.DrawShaderPropertySameLine(MatcapBlendMode, true);
                var useMatcap = MatcapBlendMode.floatValue;
                if(useMatcap != 3) // Not 'Unused'
                {
                    UIHelper.DrawWithGroup(() => {
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Blend & Mask", "Blend and Mask Texture"), MatcapBlendMask, MatcapBlend);
                            materialEditor.TextureScaleOffsetPropertyIndent(MatcapBlendMask);
                        });
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Texture & Color", "Color and Texture"), MatcapTexture, MatcapColor);
                            materialEditor.TextureScaleOffsetPropertyIndent(MatcapTexture);
                        });
                        materialEditor.ShaderProperty(MatcapNormalMix, "Normal Map mix");
                        materialEditor.ShaderProperty(MatcapShadeMix,"Shadow mix");
                    });
                }

                // Reflection
                UIHelper.ShurikenHeader("Reflection", "11-reflection");
                materialEditor.DrawShaderPropertySameLine(UseReflection, true);
                var useReflection = UseReflection.floatValue;
                if(useReflection > 0)
                {
                    UIHelper.DrawWithGroup(() => {
                        materialEditor.ShaderProperty(UseReflectionProbe,"Use Reflection Probe");
                        var useProbe = UseReflectionProbe.floatValue;
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Smoothness & Mask", "Smoothness and Mask Texture"), ReflectionReflectionMask, ReflectionReflectionPower);
                            materialEditor.TextureScaleOffsetPropertyIndent(ReflectionReflectionMask);
                        });
                        UIHelper.DrawWithGroup(() => {
                            var cubemapLabel = "Cubemap";
                            if(useProbe > 0) {
                                cubemapLabel += "(fallback)";
                            }
                            materialEditor.TexturePropertySingleLine(new GUIContent(cubemapLabel, cubemapLabel), ReflectionCubemap);
                            materialEditor.TextureScaleOffsetPropertyIndent(ReflectionCubemap);
                        });
                        materialEditor.ShaderProperty(ReflectionNormalMix,"Normal Map mix");
                        materialEditor.ShaderProperty(ReflectionShadeMix, "Shadow mix");
                        materialEditor.ShaderProperty(ReflectionSuppressBaseColorValue,"Suppress Base Color");
                    });
                }

                // Rim Light
                UIHelper.ShurikenHeader("Rim", "12-rim");
                materialEditor.DrawShaderPropertySameLine(UseRim, true);
                var useRim = UseRim.floatValue;
                if(useRim > 0)
                {
                    UIHelper.DrawWithGroup(() => {

                        materialEditor.ShaderProperty(RimBlendStart,"Blend Start");
                        materialEditor.ShaderProperty(RimBlendEnd,"Blend End");
                        materialEditor.ShaderProperty(RimPow,"Power type");

                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Blend & Mask", "Blend and Mask Texture"), RimBlendMask, RimBlend);
                            materialEditor.TextureScaleOffsetPropertyIndent(RimBlendMask);
                        });
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Texture & Color", "Texture and Color"), RimTexture, RimColor);
                            materialEditor.TextureScaleOffsetPropertyIndent(RimTexture);
                            materialEditor.ShaderProperty(RimUseBaseTexture,"Use Base Color");
                        });
                        materialEditor.ShaderProperty(RimShadeMix,"Shadow mix");
                    });
                }

                // Shade Cap
                UIHelper.ShurikenHeader("Shade Cap", "13-shadecap");
                materialEditor.DrawShaderPropertySameLine(ShadowCapBlendMode, true);
                var useShadowCap = ShadowCapBlendMode.floatValue;
                if(useShadowCap != 3) // Not 'Unused'
                {
                    UIHelper.DrawWithGroup(() => {
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Blend & Mask", "Blend and Mask Texture"), ShadowCapBlendMask, ShadowCapBlend);
                            materialEditor.TextureScaleOffsetPropertyIndent(ShadowCapBlendMask);
                        });
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Texture", "Texture"), ShadowCapTexture);
                            materialEditor.TextureScaleOffsetPropertyIndent(ShadowCapTexture);
                        });
                        materialEditor.ShaderProperty(ShadowCapNormalMix,"Normal Map mix");
                    });
                }

                // Stencil Writer
                if(isStencilWriter)
                {
                    UIHelper.ShurikenHeader("Stencil Writer", "14-stencils");
                    UIHelper.DrawWithGroup(() => {
                        materialEditor.ShaderProperty(StencilNumber,"Stencil Number");
                        materialEditor.TexturePropertySingleLine(new GUIContent("Stencil Mask & Range", "Stencil Mask and Range"), StencilMaskTex, StencilMaskAdjust);
                        materialEditor.TextureScaleOffsetPropertyIndent(StencilMaskTex);
                        materialEditor.ShaderProperty(StencilMaskAlphaDither, "Alpha(Dither)");
                    });
                }

                // Stencil Reader
                if(isStencilReader)
                {
                    UIHelper.ShurikenHeader("Stencil Reader", "14-stencils");
                    if(isStencilReaderDouble) {
                        UIHelper.DrawWithGroup(() => {
                            UIHelper.DrawWithGroup(() => {
                                EditorGUILayout.LabelField("Primary", EditorStyles.boldLabel);
                                EditorGUI.indentLevel++;
                                materialEditor.ShaderProperty(StencilNumber,"Stencil Number");
                                materialEditor.ShaderProperty(StencilCompareAction,"Compare Action");
                                EditorGUI.indentLevel--;
                            });
                            UIHelper.DrawWithGroup(() => {
                                EditorGUILayout.LabelField("Secondary", EditorStyles.boldLabel);
                                EditorGUI.indentLevel++;
                                materialEditor.ShaderProperty(StencilNumberSecondary,"Stencil Number");
                                materialEditor.ShaderProperty(StencilCompareActionSecondary,"Compare Action");
                                EditorGUI.indentLevel--;
                            });
                        });
                    } else {
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.ShaderProperty(StencilNumber,"Number");
                            materialEditor.ShaderProperty(StencilCompareAction,"Compare Action");
                        });
                    }
                }

                // Parallax Emission
                UIHelper.ShurikenHeader("Parallaxed Emission", "15-parallax");
                materialEditor.DrawShaderPropertySameLine(UseEmissionParallax, true);
                var useEmissionPara = UseEmissionParallax.floatValue;
                if(useEmissionPara > 0){
                    UIHelper.DrawWithGroup(() => {
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Texture & Color", "Texture and Color"), EmissionParallaxTex, EmissionParallaxColor);
                            materialEditor.TextureScaleOffsetPropertyIndent(EmissionParallaxTex);
                        });
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("TexCol Mask", "Texture and Color Mask"), EmissionParallaxMask);
                            materialEditor.TextureScaleOffsetPropertyIndent(EmissionParallaxMask);
                        });
                        UIHelper.DrawWithGroup(() => {
                            materialEditor.TexturePropertySingleLine(new GUIContent("Depth & Mask", "Depth and Mask Texture"), EmissionParallaxDepthMask, EmissionParallaxDepth);
                            materialEditor.TextureScaleOffsetPropertyIndent(EmissionParallaxDepthMask);
                            materialEditor.ShaderProperty(EmissionParallaxDepthMaskInvert, "Invert Depth Mask");
                        });
                    });
                }

                // Scrolled Emission
                if(isEmissiveFreak)
                {
                    UIHelper.ShurikenHeader("Emissive Freak", "16-emissivefreak");
                    UIHelper.DrawWithGroup(() => {
                        UIHelper.DrawWithGroup(() => {
                            EditorGUILayout.LabelField("1st", EditorStyles.boldLabel);
                            UIHelper.DrawWithGroup(() => {
                                materialEditor.TexturePropertySingleLine(new GUIContent("Texture & Color", "Texture and Color"), EmissiveFreak1Tex, EmissiveFreak1Color);
                                materialEditor.TextureScaleOffsetPropertyIndent(EmissiveFreak1Tex);
                                materialEditor.TexturePropertySingleLine(new GUIContent("TexCol Mask", "Texture and Color Mask"), EmissiveFreak1Mask);
                                materialEditor.TextureScaleOffsetPropertyIndent(EmissiveFreak1Mask);
                                UIHelper.DrawWithGroup(() => {
                                    materialEditor.ShaderProperty(EmissiveFreak1U, "Scroll U");
                                    materialEditor.ShaderProperty(EmissiveFreak1V, "Scroll V");
                                });
                                UIHelper.DrawWithGroup(() => {
                                    materialEditor.TexturePropertySingleLine(new GUIContent("Depth & Mask", "Depth and Mask Texture"), EmissiveFreak1DepthMask, EmissiveFreak1Depth);
                                    materialEditor.TextureScaleOffsetPropertyIndent(EmissiveFreak1DepthMask);
                                    materialEditor.ShaderProperty(EmissiveFreak1DepthMaskInvert, "Invert Depth Mask");
                                });
                                UIHelper.DrawWithGroup(() => {
                                    materialEditor.ShaderProperty(EmissiveFreak1Breathing, "Breathing");
                                    materialEditor.ShaderProperty(EmissiveFreak1BreathingMix, "Breathing Mix");
                                    materialEditor.ShaderProperty(EmissiveFreak1BlinkOut, "Blink Out");
                                    materialEditor.ShaderProperty(EmissiveFreak1BlinkOutMix, "Blink Out Mix");
                                    materialEditor.ShaderProperty(EmissiveFreak1BlinkIn, "Blink In");
                                    materialEditor.ShaderProperty(EmissiveFreak1BlinkInMix, "Blink In Mix");
                                    materialEditor.ShaderProperty(EmissiveFreak1HueShift, "Hue Shift");
                                });
                            });
                        });

                        UIHelper.DrawWithGroup(() => {
                            EditorGUILayout.LabelField("2nd", EditorStyles.boldLabel);
                            UIHelper.DrawWithGroup(() => {
                                materialEditor.TexturePropertySingleLine(new GUIContent("Texture & Color", "Texture and Color"), EmissiveFreak2Tex, EmissiveFreak2Color);
                                materialEditor.TextureScaleOffsetPropertyIndent(EmissiveFreak2Tex);
                                materialEditor.TexturePropertySingleLine(new GUIContent("TexCol Mask", "Texture and Color Mask"), EmissiveFreak2Mask);
                                materialEditor.TextureScaleOffsetPropertyIndent(EmissiveFreak2Mask);
                                UIHelper.DrawWithGroup(() => {
                                    materialEditor.ShaderProperty(EmissiveFreak2U, "Scroll U");
                                    materialEditor.ShaderProperty(EmissiveFreak2V, "Scroll V");
                                });
                                UIHelper.DrawWithGroup(() => {
                                    materialEditor.TexturePropertySingleLine(new GUIContent("Depth & Mask", "Depth and Mask Texture"), EmissiveFreak2DepthMask, EmissiveFreak2Depth);
                                    materialEditor.TextureScaleOffsetPropertyIndent(EmissiveFreak2DepthMask);
                                    materialEditor.ShaderProperty(EmissiveFreak2DepthMaskInvert, "Invert Depth Mask");
                                });
                                UIHelper.DrawWithGroup(() => {
                                    materialEditor.ShaderProperty(EmissiveFreak2Breathing, "Breathing");
                                    materialEditor.ShaderProperty(EmissiveFreak2BreathingMix, "Breathing Mix");
                                    materialEditor.ShaderProperty(EmissiveFreak2BlinkOut, "Blink Out");
                                    materialEditor.ShaderProperty(EmissiveFreak2BlinkOutMix, "Blink Out Mix");
                                    materialEditor.ShaderProperty(EmissiveFreak2BlinkIn, "Blink In");
                                    materialEditor.ShaderProperty(EmissiveFreak2BlinkInMix, "Blink In Mix");
                                    materialEditor.ShaderProperty(EmissiveFreak2HueShift, "Hue Shift");
                                });
                            });
                        });
                    });
                }

                // Proximity color override
                UIHelper.ShurikenHeader("Proximity Color Override", "17-proximitycolor");
                var useProximityOverride = MatP("_UseProximityOverride", props, false);
                materialEditor.DrawShaderPropertySameLine(useProximityOverride, true);
                if(useProximityOverride.floatValue > 0)
                {
                    UIHelper.DrawWithGroup(() => {
                        UIHelper.DrawWithGroup(() => {
                            // if (isFade) materialEditor.ShaderProperty(MatP("_ProximityOverrideAlphaOnly", props, false), "Alpha channel only");

                            var begin = MatP("_ProximityOverrideBegin", props, false);
                            var end = MatP("_ProximityOverrideEnd", props, false);
                            // materialEditor.ShaderProperty(MatP("_ProximityOverrideColor", props, false), "Color");
                            materialEditor.ShaderProperty(begin, "Begin(far)");
                            materialEditor.ShaderProperty(end, "End(near)");
                            EditorGUILayout.LabelField("Override Color", EditorStyles.boldLabel);
                            EditorGUI.indentLevel ++;
                            materialEditor.ShaderProperty(MatP("_ProximityOverrideHueShiftFromBase", props, false), "Hue Shift");
                            materialEditor.ShaderProperty(MatP("_ProximityOverrideSaturationFromBase", props, false), "Saturation");
                            materialEditor.ShaderProperty(MatP("_ProximityOverrideValueFromBase", props, false), "Value");
                            EditorGUI.indentLevel --;
                            if (isFade) {
                                EditorGUILayout.LabelField("Alpha", EditorStyles.boldLabel);
                                EditorGUI.indentLevel ++;
                                materialEditor.ShaderProperty(MatP("_ProximityOverrideAlphaScale", props, false), "Scale");
                                EditorGUI.indentLevel --;
                            }
                        });
                    });
                } else {
                    MatPVoid(
                        "_ProximityOverrideBegin",
                        "_ProximityOverrideEnd",
                        "_ProximityOverrideHueShiftFromBase",
                        "_ProximityOverrideSaturationFromBase",
                        "_ProximityOverrideValueFromBase",
                        "_ProximityOverrideAlphaScale"
                    );
                }

                // Advanced / Experimental
                IsShowAdvanced = UIHelper.ShurikenFoldout("Advanced / Experimental", IsShowAdvanced, "18-advanced");
                if (IsShowAdvanced) {
                    UIHelper.DrawWithGroup(() => {
                        if (GUILayout.Button("Revert advanced params.")){
                            PointAddIntensity.floatValue = 1f;
                            PointShadowStrength.floatValue = 0.5f;
                            PointShadowborder.floatValue = 0.5f;
                            PointShadowborderBlur.floatValue = 0.01f;
                            PointShadowborderBlurMask.textureValue = null;
                            VertexColorBlendDiffuse.floatValue = 0f;
                            VertexColorBlendEmissive.floatValue = 0f;
                        }
                        UIHelper.DrawWithGroup(() => {
                            EditorGUILayout.LabelField("Vertex Colors", EditorStyles.boldLabel);
                            EditorGUI.indentLevel ++;
                            materialEditor.ShaderProperty(VertexColorBlendDiffuse, "Color blend to diffuse (def:0) ");
                            materialEditor.ShaderProperty(VertexColorBlendEmissive, "Color blend to emissive (def:0) ");
                            EditorGUI.indentLevel --;
                        });
                        UIHelper.DrawWithGroup(() => {
                            EditorGUILayout.LabelField("PointLights", EditorStyles.boldLabel);
                            EditorGUI.indentLevel ++;
                            materialEditor.ShaderProperty(PointAddIntensity, "Intensity (def:1)");
                            materialEditor.ShaderProperty(PointShadowStrength, "Shadow Strength (def:0.5)");
                            materialEditor.ShaderProperty(PointShadowborder, "Shadow Border (def:0.5)");
                            materialEditor.ShaderProperty(PointShadowborderBlur, "Shadow Border blur (def:0.01)");
                            materialEditor.ShaderProperty(PointShadowborderBlurMask, "Shadow Border blur Mask(def:none)");
                            EditorGUI.indentLevel --;
                        });
                    });
                }

                // Unregisteredprops
                IsShowNonRegistered = UIHelper.ShurikenFoldout("Non-Registered Properties", IsShowNonRegistered, "19-nonregistered");
                if(IsShowNonRegistered) {
                     DrawNonRegisteredProperties(materialEditor, props);
                }
            }
            EditorGUI.EndChangeCheck();
        }

        List<string> registeredProperties = new List<string>();

        public void ClearRegisteredPropertiesList() {
            registeredProperties.Clear();
        }

        public MaterialProperty MatP(string propertyName, MaterialProperty[] properties, bool propertyIsMandatory) {
            if (!registeredProperties.Contains(propertyName)) registeredProperties.Add(propertyName);
            return FindProperty(propertyName, properties, propertyIsMandatory);
        }

        public void MatPVoid(params string[] propertyNames) {
            if (!registeredProperties.Any(propertyNames.Contains)) registeredProperties.AddRange(propertyNames);
        }

        public void DrawNonRegisteredProperties(MaterialEditor materialEditor, MaterialProperty[] props) {
            Material material = materialEditor.target as Material;
            var propCounts = ShaderUtil.GetPropertyCount(material.shader);
            for(var i = 0; i < propCounts; ++i) {
                var shName = ShaderUtil.GetPropertyName(material.shader, i);
                if (!registeredProperties.Contains(shName)) {
                    MaterialProperty p = FindProperty(shName, props, false);
                    materialEditor.ShaderProperty(p, shName);
                }
            }
        }

        // デフォルトのRampテクスチャを割り当てる
        private void AssignDefaultRampTexture(MaterialProperty rampProperty) {
            rampProperty.textureValue = (Texture2D)AssetDatabase.LoadAssetAtPath(AxCommon.GetBaseDir() + "Textures/Ramp_Default.png", typeof(Texture2D));
        }
    }

    static class UIHelper
    {
        static int HEADER_HEIGHT = 22;

        static float HEADER_TEXT_PADDING = 6f;
        static float HEADER_TEXT_FOLDOUT_MARGIN = 14f;

        public static void DrawShaderPropertySameLine(this MaterialEditor editor, MaterialProperty property, bool hasTooltip = false) {
            Rect r = EditorGUILayout.GetControlRect(true,0,EditorStyles.layerMaskField);
            r.y -= HEADER_HEIGHT;
            r.height = MaterialEditor.GetDefaultPropertyHeight(property);
            r.width -= HEADER_TEXT_PADDING + (hasTooltip ? 24 : 0);
            editor.ShaderProperty(r, property, " ");
        }

        private static Rect DrawShuriken(string title, Vector2 contentOffset, string docPath) {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.margin = new RectOffset(0, 0, 8, 0);
            style.font = new GUIStyle(EditorStyles.boldLabel).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = HEADER_HEIGHT;
            style.contentOffset = contentOffset;

            if (!string.IsNullOrEmpty(docPath)) {
                style.margin.right = 24;
            }

            var rect = GUILayoutUtility.GetRect(16f, HEADER_HEIGHT, style);
            GUI.Box(rect, title, style);

            if (!string.IsNullOrEmpty(docPath)) {
                var name = "_Help";
                var icon = EditorGUIUtility.IconContent( name );
                var r = GUILayoutUtility.GetLastRect();
                r.x += r.width;
                r.width = 24;
                style = new GUIStyle();
                style.alignment = TextAnchor.MiddleCenter;
                if (GUI.Button(r, icon, style )){
                    AxDocs.Open(docPath);
                }
            }

            return rect;
        }
        public static void ShurikenHeader(string title, string docPath = "")
        {
            DrawShuriken(title,new Vector2(HEADER_TEXT_PADDING, -2f), docPath);
        }
        public static bool ShurikenFoldout(string title, bool display, string docPath = "")
        {
            var rect = DrawShuriken(title,new Vector2(HEADER_TEXT_FOLDOUT_MARGIN + HEADER_TEXT_PADDING, -2f), docPath);
            var e = Event.current;
            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == EventType.Repaint) {
                EditorStyles.foldout.Draw(toggleRect, false, false, display, false);
            }
            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition)) {
                display = !display;
                e.Use();
            }
            return display;
        }
        public static void Vector2Property(MaterialProperty property, string name)
        {
            EditorGUI.BeginChangeCheck();
            Vector2 vector2 = EditorGUILayout.Vector2Field(name,new Vector2(property.vectorValue.x, property.vectorValue.y),null);
            if (EditorGUI.EndChangeCheck())
                property.vectorValue = new Vector4(vector2.x, vector2.y);
        }
        public static void Vector4Property(MaterialProperty property, string name)
        {
            EditorGUI.BeginChangeCheck();
            Vector4 vector4 = EditorGUILayout.Vector2Field(name,property.vectorValue,null);
            if (EditorGUI.EndChangeCheck())
                property.vectorValue = vector4;
        }
        public static void Vector2PropertyZW(MaterialProperty property, string name)
        {
            EditorGUI.BeginChangeCheck();
            Vector2 vector2 = EditorGUILayout.Vector2Field(name,new Vector2(property.vectorValue.x, property.vectorValue.y),null);
            if (EditorGUI.EndChangeCheck())
                property.vectorValue = new Vector4(vector2.x, vector2.y);
        }
        public static void TextureScaleOffsetPropertyIndent(this MaterialEditor editor, MaterialProperty property)
        {
            EditorGUI.indentLevel ++;
            editor.TextureScaleOffsetProperty(property);
            EditorGUI.indentLevel --;
        }
        public static void DrawWithGroup(Action action)
        {
            EditorGUILayout.BeginVertical( GUI.skin.box );
            action();
            EditorGUILayout.EndVertical();
        }
        public static void DrawWithGroupHorizontal(Action action)
        {
            EditorGUILayout.BeginHorizontal( GUI.skin.box );
            action();
            EditorGUILayout.EndHorizontal();
        }
    }

    // シェーダーキーワードを作らないToggle（UIToggleだと面倒そうだったので）
    internal class MaterialAXCSToggleDrawer : MaterialPropertyDrawer
    {
        public MaterialAXCSToggleDrawer()
        {
        }

        public MaterialAXCSToggleDrawer(string keyword)
        {
        }

        protected virtual void SetKeyword(MaterialProperty prop, bool on)
        {
        }

        static bool IsPropertyTypeSuitable(MaterialProperty prop)
        {
            return prop.type == MaterialProperty.PropType.Float || prop.type == MaterialProperty.PropType.Range;
        }

        public override float GetPropertyHeight(MaterialProperty prop, string label, MaterialEditor editor)
        {
            return base.GetPropertyHeight(prop, label, editor);
        }

        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            EditorGUI.BeginChangeCheck();

            bool value = (Math.Abs(prop.floatValue) > 0.001f);
            EditorGUI.showMixedValue = prop.hasMixedValue;
            value = EditorGUI.Toggle(position, label, value);
            EditorGUI.showMixedValue = false;
            if (EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value ? 1.0f : 0.0f;
                SetKeyword(prop, value);
            }
        }

        public override void Apply(MaterialProperty prop)
        {
            base.Apply(prop);
            if (!IsPropertyTypeSuitable(prop))
                return;

            if (prop.hasMixedValue)
                return;

            SetKeyword(prop, (Math.Abs(prop.floatValue) > 0.001f));
        }
    }

    // Rampテクスチャのためのプロパティ
    internal class MaterialAXCSRampDrawer : MaterialPropertyDrawer
    {
        int pickerControlId;

        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            var texture = prop.textureValue;
            var pos = new Rect(position.x+1, position.y+1, position.width-2, position.height-2);

            // 枠
            GUI.DrawTexture(position, Texture2D.whiteTexture, ScaleMode.StretchToFill, false, 0, Color.grey, 1, 1);

            // テクスチャが設定されていれば
            if (texture != null)
            {
                EditorGUI.DrawPreviewTexture(pos, texture);
            }

            // クリック時（シングル：アセットコンテンツをハイライト　ダブル：Pickerウィンドウ）
            if (Event.current.isMouse && Event.current.type == EventType.MouseDown)
            {
                if(pos.Contains(Event.current.mousePosition))
                {
                    if (Event.current.clickCount == 2) {
                        pickerControlId = EditorGUIUtility.GetControlID(FocusType.Passive);
                        EditorGUIUtility.ShowObjectPicker<Texture>(texture, false, "", pickerControlId);
                    }
                    else {
                        EditorGUIUtility.PingObject(texture);
                    }
                    return;
                }
            }

            // PickerでPickされたテクスチャを反映
            if (Event.current.commandName == "ObjectSelectorUpdated" ||
                Event.current.commandName == "ObjectSelectorClosed") {
                if (EditorGUIUtility.GetObjectPickerControlID() == pickerControlId){
                    prop.textureValue = (Texture)EditorGUIUtility.GetObjectPickerObject ();
                    return;
                }
            }

            // ドラッグ＆ドロップ
            if (Event.current.type == EventType.DragUpdated || Event.current.type == EventType.DragPerform) {
                if(pos.Contains(Event.current.mousePosition)) {
                    var objs = DragAndDrop.objectReferences;
                    if (objs.Length == 1 && objs[0].GetType() == typeof(Texture2D)) {
                        DragAndDrop.visualMode = DragAndDropVisualMode.Copy;
                        DragAndDrop.activeControlID = GUIUtility.GetControlID(FocusType.Passive);
                        if (Event.current.type == EventType.DragPerform)
                        {
                            DragAndDrop.activeControlID = 0;
                            DragAndDrop.AcceptDrag();
                            prop.textureValue = (Texture)objs[0];
                            return;
                        }
                    }
                }
            }
        }
    }
}