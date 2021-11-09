//--------------------------------------------------------------
//--------------------------------------------------------------
//              Sunao Shader GUI
//                      Copyright (c) 2021 揚茄子研究所
//
// This software is released under the MIT License.
// see LICENSE or http://sunao.orz.hm/agenasulab/ss/LICENSE
//--------------------------------------------------------------

using UnityEngine;
using UnityEditor;
using System.Collections.Generic;
using System.Linq;
using System;

namespace SunaoShader {

	public class GUI : ShaderGUI {

		MaterialProperty MainTex;
		MaterialProperty Color;
		MaterialProperty Alpha;
		MaterialProperty Cutout;
		MaterialProperty BumpMap;
		MaterialProperty OcclusionMap;
		MaterialProperty AlphaMask;
		MaterialProperty Bright;
		MaterialProperty BumpScale;
		MaterialProperty OcclusionStrength;
		MaterialProperty OcclusionMode;
		MaterialProperty AlphaMaskStrength;
		MaterialProperty VertexColor;
		MaterialProperty UVScrollX;
		MaterialProperty UVScrollY;
		MaterialProperty UVAnimation;
		MaterialProperty UVAnimX;
		MaterialProperty UVAnimY;
		MaterialProperty UVAnimOtherTex;

		MaterialProperty DecalEnable;
		MaterialProperty DecalTex;
		MaterialProperty DecalColor;
		MaterialProperty DecalPosX;
		MaterialProperty DecalPosY;
		MaterialProperty DecalSizeX;
		MaterialProperty DecalSizeY;
		MaterialProperty DecalRotation;
		MaterialProperty DecalMode;
		MaterialProperty DecalMirror;
		MaterialProperty DecalBright;
		MaterialProperty DecalEmission;
		MaterialProperty DecalScrollX;
		MaterialProperty DecalScrollY;
		MaterialProperty DecalAnimation;
		MaterialProperty DecalAnimX;
		MaterialProperty DecalAnimY;

		MaterialProperty StencilNumb;
		MaterialProperty StencilCompMode;

		MaterialProperty ShadeMask;
		MaterialProperty Shade;
		MaterialProperty ShadeWidth;
		MaterialProperty ShadeGradient;
		MaterialProperty ShadeColor;
		MaterialProperty CustomShadeColor;
		MaterialProperty ToonEnable;
		MaterialProperty Toon;
		MaterialProperty ToonSharpness;
		MaterialProperty LightMask;
		MaterialProperty LightBoost;
		MaterialProperty Unlit;
		MaterialProperty MonochromeLit;

		MaterialProperty OutLineEnable;
		MaterialProperty OutLineMask;
		MaterialProperty OutLineColor;
		MaterialProperty OutLineSize;
		MaterialProperty OutLineLighting;
		MaterialProperty OutLineTexColor;
		MaterialProperty OutLineTexture;
		MaterialProperty OutLineFixScale;

		MaterialProperty EmissionEnable;
		MaterialProperty EmissionMap;
		MaterialProperty EmissionColor;
		MaterialProperty Emission;
		MaterialProperty EmissionMap2;
		MaterialProperty EmissionMode;
		MaterialProperty EmissionBlink;
		MaterialProperty EmissionFrequency;
		MaterialProperty EmissionWaveform;
		MaterialProperty EmissionScrX;
		MaterialProperty EmissionScrY;
		MaterialProperty EmissionAnimation;
		MaterialProperty EmissionAnimX;
		MaterialProperty EmissionAnimY;
		MaterialProperty EmissionLighting;
		MaterialProperty IgnoreTexAlphaE;
		MaterialProperty EmissionInTheDark;

		MaterialProperty ParallaxEnable;
		MaterialProperty ParallaxMap;
		MaterialProperty ParallaxColor;
		MaterialProperty ParallaxEmission;
		MaterialProperty ParallaxDepth;
		MaterialProperty ParallaxDepthMap;
		MaterialProperty ParallaxMap2;
		MaterialProperty ParallaxMode;
		MaterialProperty ParallaxBlink;
		MaterialProperty ParallaxFrequency;
		MaterialProperty ParallaxWaveform;
		MaterialProperty ParallaxPhaseOfs;
		MaterialProperty ParallaxScrX;
		MaterialProperty ParallaxScrY;
		MaterialProperty ParallaxAnimation;
		MaterialProperty ParallaxAnimX;
		MaterialProperty ParallaxAnimY;
		MaterialProperty ParallaxLighting;
		MaterialProperty IgnoreTexAlphaPE;	 
		MaterialProperty ParallaxInTheDark;

		MaterialProperty ReflectionEnable;
		MaterialProperty MetallicGlossMap;
		MaterialProperty GlossColor;
		MaterialProperty Specular;
		MaterialProperty Metallic;
		MaterialProperty GlossMapScale;
		MaterialProperty MatCap;
		MaterialProperty MatCapColor;
		MaterialProperty MatCapMaskEnable;
		MaterialProperty MatCapMask;
		MaterialProperty MatCapStrength;
		MaterialProperty ToonGlossEnable;
		MaterialProperty ToonGloss;
		MaterialProperty ToonGlossShift;
		MaterialProperty SpecularTexColor;
		MaterialProperty MetallicTexColor;
		MaterialProperty MatCapTexColor;
		MaterialProperty SpecularSH;
		MaterialProperty SpecularMask;
		MaterialProperty ReflectLit;
		MaterialProperty MatCapLit;
		MaterialProperty IgnoreTexAlphaR;

		MaterialProperty RimLitEnable;
		MaterialProperty RimLitMask;
		MaterialProperty RimLitColor;
		MaterialProperty RimLit;
		MaterialProperty RimLitGradient;
		MaterialProperty RimLitLighting;
		MaterialProperty RimLitTexColor;
		MaterialProperty RimLitMode;
		MaterialProperty IgnoreTexAlphaRL;

		MaterialProperty Culling;
		MaterialProperty EnableZWrite;
		MaterialProperty IgnoreProjector;
		MaterialProperty DirectionalLight;
		MaterialProperty SHLight;
		MaterialProperty PointLight;
		MaterialProperty LightLimitter;
		MaterialProperty MinimumLight;
		MaterialProperty BlendOperation;
		MaterialProperty EnableGammaFix;
		MaterialProperty GammaR;
		MaterialProperty GammaG;
		MaterialProperty GammaB;
		MaterialProperty EnableBlightFix;
		MaterialProperty BlightOutput;
		MaterialProperty BlightOffset;
		MaterialProperty LimitterEnable;
		MaterialProperty LimitterMax;


		bool    MainFoldout       = false;
		bool    DecalFoldout      = false;
		bool    ShadingFoldout    = false;
		bool    OutlineFoldout    = false;
		bool    EmissionFoldout   = false;
		bool    ParallaxFoldout   = false;
		bool    ReflectionFoldout = false;
		bool    RimLightFoldout   = false;
		bool    OtherFoldout      = false;

		bool    OnceRun           = true;

		int     Version_H         = 1;
		int     Version_M         = 4;
		int     Version_L         = 4;

		int     VersionC          = 0;
		int     VersionM          = 0;

		public override void OnGUI(MaterialEditor ME , MaterialProperty[] Prop) {

			var mat = (Material)ME.target;

			bool Shader_Opaque      = mat.shader.name.Contains("Opaque"           );
			bool Shader_Transparent = mat.shader.name.Contains("Transparent"      );
			bool Shader_Cutout      = mat.shader.name.Contains("Cutout"           );
			bool Shader_StencilOut  = mat.shader.name.Contains("[Stencil Outline]");
			bool Shader_Stencil     = mat.shader.name.Contains("[Stencil]"        );
			bool Shader_StencilRW   = mat.shader.name.Contains("Read"             );

			int  Shader_Type        = 0;
			int  Previous_Type      = mat.GetInt("_SunaoShaderType");

			if (Shader_Opaque) {
				if (Shader_StencilOut) {
					Shader_Type = 3;
				} else {
					Shader_Type = 0;
				}
			}
			if (Shader_Transparent) {
				if (Shader_StencilOut) {
					Shader_Type = 4;
				} else {
					Shader_Type = 1;
				}
			}
			if (Shader_Cutout) {
				if (Shader_StencilOut) {
					Shader_Type = 5;
				} else {
					Shader_Type = 2;
				}
			}
			if (Shader_Stencil) {
				if (Shader_StencilRW) {
					Shader_Type = 6;
				} else {
					Shader_Type = 7;
				}
			}

			if ((Shader_Type) != (Previous_Type)) OnceRun = true;


			MainTex           = FindProperty("_MainTex"           , Prop , false);
			Color             = FindProperty("_Color"             , Prop , false);
			Alpha             = FindProperty("_Alpha"             , Prop , false);
			Cutout            = FindProperty("_Cutout"            , Prop , false);
			BumpMap           = FindProperty("_BumpMap"           , Prop , false);
			OcclusionMap      = FindProperty("_OcclusionMap"      , Prop , false);
			AlphaMask         = FindProperty("_AlphaMask"         , Prop , false);
			Bright            = FindProperty("_Bright"            , Prop , false);
			BumpScale         = FindProperty("_BumpScale"         , Prop , false);
			OcclusionStrength = FindProperty("_OcclusionStrength" , Prop , false);
			OcclusionMode     = FindProperty("_OcclusionMode"     , Prop , false);
			AlphaMaskStrength = FindProperty("_AlphaMaskStrength" , Prop , false);
			VertexColor       = FindProperty("_VertexColor"       , Prop , false);
			UVScrollX         = FindProperty("_UVScrollX"         , Prop , false);
			UVScrollY         = FindProperty("_UVScrollY"         , Prop , false);
			UVAnimation       = FindProperty("_UVAnimation"       , Prop , false);
			UVAnimX           = FindProperty("_UVAnimX"           , Prop , false);
			UVAnimY           = FindProperty("_UVAnimY"           , Prop , false);
			UVAnimOtherTex    = FindProperty("_UVAnimOtherTex"    , Prop , false);

			DecalEnable       = FindProperty("_DecalEnable"       , Prop , false);
			DecalTex          = FindProperty("_DecalTex"          , Prop , false);
			DecalColor        = FindProperty("_DecalColor"        , Prop , false);
			DecalPosX         = FindProperty("_DecalPosX"         , Prop , false);
			DecalPosY         = FindProperty("_DecalPosY"         , Prop , false);
			DecalSizeX        = FindProperty("_DecalSizeX"        , Prop , false);
			DecalSizeY        = FindProperty("_DecalSizeY"        , Prop , false);
			DecalRotation     = FindProperty("_DecalRotation"     , Prop , false);
			DecalMode         = FindProperty("_DecalMode"         , Prop , false);
			DecalMirror       = FindProperty("_DecalMirror"       , Prop , false);
			DecalBright       = FindProperty("_DecalBright"       , Prop , false);
			DecalEmission     = FindProperty("_DecalEmission"     , Prop , false);
			DecalScrollX      = FindProperty("_DecalScrollX"      , Prop , false);
			DecalScrollY      = FindProperty("_DecalScrollY"      , Prop , false);
			DecalAnimation    = FindProperty("_DecalAnimation"    , Prop , false);
			DecalAnimX        = FindProperty("_DecalAnimX"        , Prop , false);
			DecalAnimY        = FindProperty("_DecalAnimY"        , Prop , false);

			StencilNumb       = FindProperty("_StencilNumb"       , Prop , false);
			StencilCompMode   = FindProperty("_StencilCompMode"   , Prop , false);

			ShadeMask         = FindProperty("_ShadeMask"         , Prop , false);
			Shade             = FindProperty("_Shade"             , Prop , false);
			ShadeWidth        = FindProperty("_ShadeWidth"        , Prop , false);
			ShadeGradient     = FindProperty("_ShadeGradient"     , Prop , false);
			ShadeColor        = FindProperty("_ShadeColor"        , Prop , false);
			CustomShadeColor  = FindProperty("_CustomShadeColor"  , Prop , false);

			ToonEnable        = FindProperty("_ToonEnable"        , Prop , false);
			Toon              = FindProperty("_Toon"              , Prop , false);
			ToonSharpness     = FindProperty("_ToonSharpness"     , Prop , false);

			LightMask         = FindProperty("_LightMask"         , Prop , false);
			LightBoost        = FindProperty("_LightBoost"        , Prop , false);
			Unlit             = FindProperty("_Unlit"             , Prop , false);
			MonochromeLit     = FindProperty("_MonochromeLit"     , Prop , false);

			OutLineEnable     = FindProperty("_OutLineEnable"     , Prop , false);
			OutLineMask       = FindProperty("_OutLineMask"       , Prop , false);
			OutLineColor      = FindProperty("_OutLineColor"      , Prop , false);
			OutLineSize       = FindProperty("_OutLineSize"       , Prop , false);
			OutLineLighting   = FindProperty("_OutLineLighthing"  , Prop , false);
			OutLineTexColor   = FindProperty("_OutLineTexColor"   , Prop , false);
			OutLineTexture    = FindProperty("_OutLineTexture"    , Prop , false);
			OutLineFixScale   = FindProperty("_OutLineFixScale"   , Prop , false);

			EmissionEnable    = FindProperty("_EmissionEnable"    , Prop , false);
			EmissionMap       = FindProperty("_EmissionMap"       , Prop , false);
			EmissionColor     = FindProperty("_EmissionColor"     , Prop , false);
			Emission          = FindProperty("_Emission"          , Prop , false);
			EmissionMap2      = FindProperty("_EmissionMap2"      , Prop , false);
			EmissionMode      = FindProperty("_EmissionMode"      , Prop , false);
			EmissionBlink     = FindProperty("_EmissionBlink"     , Prop , false);
			EmissionFrequency = FindProperty("_EmissionFrequency" , Prop , false);
			EmissionWaveform  = FindProperty("_EmissionWaveform"  , Prop , false);
			EmissionScrX      = FindProperty("_EmissionScrX"      , Prop , false);
			EmissionScrY      = FindProperty("_EmissionScrY"      , Prop , false);
			EmissionAnimation = FindProperty("_EmissionAnimation" , Prop , false);
			EmissionAnimX     = FindProperty("_EmissionAnimX"     , Prop , false);
			EmissionAnimY     = FindProperty("_EmissionAnimY"     , Prop , false);
			EmissionLighting  = FindProperty("_EmissionLighting"  , Prop , false);
			IgnoreTexAlphaE   = FindProperty("_IgnoreTexAlphaE"   , Prop , false);
			EmissionInTheDark = FindProperty("_EmissionInTheDark" , Prop , false);

			ParallaxEnable    = FindProperty("_ParallaxEnable"    , Prop , false);
			ParallaxMap       = FindProperty("_ParallaxMap"       , Prop , false);
			ParallaxColor     = FindProperty("_ParallaxColor"     , Prop , false);
			ParallaxEmission  = FindProperty("_ParallaxEmission"  , Prop , false);
			ParallaxDepth     = FindProperty("_ParallaxDepth"     , Prop , false);
			ParallaxDepthMap  = FindProperty("_ParallaxDepthMap"  , Prop , false);
			ParallaxMap2      = FindProperty("_ParallaxMap2"      , Prop , false);
			ParallaxMode      = FindProperty("_ParallaxMode"      , Prop , false);
			ParallaxBlink     = FindProperty("_ParallaxBlink"     , Prop , false);
			ParallaxFrequency = FindProperty("_ParallaxFrequency" , Prop , false);
			ParallaxWaveform  = FindProperty("_ParallaxWaveform"  , Prop , false);
			ParallaxPhaseOfs  = FindProperty("_ParallaxPhaseOfs"  , Prop , false);
			ParallaxScrX      = FindProperty("_ParallaxScrX"      , Prop , false);
			ParallaxScrY      = FindProperty("_ParallaxScrY"      , Prop , false);
			ParallaxAnimation = FindProperty("_ParallaxAnimation" , Prop , false);
			ParallaxAnimX     = FindProperty("_ParallaxAnimX"     , Prop , false);
			ParallaxAnimY     = FindProperty("_ParallaxAnimY"     , Prop , false);
			ParallaxLighting  = FindProperty("_ParallaxLighting"  , Prop , false);
			IgnoreTexAlphaPE  = FindProperty("_IgnoreTexAlphaPE"  , Prop , false);
			ParallaxInTheDark = FindProperty("_ParallaxInTheDark" , Prop , false);

			ReflectionEnable  = FindProperty("_ReflectionEnable"  , Prop , false);
			MetallicGlossMap  = FindProperty("_MetallicGlossMap"  , Prop , false);
			GlossColor        = FindProperty("_GlossColor"        , Prop , false);
			Specular          = FindProperty("_Specular"          , Prop , false);
			Metallic          = FindProperty("_Metallic"          , Prop , false);
			GlossMapScale     = FindProperty("_GlossMapScale"     , Prop , false);
			MatCap            = FindProperty("_MatCap"            , Prop , false);
			MatCapColor       = FindProperty("_MatCapColor"       , Prop , false);
			MatCapMaskEnable  = FindProperty("_MatCapMaskEnable"  , Prop , false);
			MatCapMask        = FindProperty("_MatCapMask"        , Prop , false);
			MatCapStrength    = FindProperty("_MatCapStrength"    , Prop , false);
			ToonGlossEnable   = FindProperty("_ToonGlossEnable"   , Prop , false);
			ToonGloss         = FindProperty("_ToonGloss"         , Prop , false);
			SpecularTexColor  = FindProperty("_SpecularTexColor"  , Prop , false);
			MetallicTexColor  = FindProperty("_MetallicTexColor"  , Prop , false);
			MatCapTexColor    = FindProperty("_MatCapTexColor"    , Prop , false);
			SpecularSH        = FindProperty("_SpecularSH"        , Prop , false);
			SpecularMask      = FindProperty("_SpecularMask"      , Prop , false);
			ReflectLit        = FindProperty("_ReflectLit"        , Prop , false);
			MatCapLit         = FindProperty("_MatCapLit"         , Prop , false);
			IgnoreTexAlphaR   = FindProperty("_IgnoreTexAlphaR"   , Prop , false);

			RimLitEnable      = FindProperty("_RimLitEnable"      , Prop , false);
			RimLitMask        = FindProperty("_RimLitMask"        , Prop , false);
			RimLitColor       = FindProperty("_RimLitColor"       , Prop , false);
			RimLit            = FindProperty("_RimLit"            , Prop , false);
			RimLitGradient    = FindProperty("_RimLitGradient"    , Prop , false);
			RimLitLighting    = FindProperty("_RimLitLighthing"   , Prop , false);
			RimLitTexColor    = FindProperty("_RimLitTexColor"    , Prop , false);
			RimLitMode        = FindProperty("_RimLitMode"        , Prop , false);
			IgnoreTexAlphaRL  = FindProperty("_IgnoreTexAlphaRL"  , Prop , false);

			Culling           = FindProperty("_Culling"           , Prop , false);
			EnableZWrite      = FindProperty("_EnableZWrite"      , Prop , false);
			IgnoreProjector   = FindProperty("_IgnoreProjector"   , Prop , false);
			DirectionalLight  = FindProperty("_DirectionalLight"  , Prop , false);
			SHLight           = FindProperty("_SHLight"           , Prop , false);
			PointLight        = FindProperty("_PointLight"        , Prop , false);
			LightLimitter     = FindProperty("_LightLimitter"     , Prop , false);
			MinimumLight      = FindProperty("_MinimumLight"      , Prop , false);
			BlendOperation    = FindProperty("_BlendOperation"    , Prop , false);
			EnableGammaFix    = FindProperty("_EnableGammaFix"    , Prop , false);
			GammaR            = FindProperty("_GammaR"            , Prop , false);
			GammaG            = FindProperty("_GammaG"            , Prop , false);
			GammaB            = FindProperty("_GammaB"            , Prop , false);
			EnableBlightFix   = FindProperty("_EnableBlightFix"   , Prop , false);
			BlightOutput      = FindProperty("_BlightOutput"      , Prop , false);
			BlightOffset      = FindProperty("_BlightOffset"      , Prop , false);
			LimitterEnable    = FindProperty("_LimitterEnable"    , Prop , false);
			LimitterMax       = FindProperty("_LimitterMax"       , Prop , false);


			if (OnceRun) {
				OnceRun = false;

				if (Shader_StencilOut) {
					if ((Previous_Type < 3) || (5 < Previous_Type)) {
						mat.SetInt("_StencilNumb" , 2);
					}
				}
				if (Shader_Stencil) {
					if  (Previous_Type < 6) {
						mat.SetInt("_StencilNumb" , 4);
					}
				}

				mat.SetInt("_SunaoShaderType" , Shader_Type);

				VersionC = Version_H               * 10000 + Version_M               * 100 + Version_L;
				VersionM = mat.GetInt("_VersionH") * 10000 + mat.GetInt("_VersionM") * 100 + mat.GetInt("_VersionL");

				if (VersionC > VersionM) {
					mat.SetInt("_VersionH" , Version_H);
					mat.SetInt("_VersionM" , Version_M);
					mat.SetInt("_VersionL" , Version_L);
					VersionM = VersionC;
				}

				var Keyword = new List<string>(mat.shaderKeywords);
				foreach (string Key in Keyword) {
					mat.DisableKeyword(Key);
				}
			}


			if (VersionC < VersionM) {
				using (new EditorGUILayout.VerticalScope("box")) {
					EditorGUILayout.HelpBox(
						"このマテリアルは現在お使いのSunao Shaderよりも新しいバージョン(" + mat.GetInt("_VersionH") + "." + mat.GetInt("_VersionM") + "." + mat.GetInt("_VersionL") + ")で作られています。\n" +
						"そのため一部表現が正しくなかったり設定値に互換がない可能性があります。\n" +
						"新しいバージョンのSunao Shaderが公開されている場合はアップデートをおすすめします。\n" +
						"現在お使いのSunao Shaderのバージョンは " + Version_H + "." + Version_M + "." + Version_L + " です。" ,
						MessageType.Warning
					);
					if (GUILayout.Button("無視する")) {
						mat.SetInt("_VersionH" , Version_H);
						mat.SetInt("_VersionM" , Version_M);
						mat.SetInt("_VersionL" , Version_L);
						VersionM = VersionC;
					}
				}
			}


			GUILayout.Label("Main", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				using (new EditorGUILayout.VerticalScope("box")) {

					GUILayout.Label("Main Color & Texture Maps", EditorStyles.boldLabel);

					ME.TexturePropertySingleLine (new GUIContent("Main Texture") , MainTex , Color);
					ME.TextureScaleOffsetProperty(MainTex);

					if (Shader_Cutout     ) ME.ShaderProperty(Cutout , new GUIContent("Cutout"));
					if (Shader_Transparent) ME.ShaderProperty(Alpha  , new GUIContent("Alpha" ));
					if (Shader_Stencil    ) ME.ShaderProperty(Cutout , new GUIContent("Cutout"));


					ME.TexturePropertySingleLine(new GUIContent("Normal Map") , BumpMap     );
					if (BumpMap.textureValue != null) {
						ME.TextureScaleOffsetProperty(BumpMap);
					}

					ME.TexturePropertySingleLine(new GUIContent("Occlusion" ) , OcclusionMap);
					if (Shader_Cutout || Shader_Transparent || Shader_Stencil) ME.TexturePropertySingleLine(new GUIContent("Alpha Mask") , AlphaMask);


					EditorGUI.indentLevel ++;

					if (mat.GetInt("_MainFO") == 1) MainFoldout = true;
					MainFoldout = EditorGUILayout.Foldout(MainFoldout , "Advanced Settings" , EditorStyles.boldFont);

					if (MainFoldout) {
						mat.SetInt("_MainFO" , 1);

						ME.ShaderProperty(Bright , new GUIContent("Brightness"));

						if (BumpMap.textureValue      != null) {
							ME.ShaderProperty(BumpScale         , new GUIContent("Normal Map Scale"  ));
						}
						if (OcclusionMap.textureValue != null) {
							ME.ShaderProperty(OcclusionStrength , new GUIContent("Occlusion Strength"));
							ME.ShaderProperty(OcclusionMode     , new GUIContent("Occlusion Mode"    ));
						}
						if ((AlphaMask.textureValue   != null) && (Shader_Cutout || Shader_Transparent || Shader_Stencil)) {
							ME.ShaderProperty(AlphaMaskStrength , new GUIContent("Alpha Mask Strength"));
						}

						ME.ShaderProperty(VertexColor , new GUIContent("Use Vertex Color"  ));

						ME.ShaderProperty(UVScrollX   , new GUIContent("Scroll X"          ));
						ME.ShaderProperty(UVScrollY   , new GUIContent("Scroll Y"          ));
						
						ME.ShaderProperty(UVAnimation , new GUIContent("Animation Speed"   ));
						if (UVAnimation.floatValue > 0.0f) {
							ME.ShaderProperty(UVAnimX        , new GUIContent("Animation X Size"));
							ME.ShaderProperty(UVAnimY        , new GUIContent("Animation Y Size"));
						}
						if (UVAnimX.floatValue < 1.0f) mat.SetInt("_UVAnimX" , 1);
						if (UVAnimY.floatValue < 1.0f) mat.SetInt("_UVAnimY" , 1);
						
						ME.ShaderProperty(UVAnimOtherTex , new GUIContent("Animation Other Texture Maps"));

					} else {
						mat.SetInt("_MainFO" , 0);
					}

					EditorGUI.indentLevel --;

				}

				using (new EditorGUILayout.VerticalScope("box")) {

					GUILayout.Label("Decal", EditorStyles.boldLabel);

					ME.ShaderProperty(DecalEnable , new GUIContent("Enable Decal"));
					if (DecalEnable.floatValue >= 0.5f) {
						ME.TexturePropertySingleLine (new GUIContent("Decal Texture") , DecalTex , DecalColor);
						ME.ShaderProperty(DecalPosX        , new GUIContent("Position X"    ));
						ME.ShaderProperty(DecalPosY        , new GUIContent("Position Y"    ));
						ME.ShaderProperty(DecalSizeX       , new GUIContent("Scale X"       ));
						ME.ShaderProperty(DecalSizeY       , new GUIContent("Scale Y"       ));
						ME.ShaderProperty(DecalRotation    , new GUIContent("Rotation"      ));

						EditorGUI.indentLevel ++;

						if (mat.GetInt("_DecalFO") == 1) DecalFoldout = true;
						DecalFoldout = EditorGUILayout.Foldout(DecalFoldout , "Advanced Settings" , EditorStyles.boldFont);

						if (DecalFoldout) {
							mat.SetInt("_DecalFO" , 1);

							ME.ShaderProperty(DecalMode        , new GUIContent("Decal Mode"       ));
							if ((int)DecalMode.floatValue == 3) ME.ShaderProperty(DecalBright   , new GUIContent("Brightness Offset" ));
							if ((int)DecalMode.floatValue == 4) ME.ShaderProperty(DecalEmission , new GUIContent("Emission Intensity"));
							if ((int)DecalMode.floatValue == 5) ME.ShaderProperty(DecalEmission , new GUIContent("Emission Intensity"));

							ME.ShaderProperty(DecalMirror      , new GUIContent("Decal Mirror Mode"));

							ME.ShaderProperty(DecalScrollX     , new GUIContent("Scroll X"         ));
							ME.ShaderProperty(DecalScrollY     , new GUIContent("Scroll Y"         ));

							ME.ShaderProperty(DecalAnimation   , new GUIContent("Animation Speed"  ));
							if (DecalAnimation.floatValue > 0.0f) {
								ME.ShaderProperty(DecalAnimX   , new GUIContent("Animation X Size" ));
								ME.ShaderProperty(DecalAnimY   , new GUIContent("Animation Y Size" ));
							}
							if (DecalAnimX.floatValue < 1.0f) mat.SetInt("_DecalAnimX" , 1);
							if (DecalAnimY.floatValue < 1.0f) mat.SetInt("_DecalAnimY" , 1);

						} else {
							mat.SetInt("_DecalFO" , 0);
						}

						EditorGUI.indentLevel --;

					}
				}
			}


			if ((Shader_Stencil) || (Shader_StencilOut)) {

				GUILayout.Label("Stencil", EditorStyles.boldLabel);

				using (new EditorGUILayout.VerticalScope("box")) {

					ME.ShaderProperty(StencilNumb , new GUIContent("Stencil Number"));
					if ((int)StencilNumb.floatValue <   0) mat.SetInt("_StencilNumb" ,   0);
					if ((int)StencilNumb.floatValue > 255) mat.SetInt("_StencilNumb" , 255);
	
					if (Shader_StencilRW) {
						ME.ShaderProperty(StencilCompMode , new GUIContent("Stencil Compare Mode"));
					}
				}
			}


			GUILayout.Label("Shading & Lighting", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				using (new EditorGUILayout.VerticalScope("box")) {

					GUILayout.Label("Shading", EditorStyles.boldLabel);

					ME.TexturePropertySingleLine(new GUIContent("Shade Mask") , ShadeMask);
					ME.ShaderProperty(Shade , new GUIContent("Shade Strength"));

					EditorGUI.indentLevel ++;

					if (mat.GetInt("_ShadingFO") == 1) ShadingFoldout = true;
					ShadingFoldout = EditorGUILayout.Foldout(ShadingFoldout , "Advanced Settings" , EditorStyles.boldFont);

					if (ShadingFoldout) {
						mat.SetInt("_ShadingFO" , 1);

						ME.ShaderProperty(ShadeWidth       , new GUIContent("Shade Width"       ));
						ME.ShaderProperty(ShadeGradient    , new GUIContent("Shade Gradient"    ));
						ME.ShaderProperty(ShadeColor       , new GUIContent("Shade Color"       ));
						ME.ShaderProperty(CustomShadeColor , new GUIContent("Custom Shade Color"));
					} else {
						mat.SetInt("_ShadingFO" , 0);
					}

					EditorGUI.indentLevel --;

				}

				using (new EditorGUILayout.VerticalScope("box")) {

					GUILayout.Label("Toon Shading", EditorStyles.boldLabel);

					ME.ShaderProperty(ToonEnable , new GUIContent("Enable Toon Shading"));
					if (ToonEnable.floatValue >= 0.5f) {
						ME.ShaderProperty(Toon           , new GUIContent("Toon"           ));
						ME.ShaderProperty(ToonSharpness  , new GUIContent("Toon Sharpness" ));
					}

				}

				using (new EditorGUILayout.VerticalScope("box")) {

					GUILayout.Label("Lighting", EditorStyles.boldLabel);

					ME.TexturePropertySingleLine(new GUIContent("Lighting Boost Mask") , LightMask);
					if (LightMask.textureValue != null) {
						ME.ShaderProperty(LightBoost , new GUIContent("Lighting Boost"));
					}

					ME.ShaderProperty(Unlit , new GUIContent("Unlighting"));
					ME.ShaderProperty(MonochromeLit , new GUIContent("Monochrome Lighting"));

				}
			}


			GUILayout.Label("Outline", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				ME.ShaderProperty(OutLineEnable , new GUIContent("Enable Outline"));

				if (OutLineEnable.floatValue >= 0.5f) {
					ME.TexturePropertySingleLine(new GUIContent("Outline Mask") , OutLineMask);
					ME.ShaderProperty(OutLineColor , new GUIContent("Outline Color"));
					ME.ShaderProperty(OutLineSize  , new GUIContent("Outline Scale" ));

					EditorGUI.indentLevel ++;

					if (mat.GetInt("_OutlineFO") == 1) OutlineFoldout = true;
					OutlineFoldout = EditorGUILayout.Foldout(OutlineFoldout , "Advanced Settings" , EditorStyles.boldFont);

					if (OutlineFoldout) {
						mat.SetInt("_OutlineFO" , 1);

						ME.ShaderProperty(OutLineLighting  , new GUIContent("Use Light Color" ));
						ME.ShaderProperty(OutLineTexColor  , new GUIContent("Use Main Texture"));
						ME.TexturePropertySingleLine(new GUIContent("Outline Texture") , OutLineTexture);
						ME.ShaderProperty(OutLineFixScale  , new GUIContent("x10 Scale"       ));
					} else {
						mat.SetInt("_OutlineFO" , 0);
					}

					EditorGUI.indentLevel --;

				}
			}


			GUILayout.Label("Emission", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				ME.ShaderProperty(EmissionEnable , new GUIContent("Enable Emission"));

				if (EmissionEnable.floatValue >= 0.5f) {

					ME.TexturePropertySingleLine(new GUIContent("Emission Mask") , EmissionMap);
					if (EmissionMap.textureValue != null) {
						ME.TextureScaleOffsetProperty(EmissionMap);
					}

					ME.ShaderProperty(EmissionColor , new GUIContent("Emission Color"    ));
					ME.ShaderProperty(Emission      , new GUIContent("Emission Intensity"));

					EditorGUI.indentLevel ++;

					if (mat.GetInt("_EmissionFO") == 1) EmissionFoldout = true;
					EmissionFoldout = EditorGUILayout.Foldout(EmissionFoldout , "Advanced Settings" , EditorStyles.boldFont);

					if (EmissionFoldout) {
						mat.SetInt("_EmissionFO" , 1);

						ME.TexturePropertySingleLine(new GUIContent("2nd Emission Mask") , EmissionMap2);
						if (EmissionMap2.textureValue != null) {
							ME.TextureScaleOffsetProperty(EmissionMap2);
						}

						ME.ShaderProperty(EmissionMode      , new GUIContent("Emission Mode"   ));

						ME.ShaderProperty(EmissionBlink     , new GUIContent("Blink"           ));
						if (EmissionBlink.floatValue > 0.0f) {
							ME.ShaderProperty(EmissionFrequency , new GUIContent("Frequency"   ));
							ME.ShaderProperty(EmissionWaveform  , new GUIContent("Waveform"    ));
						}

						ME.ShaderProperty(EmissionScrX      , new GUIContent("Scroll X"        ));
						ME.ShaderProperty(EmissionScrY      , new GUIContent("Scroll Y"        ));

						ME.ShaderProperty(EmissionAnimation , new GUIContent("Animation Speed" ));
						if (EmissionAnimation.floatValue > 0.0f) {
							ME.ShaderProperty(EmissionAnimX , new GUIContent("Animation X Size"));
							ME.ShaderProperty(EmissionAnimY , new GUIContent("Animation Y Size"));
						}
						if (EmissionAnimX.floatValue < 1.0f) mat.SetInt("_EmissionAnimX" , 1);
						if (EmissionAnimY.floatValue < 1.0f) mat.SetInt("_EmissionAnimY" , 1);

						ME.ShaderProperty(EmissionLighting , new GUIContent("Use Lighting"     ));

						if (Shader_Transparent) {
							ME.ShaderProperty(IgnoreTexAlphaE , new GUIContent("Ignore Main Texture Alpha"));
						}

						ME.ShaderProperty(EmissionInTheDark , new GUIContent("Only in the Dark"));
					} else {
						mat.SetInt("_EmissionFO" , 0);
					}

					EditorGUI.indentLevel --;

				}
			}


			GUILayout.Label("Parallax Emission", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				ME.ShaderProperty(ParallaxEnable , new GUIContent("Enable Parallax Emission"));

				if (ParallaxEnable.floatValue >= 0.5f) {

					ME.TexturePropertySingleLine(new GUIContent("Parallax Emission Texture") , ParallaxMap);
					if (ParallaxMap.textureValue != null) {
						ME.TextureScaleOffsetProperty(ParallaxMap);
					}

					ME.ShaderProperty(ParallaxColor    , new GUIContent("Emission Color"    ));
					ME.ShaderProperty(ParallaxEmission , new GUIContent("Emission Intensity"));
					ME.ShaderProperty(ParallaxDepth    , new GUIContent("Parallax Depth"));

					EditorGUI.indentLevel ++;

					if (mat.GetInt("_ParallaxFO") == 1) ParallaxFoldout = true;
					ParallaxFoldout = EditorGUILayout.Foldout(ParallaxFoldout , "Advanced Settings" , EditorStyles.boldFont);

					if (ParallaxFoldout) {
						mat.SetInt("_ParallaxFO" , 1);

						ME.TexturePropertySingleLine(new GUIContent("Parallax Depth Mask"       ) , ParallaxDepthMap);
						if (ParallaxDepthMap.textureValue != null) {
							ME.TextureScaleOffsetProperty(ParallaxDepthMap);
						}

						ME.TexturePropertySingleLine(new GUIContent("2nd Parallax Emission Mask") , ParallaxMap2    );
						if (ParallaxMap2.textureValue != null) {
							ME.TextureScaleOffsetProperty(ParallaxMap2);
						}

						ME.ShaderProperty(ParallaxMode      , new GUIContent("Emission Mode"   ));

						ME.ShaderProperty(ParallaxBlink     , new GUIContent("Blink"           ));
						if (ParallaxBlink.floatValue > 0.0f) {
							ME.ShaderProperty(ParallaxFrequency , new GUIContent("Frequency"   ));
							ME.ShaderProperty(ParallaxWaveform  , new GUIContent("Waveform"    ));
							ME.ShaderProperty(ParallaxPhaseOfs  , new GUIContent("Phase Offset"));
						}

						ME.ShaderProperty(ParallaxScrX      , new GUIContent("Scroll X"        ));
						ME.ShaderProperty(ParallaxScrY      , new GUIContent("Scroll Y"        ));

						ME.ShaderProperty(ParallaxAnimation , new GUIContent("Animation Speed" ));
						if (ParallaxAnimation.floatValue > 0.0f) {
							ME.ShaderProperty(ParallaxAnimX , new GUIContent("Animation X Size"));
							ME.ShaderProperty(ParallaxAnimY , new GUIContent("Animation Y Size"));
						}
						if (ParallaxAnimX.floatValue < 1.0f) mat.SetInt("_ParallaxAnimX" , 1);
						if (ParallaxAnimY.floatValue < 1.0f) mat.SetInt("_ParallaxAnimY" , 1);

						ME.ShaderProperty(ParallaxLighting , new GUIContent("Use Lighting"     ));

						if (Shader_Transparent) {
							ME.ShaderProperty(IgnoreTexAlphaPE , new GUIContent("Ignore Main Texture Alpha"));
						}

						ME.ShaderProperty(ParallaxInTheDark , new GUIContent("Only in the Dark"));
					} else {
						mat.SetInt("_ParallaxFO" , 0);
					}

					EditorGUI.indentLevel --;

				}
			}


			GUILayout.Label("Reflection", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				ME.ShaderProperty(ReflectionEnable , new GUIContent("Enable Reflection"));

				if (ReflectionEnable.floatValue >= 0.5f) {
					ME.TexturePropertySingleLine(new GUIContent("Reflection Mask") , MetallicGlossMap , GlossColor);

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Reflection Environment", EditorStyles.boldLabel);

						ME.ShaderProperty(Specular      , new GUIContent("Specular Intensity"));
						ME.ShaderProperty(Metallic      , new GUIContent("Metallic"          ));
						ME.ShaderProperty(GlossMapScale , new GUIContent("Smoothness"        ));

					}

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Material Capture", EditorStyles.boldLabel);

						ME.TexturePropertySingleLine(new GUIContent("MatCap Texture") , MatCap , MatCapColor);
						if (MatCap.textureValue != null) {
							ME.ShaderProperty(MatCapMaskEnable , new GUIContent("Use Reflection Mask"));
							if (MatCapMaskEnable.floatValue < 0.5f) ME.TexturePropertySingleLine(new GUIContent("MatCap Mask") , MatCapMask);

							ME.ShaderProperty(MatCapStrength , new GUIContent("MatCap Strength"));
						}

					}

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Toon Specular", EditorStyles.boldLabel);

						ME.ShaderProperty(ToonGlossEnable , new GUIContent("Enable Toon Specular"));
						if (ToonGlossEnable.floatValue >= 0.5f) {
							ME.ShaderProperty(ToonGloss      , new GUIContent("Toon Specular"));
						}

					}

					EditorGUI.indentLevel ++;

					if (mat.GetInt("_ReflectionFO") == 1) ReflectionFoldout = true;
					ReflectionFoldout = EditorGUILayout.Foldout(ReflectionFoldout , "Advanced Settings" , EditorStyles.boldFont);

					if (ReflectionFoldout) {
						mat.SetInt("_ReflectionFO" , 1);

						ME.ShaderProperty(SpecularTexColor , new GUIContent("Use Main Texture for Specular"));
						ME.ShaderProperty(MetallicTexColor , new GUIContent("Use Main Texture for Metallic"));
						ME.ShaderProperty(MatCapTexColor   , new GUIContent("Use Main Texture for MatCap"  ));
						ME.ShaderProperty(SpecularSH       , new GUIContent("SH Light Specular"            ));
						ME.ShaderProperty(SpecularMask     , new GUIContent("Use Mask Color for Specular"  ));
						ME.ShaderProperty(ReflectLit       , new GUIContent("Use Light Color for Metallic" ));
						ME.ShaderProperty(MatCapLit        , new GUIContent("Use Light Color for MatCap"   ));

						if (Shader_Transparent) {
							ME.ShaderProperty(IgnoreTexAlphaR  , new GUIContent("Ignore Main Texture Alpha"));
						}

					} else {
						mat.SetInt("_ReflectionFO" , 0);
					}

					EditorGUI.indentLevel --;

				}
			}


			GUILayout.Label("Rim Lighting", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				ME.ShaderProperty(RimLitEnable , new GUIContent("Enable Rim Lighting"));

				if (RimLitEnable.floatValue >= 0.5f) {

					ME.TexturePropertySingleLine(new GUIContent("Rim Light Mask") , RimLitMask);
					ME.ShaderProperty(RimLitColor , new GUIContent("Rim Light Color"));
					ME.ShaderProperty(RimLit      , new GUIContent("Rim Lighting"   ));

					EditorGUI.indentLevel ++;

					if (mat.GetInt("_RimLightingFO") == 1) RimLightFoldout = true;
					RimLightFoldout = EditorGUILayout.Foldout(RimLightFoldout , "Advanced Settings" , EditorStyles.boldFont);

					if (RimLightFoldout) {
						mat.SetInt("_RimLightingFO" , 1);

						ME.ShaderProperty(RimLitGradient  , new GUIContent("Rim Light Gradient"));
						ME.ShaderProperty(RimLitLighting  , new GUIContent("Use Light Color"   ));
						ME.ShaderProperty(RimLitTexColor  , new GUIContent("Use Main Texture"  ));
						ME.ShaderProperty(RimLitMode      , new GUIContent("Rim Light Mode"    ));

						if (Shader_Transparent) {
							ME.ShaderProperty(IgnoreTexAlphaRL , new GUIContent("Ignore Main Texture Alpha"));
						}

					} else {
						mat.SetInt("_RimLightingFO" , 0);
					}

					EditorGUI.indentLevel --;
				}
			}


			GUILayout.Label("Other", EditorStyles.boldLabel);

			using (new EditorGUILayout.VerticalScope("box")) {

				if (mat.GetInt("_OtherSettingsFO") == 1) OtherFoldout = true;

					EditorGUI.indentLevel ++;

					if (OtherFoldout) {
						OtherFoldout = EditorGUILayout.Foldout(OtherFoldout , ""              , EditorStyles.boldFont);
					} else {
						OtherFoldout = EditorGUILayout.Foldout(OtherFoldout , "Show Settings" , EditorStyles.boldFont);
					}

					EditorGUI.indentLevel --;

				if (OtherFoldout) {
					mat.SetInt("_OtherSettingsFO" , 1);

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Shader Modes" , EditorStyles.boldLabel);

						ME.ShaderProperty(Culling         , new GUIContent("Culling Mode"    ));
						ME.ShaderProperty(EnableZWrite    , new GUIContent("Enable Z Write"  ));
						/*  うまく動かんっぽい。Unityの仕様？
						ME.ShaderProperty(IgnoreProjector , new GUIContent("Ignore Projector"));
						if (IgnoreProjector.floatValue >= 0.5f) {
							mat.SetOverrideTag("IgnoreProjector", "True" );
						} else {
							mat.SetOverrideTag("IgnoreProjector", "False");
						}
						*/
					}

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Lights"       , EditorStyles.boldLabel);

						ME.ShaderProperty(DirectionalLight , new GUIContent("Directional Light Intensity"));
						ME.ShaderProperty(SHLight          , new GUIContent("SH Light Intensity"         ));
						ME.ShaderProperty(PointLight       , new GUIContent("Point/Spot Light Intensity" ));
						ME.ShaderProperty(LightLimitter    , new GUIContent("Light Intensity Limitter"   ));
						ME.ShaderProperty(MinimumLight     , new GUIContent("Minimum Light Limit"        ));
						ME.ShaderProperty(BlendOperation   , new GUIContent("ForwardAdd Blend Mode"      ));

					}

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Gamma Fix"    , EditorStyles.boldLabel);

						ME.ShaderProperty(EnableGammaFix   , new GUIContent("Enable Gamma Fix"));
						if (EnableGammaFix.floatValue >= 0.5f) {
							ME.ShaderProperty(GammaR , new GUIContent("Gamma R"));
							ME.ShaderProperty(GammaG , new GUIContent("Gamma G"));
							ME.ShaderProperty(GammaB , new GUIContent("Gamma B"));
						}

					}

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Brightness Fix" , EditorStyles.boldLabel);

						ME.ShaderProperty(EnableBlightFix  , new GUIContent("Enable Brightness Fix"));
						if (EnableBlightFix.floatValue >= 0.5f) {
							ME.ShaderProperty(BlightOutput  , new GUIContent("Output Blightness"));
							ME.ShaderProperty(BlightOffset  , new GUIContent("Blightness Offset"));
						}

					}

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Output Limitter" , EditorStyles.boldLabel);

						ME.ShaderProperty(LimitterEnable    , new GUIContent("Enable Output Limitter"));
						if (LimitterEnable.floatValue >= 0.5f) {
							ME.ShaderProperty(LimitterMax    , new GUIContent("Limitter Max"));
						}
					}

					using (new EditorGUILayout.VerticalScope("box")) {

						GUILayout.Label("Render Queue" , EditorStyles.boldLabel);

						ME.RenderQueueField();
					
					}

				} else {
					mat.SetInt("_OtherSettingsFO" , 0);
				}
			}


			EditorGUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			GUILayout.Label("Sunao Shader " + Version_H + "." + Version_M + "." + Version_L , EditorStyles.boldLabel);
			EditorGUILayout.EndHorizontal();

		}
	}

	public class SToggleDrawer : MaterialPropertyDrawer {

		public override void OnGUI(Rect Pos, MaterialProperty Prop, GUIContent Label, MaterialEditor ME) {

			bool IN  = false;
			if (Prop.floatValue >= 0.5f) IN = true;

			var  OUT = EditorGUI.Toggle(Pos, Label, IN);

			if (OUT) {
				Prop.floatValue = 1.0f;
			} else {
				Prop.floatValue = 0.0f;
			}
		}
	}

}
