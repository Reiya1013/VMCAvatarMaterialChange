using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using System;

public class RSInspector : ShaderGUI 
{
	
	// Foldout Base
	static bool Foldout(bool display, string title)
	{
		var style = new GUIStyle("ShurikenModuleTitle");
		style.font = new GUIStyle(EditorStyles.boldLabel).font;
		style.border = new RectOffset(15, 7, 4, 4);
		style.fixedHeight = 22;
		style.contentOffset = new Vector2(20f, -2f);

		var rect = GUILayoutUtility.GetRect(16f, 22f, style);
		GUI.Box(rect, title, style);

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
	
	
	static bool IsShowMatcapSettings = false;
	static bool IsShowRimLightSettings = false;
	static bool IsShowOutlineSettings = false;
	static bool IsShowReflectionSettings = false;
	static bool IsShowShadowSettings = false;
	static bool IsShowAdvancedShadowSettings = false;
	static bool IsShowColorShiftSettings = false;
	static bool IsShowEmissionSettings = false;
	static bool IsShowParallaxEmission = false;
	static bool IsShowAdvancedSettings = false;
	
	
	static string _RSVersion = "2.2.0-relase1";
	
	public override void OnGUI (MaterialEditor materialEditor, MaterialProperty[] properties)
	{
		
		Material material = materialEditor.target as Material;

		#region Material Properties
		MaterialProperty Diffuse =	ShaderGUI.FindProperty("_MainTex", properties);
		MaterialProperty DiffuseColor = ShaderGUI.FindProperty("_DiffuseColor", properties);
		MaterialProperty Emission =	ShaderGUI.FindProperty("_EmissionMap", properties);
		MaterialProperty EmissionColor = ShaderGUI.FindProperty("_EmissionColor", properties);
		MaterialProperty NormalMap = ShaderGUI.FindProperty("_BumpMap", properties);
		
		MaterialProperty MatcapToggle = ShaderGUI.FindProperty("_MatcapToggle", properties);
		MaterialProperty Matcap = ShaderGUI.FindProperty("_Matcap", properties);
		MaterialProperty MatcapColor = ShaderGUI.FindProperty("_MatcapColor", properties);
		MaterialProperty MatcapShadowToggle = ShaderGUI.FindProperty("_MatcapShadowToggle", properties);
		MaterialProperty MatcapShadow = ShaderGUI.FindProperty("_MatcapShadow", properties);
		MaterialProperty MatcapShadowColor = ShaderGUI.FindProperty("_MatcapShadowColor", properties);
		MaterialProperty MatcapMask = ShaderGUI.FindProperty("_MatcapMask", properties);
		MaterialProperty ForceMatcap = ShaderGUI.FindProperty("_ForceMatcap", properties);
		MaterialProperty MatcapCameraFix = ShaderGUI.FindProperty("_MatcapCameraFix", properties);
		
		MaterialProperty RimLightToggle = ShaderGUI.FindProperty("_RimLightToggle", properties);
		MaterialProperty RimLightColor = ShaderGUI.FindProperty("_RimLightColor", properties);
		MaterialProperty RimLightPower = ShaderGUI.FindProperty("_RimLightPower", properties);
		MaterialProperty RimLightContrast = ShaderGUI.FindProperty("_RimLightContrast", properties);
		MaterialProperty RimLightMask = ShaderGUI.FindProperty("_RimLightMask", properties);
		MaterialProperty RimLightNormal = ShaderGUI.FindProperty("_RimLightNormal", properties);
		
		MaterialProperty ReflectionToggle = ShaderGUI.FindProperty("_ReflectionToggle", properties);
		MaterialProperty ReflectionColor = ShaderGUI.FindProperty("_ReflectionColor", properties);
		MaterialProperty ReflectionIntensity = ShaderGUI.FindProperty("_ReflectionIntensity", properties);
		MaterialProperty Smoothness = ShaderGUI.FindProperty("_Smoothness", properties);
		MaterialProperty FresnelToggle = ShaderGUI.FindProperty("_FresnelToggle", properties);
		MaterialProperty FresnelPower = ShaderGUI.FindProperty("_FresnelPower", properties);
		MaterialProperty FresnelScale = ShaderGUI.FindProperty("_FresnelScale", properties);
		
		MaterialProperty HalfLambertToggle = ShaderGUI.FindProperty("_HalfLambertToggle", properties);
		MaterialProperty ObjectShadow = ShaderGUI.FindProperty("_ObjectShadow", properties);
		MaterialProperty Shadow1Contrast = ShaderGUI.FindProperty("_Shadow1Contrast", properties);
		MaterialProperty Shadow2ContrastToggle = ShaderGUI.FindProperty("_Shadow2ContrastToggle", properties);
		MaterialProperty Shadow2Contrast = ShaderGUI.FindProperty("_Shadow2Contrast", properties);
		MaterialProperty Shadow1Color = ShaderGUI.FindProperty("_Shadow1Color", properties);
		MaterialProperty Shadow2Color = ShaderGUI.FindProperty("_Shadow2Color", properties);
		MaterialProperty ShadowColorDarken = ShaderGUI.FindProperty("_ShadowColorDarken", properties);
		MaterialProperty Shadow1Place = ShaderGUI.FindProperty("_Shadow1Place", properties);
		MaterialProperty Shadow2Place = ShaderGUI.FindProperty("_Shadow2Place", properties);
		MaterialProperty AmbientMinimum = ShaderGUI.FindProperty("_AmbientMinimum", properties);
		MaterialProperty PosterizeToggle = ShaderGUI.FindProperty("_PosterizeToggle", properties);
		MaterialProperty NormalIntensity = ShaderGUI.FindProperty("_NormalIntensity", properties);
		MaterialProperty ShadowMask = ShaderGUI.FindProperty("_ShadowMask", properties);
		MaterialProperty VDirLight = ShaderGUI.FindProperty("_VDirLight", properties);
		MaterialProperty LightIntensityShadowPos = ShaderGUI.FindProperty("_LightIntensityShadowPos", properties);
		
		MaterialProperty ScanLineToggle = ShaderGUI.FindProperty("_ScanLineToggle", properties);
		MaterialProperty ScanLineTex = ShaderGUI.FindProperty("_ScanLineTex", properties);
		MaterialProperty ScanLineColor = ShaderGUI.FindProperty("_ScanLineColor", properties);
		MaterialProperty ScanLineColor2Toggle = ShaderGUI.FindProperty("_ScanLineColor2Toggle", properties);
		MaterialProperty ScanLineColor2 = ShaderGUI.FindProperty("_ScanLineColor2", properties);
		MaterialProperty ScanLineSpeed = ShaderGUI.FindProperty ("_ScanLineSpeed", properties);
		MaterialProperty ScanLineWidth = ShaderGUI.FindProperty ("_ScanLineWidth", properties);
		MaterialProperty ScanLinePosition = ShaderGUI.FindProperty ("_ScanLinePosition", properties);
		MaterialProperty Color2ChangeSpeed = ShaderGUI.FindProperty ("_Color2ChangeSpeed", properties);
		
		MaterialProperty EmissiveScrollToggle = ShaderGUI.FindProperty ("_EmissiveScrollToggle", properties);
		MaterialProperty EmissiveScrollTex = ShaderGUI.FindProperty ("_EmissiveScrollTex", properties);
		MaterialProperty EmissiveScrollMask = ShaderGUI.FindProperty ("_EmissiveScrollMask", properties);
		MaterialProperty EmissiveScrollColor = ShaderGUI.FindProperty ("_EmissiveScrollColor", properties);
		MaterialProperty EmissiveScrollSpeed = ShaderGUI.FindProperty ("_EmissiveScrollSpeed", properties);
		MaterialProperty EmissiveScrollGradient = ShaderGUI.FindProperty ("_EmissiveScrollGradient", properties);
		MaterialProperty EmissiveScrollContrast = ShaderGUI.FindProperty ("_EmissiveScrollContrast", properties);
		MaterialProperty EmissiveScrollStrength = ShaderGUI.FindProperty ("_EmissiveScrollStrength", properties);
		MaterialProperty ForceEmissiveToggle = ShaderGUI.FindProperty ("_ForceEmissiveToggle", properties);
		MaterialProperty EmissiveScrollTiling = ShaderGUI.FindProperty ("_EmissiveScrollTiling", properties);
		
		MaterialProperty ParallaxEmission = ShaderGUI.FindProperty ("_ParallaxEmission", properties);
		MaterialProperty ParallaxTiling = ShaderGUI.FindProperty ("_ParallaxTiling", properties);
		MaterialProperty ParallaxScale = ShaderGUI.FindProperty ("_ParallaxScale", properties);
		MaterialProperty ParallaxHight = ShaderGUI.FindProperty ("_ParallaxHight", properties);
		MaterialProperty ParallaxMask = ShaderGUI.FindProperty ("_ParallaxMask", properties);
		
		MaterialProperty ColorShift = ShaderGUI.FindProperty("_ColorShift",properties);
		MaterialProperty H = ShaderGUI.FindProperty("_H",properties);
		MaterialProperty S = ShaderGUI.FindProperty("_S",properties);
		MaterialProperty V = ShaderGUI.FindProperty("_V",properties);
		MaterialProperty GrayscaleColor = ShaderGUI.FindProperty("_GrayscaleColor",properties);
		
		MaterialProperty Unlit = ShaderGUI.FindProperty("_Unlit",properties);
		MaterialProperty CullMode = ShaderGUI.FindProperty("_CullMode",properties);
		#endregion
		
		materialEditor.SetDefaultGUIWidths();



		// Main
		EditorGUILayout.LabelField( "Common", EditorStyles.boldLabel );
		materialEditor.TextureProperty(Diffuse, "Diffuse");
		materialEditor.ShaderProperty(DiffuseColor, "Diffuse Color");
		
		EditorGUILayout.Space();
		
		materialEditor.ShaderProperty(Emission, "Emission");
		materialEditor.ShaderProperty(EmissionColor, "Emission Color");
		
		EditorGUILayout.Space();
		
		materialEditor.TextureProperty(NormalMap, "Normal Map");

		// Cutout IF
		if (material.HasProperty("_CutoutThreshold"))
		{
			EditorGUILayout.Space();
			EditorGUILayout.LabelField( "Alpha Cutout Properties", EditorStyles.boldLabel );
			MaterialProperty CutoutThreshold = ShaderGUI.FindProperty("_CutoutThreshold", properties);
			materialEditor.ShaderProperty(CutoutThreshold,"Cutout Threshold");
			EditorGUILayout.Space();
		}

		// Transparent IF
		if (material.HasProperty("_ZWriteMode"))
		{
			EditorGUILayout.Space();
			EditorGUILayout.LabelField( "Transparent Properties", EditorStyles.boldLabel );
			MaterialProperty ZWriteMode = ShaderGUI.FindProperty("_ZWriteMode", properties);
			materialEditor.ShaderProperty(ZWriteMode,"ZWrite Mode");
			EditorGUILayout.Space();
		}

		// Stencil if
		if (material.HasProperty("_StencilReference"))
		{
			EditorGUILayout.Space();
			EditorGUILayout.LabelField( "Stencil Properties", EditorStyles.boldLabel );
			MaterialProperty StencilReference = ShaderGUI.FindProperty("_StencilReference", properties);
			materialEditor.ShaderProperty(StencilReference,"StencilReference");
			EditorGUILayout.Space();
		}

		

		// Shadow
		IsShowShadowSettings = Foldout (IsShowShadowSettings, "Shadow");
		if (IsShowShadowSettings) 
		{
			EditorGUI.indentLevel ++;

				materialEditor.ShaderProperty(HalfLambertToggle, "Shadow Toggle");
	
				var ShadowInspectorToggle = HalfLambertToggle.floatValue;
				if (ShadowInspectorToggle > 0)
				{
					EditorGUI.indentLevel ++;
						
					materialEditor.ShaderProperty(ObjectShadow, "Use System Shadow");
						
					
					EditorGUILayout.Space();
					EditorGUI.indentLevel --;
					EditorGUILayout.LabelField("1st Shadow", EditorStyles.boldLabel);
					EditorGUI.indentLevel ++;
						
					materialEditor.ShaderProperty(Shadow1Contrast, "Shadow 1 Contrast");
					materialEditor.ShaderProperty(Shadow1Color, "Shadow 1 Color");
					materialEditor.ShaderProperty(Shadow1Place, "Shadow 1 Place");
						
					EditorGUILayout.Space();
					EditorGUI.indentLevel --;
					EditorGUILayout.LabelField("2nd Shadow", EditorStyles.boldLabel);
					EditorGUI.indentLevel ++;
						
					materialEditor.ShaderProperty(Shadow2ContrastToggle, "Shadow 2 Contrast Toggle");
					materialEditor.ShaderProperty(Shadow2Contrast, "Shadow 2 Contrast");
					materialEditor.ShaderProperty(Shadow2Color, "Shadow 2 Color");
					materialEditor.ShaderProperty(Shadow2Place, "Shadow 2 Place");
					
					EditorGUILayout.Space();
					EditorGUI.indentLevel --;
					materialEditor.TexturePropertySingleLine(new GUIContent("Shadow Mask"), ShadowMask);
					EditorGUI.indentLevel ++;
					EditorGUILayout.Space();
					
					IsShowAdvancedShadowSettings = EditorGUILayout.Foldout (IsShowAdvancedShadowSettings, "Advanced Shadow Settings", EditorStyles.boldFont);
					if (IsShowAdvancedShadowSettings) 
					{
					
						EditorGUI.indentLevel ++;
							
						materialEditor.ShaderProperty(ShadowColorDarken, "Shadow ColorDarken");
						materialEditor.ShaderProperty(AmbientMinimum, "Ambient Minimum");
						materialEditor.ShaderProperty(PosterizeToggle, "Posterize Toggle");
						materialEditor.ShaderProperty(NormalIntensity, "Normal Intensity");
						materialEditor.ShaderProperty(LightIntensityShadowPos, "Light Intensity Shadow Pos");
						materialEditor.ShaderProperty(VDirLight, "V Dir Light");		
		
						EditorGUI.indentLevel --;
	
					}
						
					EditorGUI.indentLevel --;
				}
			
			
			
			EditorGUI.indentLevel --;
			EditorGUILayout.Space();
		}
		
		// Outline
		if (material.HasProperty("_OutlineWidth"))
		{

			// MaterialProperty OutlineToggleTest = ShaderGUI.FindProperty("_OutlineToggleTest", properties);
			MaterialProperty OutlineWidth = ShaderGUI.FindProperty("_OutlineWidth", properties);
			MaterialProperty OutlineColor = ShaderGUI.FindProperty("_OutlineColor", properties);
			MaterialProperty OutlineMask = ShaderGUI.FindProperty("_OutlineMask", properties);

			IsShowOutlineSettings = Foldout (IsShowOutlineSettings, "Outline");
			if (IsShowOutlineSettings) 
			{
				EditorGUI.indentLevel ++;
				
				// materialEditor.ShaderProperty(OutlineToggleTest, "Outline Toggle Test");
				materialEditor.ShaderProperty(OutlineWidth, "Outline Width");
				materialEditor.ShaderProperty(OutlineColor, "Outline Color");
				materialEditor.TexturePropertySingleLine(new GUIContent("Outline Mask"), OutlineMask);
				
				EditorGUI.indentLevel --;
				EditorGUILayout.Space();
			}
		}


		//Matcap
		IsShowMatcapSettings = Foldout (IsShowMatcapSettings, "Matcap");
		if (IsShowMatcapSettings) 
		{
			// indent increment
			EditorGUI.indentLevel ++;
				
				materialEditor.ShaderProperty(MatcapToggle, "Matcap Toggle");
				
				var MatcapInspectorToggle = MatcapToggle.floatValue;
				if (MatcapInspectorToggle > 0)
				{
					EditorGUI.indentLevel ++;
					materialEditor.TextureProperty(Matcap, "Matcap", false);
					materialEditor.ShaderProperty(MatcapColor, "Matcap Color");
					materialEditor.TexturePropertySingleLine(new GUIContent("Matcap Mask"), MatcapMask);
					EditorGUI.indentLevel --;
				}
				
				EditorGUILayout.Space();
				
				materialEditor.ShaderProperty(MatcapShadowToggle, "Matcap Shadow Toggle");
				
				var MatcapShadowInspectorToggle = MatcapShadowToggle.floatValue;
				if (MatcapShadowInspectorToggle > 0)
				{
				
					EditorGUI.indentLevel ++;
					materialEditor.TextureProperty(MatcapShadow, "Matcap Shadow", false);
					materialEditor.ShaderProperty(MatcapShadowColor, "Matcap Shadow Color");
					EditorGUI.indentLevel --;
				
				}
				
				EditorGUILayout.Space();
				
				EditorGUILayout.LabelField("Matcap Advanced Settings", EditorStyles.boldLabel);
				EditorGUI.indentLevel ++;
				materialEditor.ShaderProperty(ForceMatcap, "Force Matcap");
				materialEditor.ShaderProperty(MatcapCameraFix, "Matcap Camera Fix");
				EditorGUI.indentLevel --;
			
			EditorGUI.indentLevel --;
			EditorGUILayout.Space();
		}
		
		
		
		// Rim Light
		IsShowRimLightSettings = Foldout (IsShowRimLightSettings, "Rim Light");
		if (IsShowRimLightSettings) 
		{
			EditorGUI.indentLevel ++;

			materialEditor.ShaderProperty(RimLightToggle, "Rim Light Toggle");

			var RimLightInspectorToggle = RimLightToggle.floatValue;
			if (RimLightInspectorToggle > 0)
			{
				EditorGUI.indentLevel ++;
				materialEditor.ShaderProperty(RimLightColor, "Rim Light Color");
				materialEditor.ShaderProperty(RimLightPower, "Rim Light Power");
				materialEditor.ShaderProperty(RimLightContrast, "Rim Light Contrast");
				materialEditor.TexturePropertySingleLine(new GUIContent("Rim Light Mask"), RimLightMask);
				materialEditor.ShaderProperty(RimLightNormal, "Rim Light Normal");
				EditorGUI.indentLevel --;
			}
			
			EditorGUI.indentLevel --;
			EditorGUILayout.Space();
		}
		
		
		
		// Reflection
		IsShowReflectionSettings = Foldout (IsShowReflectionSettings, "Reflection");
		if (IsShowReflectionSettings) 
		{
			EditorGUI.indentLevel ++;

			materialEditor.ShaderProperty(ReflectionToggle, "Reflection Toggle");

			var ReflectionInspectorToggle = ReflectionToggle.floatValue;
			if (ReflectionInspectorToggle > 0)
			{	 
				EditorGUI.indentLevel ++;
				materialEditor.ShaderProperty(ReflectionColor, "Reflection Color");
				materialEditor.ShaderProperty(ReflectionIntensity, "Reflection Intensity");
				materialEditor.ShaderProperty(Smoothness, "Smoothness");
				materialEditor.ShaderProperty(FresnelToggle, "Fresnel Toggle");
				materialEditor.ShaderProperty(FresnelPower, "Fresnel Power");
				materialEditor.ShaderProperty(FresnelScale, "Fresnel Scale");
				EditorGUI.indentLevel --;
			}
			
			EditorGUI.indentLevel --;
			EditorGUILayout.Space();
		}
		
		
		
		// Color Shift
		IsShowColorShiftSettings = Foldout (IsShowColorShiftSettings, "Color Shift");
		if (IsShowColorShiftSettings) 
		{
			EditorGUI.indentLevel ++;

			materialEditor.ShaderProperty(ColorShift, "Color Shift Toggle");

			var ColorShiftInspectorToggle = ColorShift.floatValue;
			if (ColorShiftInspectorToggle > 0)
			{
				EditorGUI.indentLevel ++;
				materialEditor.ShaderProperty(H, "H");
				materialEditor.ShaderProperty(S, "S");
				materialEditor.ShaderProperty(V, "V");
				materialEditor.ShaderProperty(GrayscaleColor, "Grayscale Color");		
				EditorGUI.indentLevel --;
			}
			
			EditorGUI.indentLevel --;
			EditorGUILayout.Space();
		}
		
		
		
		// Emission
		IsShowEmissionSettings = Foldout (IsShowEmissionSettings, "Emission");
		if (IsShowEmissionSettings) 
		{
			EditorGUI.indentLevel ++;

			materialEditor.ShaderProperty(ScanLineToggle, "ScanLineToggle");
			
			var ScanLineInspectorToggle = ScanLineToggle.floatValue;
			if (ScanLineInspectorToggle > 0)
			{
				EditorGUI.indentLevel ++;
				materialEditor.TextureProperty(ScanLineTex, "Scan Line Tex", false);
				materialEditor.ShaderProperty(ScanLineColor, "Scan Line Color");
				materialEditor.ShaderProperty(ScanLineColor2Toggle, "Scan Line Color 2 Toggle");
				materialEditor.ShaderProperty(ScanLineColor2, "Scan Line Color 2");
				materialEditor.ShaderProperty(ScanLineSpeed, "Scan Line Speed");
				materialEditor.ShaderProperty(ScanLineWidth, "Scan Line Width");
				materialEditor.ShaderProperty(ScanLinePosition, "Scan Line Position");
				materialEditor.ShaderProperty(Color2ChangeSpeed, "Color 2 Change Speed");
				EditorGUI.indentLevel --;
			}
			
			EditorGUILayout.Space();
			
			materialEditor.ShaderProperty(EmissiveScrollToggle, "Emissive Scroll Toggle");
			
			var EmissiveScrollInspectorToggle = EmissiveScrollToggle.floatValue;
			if (EmissiveScrollInspectorToggle > 0)
			{
				EditorGUI.indentLevel ++;
				materialEditor.ShaderProperty(EmissiveScrollTex, "Emissive Scroll Tex");
				materialEditor.TexturePropertySingleLine(new GUIContent("Emissive Scrol Mask"), EmissiveScrollMask);
				materialEditor.ShaderProperty(EmissiveScrollColor, "Emissiv eScroll Color");
				materialEditor.ShaderProperty(EmissiveScrollSpeed, "Emissive Scroll Speed");
				materialEditor.ShaderProperty(EmissiveScrollGradient, "Emissive Scroll Gradient");
				var EmissiveScrollGradientInspector = EmissiveScrollGradient.floatValue;
				if (EmissiveScrollGradientInspector > 0)
				{
					EditorGUI.indentLevel ++;
					materialEditor.ShaderProperty(EmissiveScrollContrast, "Emissive Scroll Contrast");
					materialEditor.ShaderProperty(EmissiveScrollStrength, "Emissive Scroll Strength");
					EditorGUI.indentLevel --;
				}
				materialEditor.ShaderProperty(ForceEmissiveToggle, "Force Emissive Toggle");
				materialEditor.ShaderProperty(EmissiveScrollTiling, "Emissive Scroll Tiling");
				EditorGUI.indentLevel --;
			}
			
			EditorGUILayout.Space();
			
			IsShowParallaxEmission = EditorGUILayout.Foldout (IsShowParallaxEmission, "Parallax Emission", EditorStyles.boldFont);
			if (IsShowParallaxEmission) 
			{
				
				EditorGUI.indentLevel ++;
				materialEditor.ShaderProperty(ParallaxEmission, "Parallax Emission");
				materialEditor.ShaderProperty(ParallaxTiling, "Parallax Tiling");
				materialEditor.ShaderProperty(ParallaxScale, "Parallax Scale");
				materialEditor.ShaderProperty(ParallaxHight, "Parallax Hight");
				materialEditor.TexturePropertySingleLine(new GUIContent("Parallax Mask"), ParallaxMask);
				EditorGUI.indentLevel --;

			}
			
			EditorGUI.indentLevel --;
			EditorGUILayout.Space();
		}
		


		// Advanced Settings
		IsShowAdvancedSettings = Foldout (IsShowAdvancedSettings, "Advanced Settings");
		if (IsShowAdvancedSettings) 
		{
			// indent increment
			EditorGUI.indentLevel ++;
			EditorGUILayout.HelpBox ("You should not change these parameters.", MessageType.Info); // Message
			materialEditor.ShaderProperty(Unlit, "Unlit");
			materialEditor.ShaderProperty(CullMode, "CullMode");
			materialEditor.RenderQueueField();
			EditorGUI.indentLevel --;
		}

		EditorGUILayout.LabelField ( "Current ReflexShader Version: " + _RSVersion, EditorStyles.boldLabel);

	}
}
