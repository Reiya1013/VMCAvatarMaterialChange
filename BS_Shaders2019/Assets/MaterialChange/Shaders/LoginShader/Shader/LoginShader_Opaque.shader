//--------------------------------------------------------------
//              Login Shader    Ver 1.0.0
//
//                      Copyright (c) 2022 Reiya1013
//                              Twitter : @Reiya__
//
// This software is released under the MIT License.
//--------------------------------------------------------------

Shader "BeatSaber/LoginShader/Opaque" {


	Properties {

		[NoScaleOffset]
		_MainTex           ("Main Texture"              , 2D) = "white" {}
		_Color             ("Color"                     , Color) = (1,1,1,1)

		[SToggle]
		_TeleportEnable("Enable Teleport"					, int) = 0

		[SToggle]
		_DisolveEnable("Enable Disolve"					, int) = 0
		_DisolveTex("DisolveTex (RGB)"					, 2D) = "white" {}
		_DisolveEmissionColor("Disolve Emission Color"			, Color) = (1,1,1)
		_DisolveEmission("Disolve Emission Intensity"		, Range(0.0,  2.0)) = 1.0
		_DisolveThreshold("DisolveThreshold"			, Range(0,1)) = 0.0

		[SToggle]
		_EnableGeometry("Enable Geometry"					, int) = 0
		_Destruction("Destruction"						, Range(0,1)) = 0.0
		_ScaleFactor("Scale Factor"						, Range(0,1)) = 0.0
		_RotationFactor("Rotation Factor"					, Range(0,1)) = 0.0
		_PositionFactor("Position Factor"					, Range(0,1)) = 0.0
		_PositionAdd("Position AddPoint"				, Range(-1,1)) = 0.0
		_DisplayUpPosition("Display Up Position"				, Range(-10,10)) = 0.0


	}



	SubShader {

		LOD 0

		Tags {
			"IgnoreProjector" = "False"
			"RenderType"      = "Opaque"
			"Queue"           = "Geometry"
		}


		Pass {
			Tags {
				"LightMode"  = "ForwardBase"
			}

			Cull Off
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#pragma target 4.0

			#define PASS_FB

			#include "./cginc/LoginShader_Core.cginc"

			ENDCG
		}

	}

	FallBack "Diffuse"
}

