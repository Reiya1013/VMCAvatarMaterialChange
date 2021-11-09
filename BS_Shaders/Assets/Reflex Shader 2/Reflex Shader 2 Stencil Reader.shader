// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Reflex Shader 2/Stencil/Reader"
{
	Properties
	{
		_MainTex("Diffuse", 2D) = "white" {}
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
		_EmissionMap("Emission", 2D) = "black" {}
		_EmissionColor("Emission Color", Color) = (1,1,1,1)
		[Normal]_BumpMap("Normal Map", 2D) = "bump" {}
		_Matcap("Matcap", 2D) = "black" {}
		_MatcapColor("Matcap Color", Color) = (1,1,1,1)
		[Toggle(_)]_MatcapShadowToggle("Matcap Shadow Toggle", Float) = 0
		_MatcapShadow("Matcap Shadow", 2D) = "white" {}
		_MatcapShadowColor("Matcap Shadow Color", Color) = (0.7843137,0.7843137,0.7843137,1)
		[NoScaleOffset]_MatcapMask("Matcap Mask", 2D) = "white" {}
		[Toggle(_)]_MatcapCameraFix("Matcap Camera Fix", Float) = 0
		[Toggle(_)]_RimLightToggle("RimLight Toggle", Float) = 0
		_RimLightColor("RimLight Color", Color) = (1,1,1,1)
		_RimLightPower("RimLight Power", Range( 0 , 1)) = 0
		_RimLightContrast("RimLight Contrast", Range( 0 , 10)) = 3
		[NoScaleOffset]_RimLightMask("RimLight Mask", 2D) = "white" {}
		[Toggle]_RimLightNormal("RimLight Normal", Float) = 0
		_OutlineWidth("Outline Width", Range( 0 , 1)) = 0
		_OutlineColor("Outline Color", Color) = (0.2941176,0.2941176,0.2941176,1)
		[NoScaleOffset]_OutlineMask("Outline Mask", 2D) = "white" {}
		[Toggle(_REFLECTIONTOGGLE_ON)] _ReflectionToggle("Reflection Toggle", Float) = 0
		_ReflectionColor("Reflection Color", Color) = (1,1,1,0)
		_ReflectionIntensity("Reflection Intensity", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[Toggle(_)]_FresnelToggle("Fresnel Toggle", Float) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 9
		_FresnelScale("Fresnel Scale", Range( 0 , 3)) = 3
		[Toggle(_)]_HalfLambertToggle("ShaodwToggle", Float) = 1
		[Toggle(_)]_ObjectShadow("Use System Shadow", Float) = 1
		_Shadow1Contrast("Shadow 1 Contrast", Range( 1 , 20)) = 10
		_Shadow1Color("Shadow 1 Color", Color) = (0.8627451,0.8627451,0.8627451,1)
		_Shadow1Place("Shadow 1 Place", Range( -1 , 1)) = 0
		[Toggle(_)]_Shadow2ContrastToggle("Shadow 2 Contrast Toggle", Float) = 0
		_Shadow2Contrast("Shadow 2 Contrast", Range( 1 , 20)) = 20
		_Shadow2Color("Shadow 2 Color", Color) = (0.7843137,0.7843137,0.7843137,1)
		_Shadow2Place("Shadow 2 Place", Range( -1 , 1)) = 0.1
		[NoScaleOffset]_ShadowMask("Shadow Mask", 2D) = "white" {}
		[Toggle(_)]_ShadowColorDarken("Shadow Color Darken", Float) = 1
		_AmbientMinimum("Ambient Minimum", Range( 0 , 1)) = 0
		[Toggle(_)]_PosterizeToggle("Posterize Toggle", Float) = 0
		_NormalIntensity("Normal Intensity", Range( 0 , 1)) = 0.5
		[Toggle(_)]_LightIntensityShadowPos("Light Intensity Shadow Pos", Float) = 0
		_VDirLight("V Dir Light", Vector) = (0,0.6,1,0)
		[Toggle(_)]_ColorShift("Color Shift", Float) = 0
		_H("H", Range( -1 , 1)) = 1
		_S("S", Range( -1 , 1)) = 0
		_V("V", Range( -1 , 1)) = 0
		[Toggle(_)]_ScanLineToggle("Scan Line Toggle", Float) = 0
		[NoScaleOffset]_ScanLineTex("Scan Line Mask", 2D) = "white" {}
		_ScanLineColor("Scan Line Color", Color) = (0,0.710345,1,0)
		_ScanLineColor2("Scan Line Color 2", Color) = (1,0,0,0)
		_ScanLineSpeed("Scan Line Speed", Float) = 1
		_ScanLineWidth("Scan Line Width", Range( 0 , 1)) = 1
		_ScanLinePosition("Scan Line Position", Float) = 0
		[Toggle(_)]_ScanLineColor2Toggle("Scan Line Color 2 Toggle", Float) = 0
		_Color2ChangeSpeed("Color 2 Change Speed", Float) = 1
		[NoScaleOffset]_EmissiveScrollTex("Emissive Scroll Tex", 2D) = "black" {}
		[NoScaleOffset]_EmissiveScrollMask("Emissive Scroll Mask", 2D) = "white" {}
		_EmissiveScrollColor("Emissive Scroll Color", Color) = (1,1,1,1)
		_EmissiveScrollSpeed("Emissive Scroll Speed", Vector) = (1,0,0,0)
		[Toggle(_)]_EmissiveScrollGradient("Emissive Scroll Gradient", Float) = 0
		_EmissiveScrollContrast("Emissive Scroll Contrast", Float) = 1
		_EmissiveScrollStrength("Emissive Scroll Strength", Float) = 0
		[Toggle(_)]_ForceEmissiveToggle("Force Emissive Toggle", Float) = 0
		_EmissiveScrollTiling("Emissive Scroll Tiling", Vector) = (1,1,0,0)
		[NoScaleOffset]_ParallaxEmission("Parallax Emission", 2D) = "black" {}
		_ParallaxTiling("Parallax Tiling", Vector) = (1,1,0,0)
		_ParallaxScale("Parallax Scale", Float) = 1
		[Toggle(_)]_ForceMatcap("Force Matcap", Float) = 0
		[Toggle(_)]_MatcapToggle("Matcap Toggle", Float) = 0
		[Toggle(_)]_EmissiveScrollToggle("Emissive Scroll Toggle", Float) = 0
		_ParallaxHight("Parallax Hight", Float) = 1
		_ParallaxMask("Parallax Mask", 2D) = "white" {}
		[Toggle(_)]_GrayscaleColor("Grayscale Color", Float) = 0
		[Toggle(_)]_Unlit("Unlit", Float) = 0
		_CullMode("Cull Mode", Float) = 2
		_StencilReference("Stencil Reference", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		Stencil
		{
			Ref [_StencilReference]
			Comp NotEqual
			Pass Keep
		}
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_OutlineMask389_g83 = v.texcoord;
			float outlineVar = ( (0.0 + (_OutlineWidth - 0.0) * (0.002 - 0.0) / (1.0 - 0.0)) * tex2Dlod( _OutlineMask, float4( uv_OutlineMask389_g83, 0, 0.0) ) ).r;
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_84_0_g83 = ( tex2D( _MainTex, uv_MainTex ) * _DiffuseColor );
			float4 DiffuseBase606_g83 = temp_output_84_0_g83;
			float grayscale611_g83 = dot(DiffuseBase606_g83.rgb, float3(0.299,0.587,0.114));
			float4 temp_cast_1 = (grayscale611_g83).xxxx;
			float4 lerpResult745_g83 = lerp( DiffuseBase606_g83 , temp_cast_1 , _GrayscaleColor);
			float3 hsvTorgb595_g83 = RGBToHSV( lerpResult745_g83.rgb );
			float3 hsvTorgb603_g83 = HSVToRGB( float3(( hsvTorgb595_g83.x + _H ),( hsvTorgb595_g83.y + _S ),( hsvTorgb595_g83.z + _V )) );
			float4 lerpResult742_g83 = lerp( DiffuseBase606_g83 , float4( hsvTorgb603_g83 , 0.0 ) , _ColorShift);
			float4 Diffuse105_g83 = lerpResult742_g83;
			float3 appendResult387_g83 = (float3(_OutlineColor.r , _OutlineColor.g , _OutlineColor.b));
			float3 localFunction_ShadeSH9411_g83 = Function_ShadeSH9();
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 ifLocalVar196_g83 = 0;
			if( _WorldSpaceLightPos0.w <= 0.0 )
				ifLocalVar196_g83 = ase_lightColor;
			else
				ifLocalVar196_g83 = ( 1 * ase_lightColor );
			float4 temp_cast_6 = (_AmbientMinimum).xxxx;
			float4 clampResult650_g83 = clamp( ( float4( localFunction_ShadeSH9411_g83 , 0.0 ) + ifLocalVar196_g83 ) , temp_cast_6 , float4( 1,1,1,1 ) );
			float4 temp_cast_7 = (1.0).xxxx;
			float4 lerpResult723_g83 = lerp( saturate( clampResult650_g83 ) , temp_cast_7 , _Unlit);
			float4 Lighting201_g83 = lerpResult723_g83;
			float4 temp_cast_8 = (1.0).xxxx;
			float4 blendOpSrc365_g83 = _Shadow1Color;
			float4 blendOpDest365_g83 = _Shadow2Color;
			float4 lerpResult733_g83 = lerp( _Shadow2Color , ( saturate( min( blendOpSrc365_g83 , blendOpDest365_g83 ) )) , _ShadowColorDarken);
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 tex2DNode207_g83 = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float3 NormalMap208_g83 = tex2DNode207_g83;
			float3 lerpResult333_g83 = lerp( float3( 0,0,1 ) , NormalMap208_g83 , _NormalIntensity);
			float3 newWorldNormal334_g83 = (WorldNormalVector( i , lerpResult333_g83 ));
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g84 = dot( newWorldNormal334_g83 , ase_worldlightDir );
			float temp_output_335_0_g83 = (dotResult5_g84*0.5 + 0.5);
			float lerpResult726_g83 = lerp( temp_output_335_0_g83 , saturate( ( temp_output_335_0_g83 * 1 ) ) , _ObjectShadow);
			float grayscale544_g83 = (ase_lightColor.rgb.r + ase_lightColor.rgb.g + ase_lightColor.rgb.b) / 3;
			float3 localFunction_ShadeSH9567_g83 = Function_ShadeSH9();
			float grayscale568_g83 = (localFunction_ShadeSH9567_g83.r + localFunction_ShadeSH9567_g83.g + localFunction_ShadeSH9567_g83.b) / 3;
			float blendOpSrc566_g83 = grayscale544_g83;
			float blendOpDest566_g83 = grayscale568_g83;
			float lerpResult729_g83 = lerp( lerpResult726_g83 , ( ( saturate( 	max( blendOpSrc566_g83, blendOpDest566_g83 ) )) * lerpResult726_g83 ) , _LightIntensityShadowPos);
			float3 localBakedDirectionalLight746_g83 = BakedDirectionalLight746_g83();
			float dotResult441_g83 = dot( localBakedDirectionalLight746_g83 , newWorldNormal334_g83 );
			float temp_output_538_0_g83 = ( ( dotResult441_g83 * 0.5 ) + 0.5 );
			float ifLocalVar431_g83 = 0;
			if( ase_lightColor.a <= 0.0 )
				ifLocalVar431_g83 = temp_output_538_0_g83;
			else
				ifLocalVar431_g83 = lerpResult729_g83;
			float3 VDirLight648_g83 = _VDirLight;
			float4 transform617_g83 = mul(unity_ObjectToWorld,float4( VDirLight648_g83 , 0.0 ));
			float3 lerpResult624_g83 = lerp( float3( 0,0,1 ) , NormalMap208_g83 , _NormalIntensity);
			float dotResult613_g83 = dot( transform617_g83 , float4( (WorldNormalVector( i , lerpResult624_g83 )) , 0.0 ) );
			float FixedShadow627_g83 = ( ( dotResult613_g83 * 0.5 ) + 0.5 );
			float lerpResult724_g83 = lerp( ifLocalVar431_g83 , FixedShadow627_g83 , _Unlit);
			float temp_output_351_0_g83 = ( ( ( ( _Shadow1Place + lerpResult724_g83 ) - 0.5 ) * _Shadow1Contrast ) + 0.5 );
			float4 temp_cast_12 = (temp_output_351_0_g83).xxxx;
			float4 temp_cast_14 = (temp_output_351_0_g83).xxxx;
			float div354_g83=256.0/float((int)255.0);
			float4 posterize354_g83 = ( floor( temp_cast_14 * div354_g83 ) / div354_g83 );
			float4 lerpResult720_g83 = lerp( temp_cast_12 , posterize354_g83 , _PosterizeToggle);
			float4 temp_cast_15 = (0.0).xxxx;
			float4 temp_cast_16 = (1.0).xxxx;
			float4 clampResult364_g83 = clamp( lerpResult720_g83 , temp_cast_15 , temp_cast_16 );
			float4 lerpResult366_g83 = lerp( _Shadow1Color , float4( 1,1,1,0 ) , clampResult364_g83);
			float lerpResult732_g83 = lerp( _Shadow1Contrast , _Shadow2Contrast , _Shadow2ContrastToggle);
			float temp_output_353_0_g83 = ( ( ( ( _Shadow2Place + lerpResult724_g83 ) - 0.5 ) * lerpResult732_g83 ) + 0.5 );
			float4 temp_cast_17 = (temp_output_353_0_g83).xxxx;
			float4 temp_cast_19 = (temp_output_353_0_g83).xxxx;
			float div356_g83=256.0/float((int)255.0);
			float4 posterize356_g83 = ( floor( temp_cast_19 * div356_g83 ) / div356_g83 );
			float4 lerpResult721_g83 = lerp( temp_cast_17 , posterize356_g83 , _PosterizeToggle);
			float4 temp_cast_20 = (0.0).xxxx;
			float4 temp_cast_21 = (1.0).xxxx;
			float4 clampResult363_g83 = clamp( lerpResult721_g83 , temp_cast_20 , temp_cast_21 );
			float4 lerpResult368_g83 = lerp( lerpResult733_g83 , lerpResult366_g83 , clampResult363_g83);
			float2 uv_ShadowMask369_g83 = i.uv_texcoord;
			float4 lerpResult372_g83 = lerp( float4( 1,1,1,1 ) , lerpResult368_g83 , tex2D( _ShadowMask, uv_ShadowMask369_g83 ));
			float4 lerpResult735_g83 = lerp( temp_cast_8 , lerpResult372_g83 , _HalfLambertToggle);
			float4 Shadow375_g83 = lerpResult735_g83;
			float2 uv_ScanLineTex526_g83 = i.uv_texcoord;
			float3 worldToObj529_g83 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			float4 lerpResult513_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _ScanLineTex, uv_ScanLineTex526_g83 ) ,  ( ( worldToObj529_g83.y + _ScanLinePosition ) - (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) > ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) ? 0.0 : ( worldToObj529_g83.y + _ScanLinePosition ) - (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) <= ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) && ( worldToObj529_g83.y + _ScanLinePosition ) + (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) >= ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) ? 1.0 : 0.0 ) );
			float mulTime583_g83 = _Time.y * _Color2ChangeSpeed;
			float4 lerpResult578_g83 = lerp( _ScanLineColor , _ScanLineColor2 , sin( mulTime583_g83 ));
			float4 lerpResult704_g83 = lerp( _ScanLineColor , lerpResult578_g83 , _ScanLineColor2Toggle);
			float4 lerpResult702_g83 = lerp( float4( 0,0,0,0 ) , ( lerpResult513_g83 * lerpResult704_g83 ) , _ScanLineToggle);
			float4 ScanLineEmission534_g83 = lerpResult702_g83;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv_TexCoord485_g83 = i.uv_texcoord * _EmissiveScrollTiling + ( _Time.x * _EmissiveScrollSpeed );
			float2 uv_EmissiveScrollMask466_g83 = i.uv_texcoord;
			float4 tex2DNode466_g83 = tex2D( _EmissiveScrollMask, uv_EmissiveScrollMask466_g83 );
			float4 lerpResult468_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _EmissiveScrollTex, uv_TexCoord485_g83 ) , tex2DNode466_g83);
			float2 ScrollDir469_g83 = _EmissiveScrollSpeed;
			float dotResult461_g83 = dot( i.uv_texcoord , ScrollDir469_g83 );
			float4 lerpResult504_g83 = lerp( float4( 0,0,0,0 ) , ( _EmissiveScrollColor * ( 1.0 - saturate( ( ( ( ( ( cos( ( UNITY_PI * ( ( dotResult461_g83 + _Time.y ) * ScrollDir469_g83 ) ) ).x + 0.0 ) + _EmissiveScrollStrength ) - 0.5 ) * _EmissiveScrollContrast ) + 0.5 ) ) ) ) , tex2DNode466_g83);
			float4 lerpResult700_g83 = lerp( ( lerpResult468_g83 * _EmissiveScrollColor ) , lerpResult504_g83 , _EmissiveScrollGradient);
			float4 EmissiveScroll507_g83 = saturate( lerpResult700_g83 );
			float4 lerpResult706_g83 = lerp( float4( 0,0,0,0 ) , EmissiveScroll507_g83 , _EmissiveScrollToggle);
			float2 uv_TexCoord574_g83 = i.uv_texcoord * _ParallaxTiling;
			float2 Offset573_g83 = ( ( _ParallaxHight - 1 ) * i.viewDir.xy * _ParallaxScale ) + uv_TexCoord574_g83;
			float2 uv_ParallaxMask = i.uv_texcoord * _ParallaxMask_ST.xy + _ParallaxMask_ST.zw;
			float4 lerpResult588_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _ParallaxEmission, Offset573_g83 ) , tex2D( _ParallaxMask, uv_ParallaxMask ));
			float4 temp_output_452_0_g83 = ( ScanLineEmission534_g83 + ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ) + lerpResult706_g83 + lerpResult588_g83 );
			float4 Emission679_g83 = temp_output_452_0_g83;
			o.Emission = ( ( float4( ( (Diffuse105_g83).rgb * appendResult387_g83 ) , 0.0 ) * Lighting201_g83 * Shadow375_g83 ) + Emission679_g83 ).rgb;
			o.Normal = float3(0,0,-1);
		}
		ENDCG
		

		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+1" "IsEmissive" = "true"  }
		Cull Back
		Stencil
		{
			Ref [_StencilReference]
			Comp NotEqual
			Pass Keep
		}
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _REFLECTIONTOGGLE_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _CullMode;
		uniform float _StencilReference;
		uniform sampler2D _ScanLineTex;
		uniform float _ScanLinePosition;
		uniform float _ScanLineSpeed;
		uniform float _ScanLineWidth;
		uniform float4 _ScanLineColor;
		uniform float4 _ScanLineColor2;
		uniform float _Color2ChangeSpeed;
		uniform float _ScanLineColor2Toggle;
		uniform float _ScanLineToggle;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissiveScrollTex;
		uniform float2 _EmissiveScrollTiling;
		uniform float2 _EmissiveScrollSpeed;
		uniform sampler2D _EmissiveScrollMask;
		uniform float4 _EmissiveScrollColor;
		uniform float _EmissiveScrollStrength;
		uniform float _EmissiveScrollContrast;
		uniform float _EmissiveScrollGradient;
		uniform float _EmissiveScrollToggle;
		uniform sampler2D _ParallaxEmission;
		uniform float2 _ParallaxTiling;
		uniform float _ParallaxHight;
		uniform float _ParallaxScale;
		uniform sampler2D _ParallaxMask;
		uniform float4 _ParallaxMask_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _DiffuseColor;
		uniform float _RimLightNormal;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _RimLightPower;
		uniform float _RimLightContrast;
		uniform float4 _RimLightColor;
		uniform sampler2D _RimLightMask;
		uniform float _RimLightToggle;
		uniform sampler2D _Matcap;
		uniform float _MatcapCameraFix;
		uniform float4 _MatcapColor;
		uniform sampler2D _MatcapMask;
		uniform float _MatcapToggle;
		uniform float _GrayscaleColor;
		uniform float _H;
		uniform float _S;
		uniform float _V;
		uniform float _ColorShift;
		uniform float _ForceMatcap;
		uniform float _Smoothness;
		uniform float4 _ReflectionColor;
		uniform float _ReflectionIntensity;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _FresnelToggle;
		uniform sampler2D _MatcapShadow;
		uniform float _MatcapShadowToggle;
		uniform float4 _MatcapShadowColor;
		uniform float _AmbientMinimum;
		uniform float _Unlit;
		uniform float4 _Shadow2Color;
		uniform float4 _Shadow1Color;
		uniform float _ShadowColorDarken;
		uniform float _Shadow1Place;
		uniform float _NormalIntensity;
		uniform float _ObjectShadow;
		uniform float _LightIntensityShadowPos;
		uniform float3 _VDirLight;
		uniform float _Shadow1Contrast;
		uniform float _PosterizeToggle;
		uniform float _Shadow2Place;
		uniform float _Shadow2Contrast;
		uniform float _Shadow2ContrastToggle;
		uniform sampler2D _ShadowMask;
		uniform float _HalfLambertToggle;
		uniform float _ForceEmissiveToggle;
		uniform float _Cutoff = 0.5;
		uniform float _OutlineWidth;
		uniform sampler2D _OutlineMask;
		uniform float4 _OutlineColor;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		float3 Function_ShadeSH9(  )
		{
			return ShadeSH9(half4(0,0,0,1));
		}


		float3 BakedDirectionalLight746_g83(  )
		{
			return normalize(unity_SHAr.rgb *0.3+unity_SHAg.rgb*0.6+unity_SHAb.rgb*0.1);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += 0;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_84_0_g83 = ( tex2D( _MainTex, uv_MainTex ) * _DiffuseColor );
			float2 uv_ScanLineTex526_g83 = i.uv_texcoord;
			float3 ase_worldPos = i.worldPos;
			float3 worldToObj529_g83 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			float4 lerpResult513_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _ScanLineTex, uv_ScanLineTex526_g83 ) ,  ( ( worldToObj529_g83.y + _ScanLinePosition ) - (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) > ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) ? 0.0 : ( worldToObj529_g83.y + _ScanLinePosition ) - (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) <= ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) && ( worldToObj529_g83.y + _ScanLinePosition ) + (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) >= ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) ? 1.0 : 0.0 ) );
			float mulTime583_g83 = _Time.y * _Color2ChangeSpeed;
			float4 lerpResult578_g83 = lerp( _ScanLineColor , _ScanLineColor2 , sin( mulTime583_g83 ));
			float4 lerpResult704_g83 = lerp( _ScanLineColor , lerpResult578_g83 , _ScanLineColor2Toggle);
			float4 lerpResult702_g83 = lerp( float4( 0,0,0,0 ) , ( lerpResult513_g83 * lerpResult704_g83 ) , _ScanLineToggle);
			float4 ScanLineEmission534_g83 = lerpResult702_g83;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv_TexCoord485_g83 = i.uv_texcoord * _EmissiveScrollTiling + ( _Time.x * _EmissiveScrollSpeed );
			float2 uv_EmissiveScrollMask466_g83 = i.uv_texcoord;
			float4 tex2DNode466_g83 = tex2D( _EmissiveScrollMask, uv_EmissiveScrollMask466_g83 );
			float4 lerpResult468_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _EmissiveScrollTex, uv_TexCoord485_g83 ) , tex2DNode466_g83);
			float2 ScrollDir469_g83 = _EmissiveScrollSpeed;
			float dotResult461_g83 = dot( i.uv_texcoord , ScrollDir469_g83 );
			float4 lerpResult504_g83 = lerp( float4( 0,0,0,0 ) , ( _EmissiveScrollColor * ( 1.0 - saturate( ( ( ( ( ( cos( ( UNITY_PI * ( ( dotResult461_g83 + _Time.y ) * ScrollDir469_g83 ) ) ).x + 0.0 ) + _EmissiveScrollStrength ) - 0.5 ) * _EmissiveScrollContrast ) + 0.5 ) ) ) ) , tex2DNode466_g83);
			float4 lerpResult700_g83 = lerp( ( lerpResult468_g83 * _EmissiveScrollColor ) , lerpResult504_g83 , _EmissiveScrollGradient);
			float4 EmissiveScroll507_g83 = saturate( lerpResult700_g83 );
			float4 lerpResult706_g83 = lerp( float4( 0,0,0,0 ) , EmissiveScroll507_g83 , _EmissiveScrollToggle);
			float2 uv_TexCoord574_g83 = i.uv_texcoord * _ParallaxTiling;
			float2 Offset573_g83 = ( ( _ParallaxHight - 1 ) * i.viewDir.xy * _ParallaxScale ) + uv_TexCoord574_g83;
			float2 uv_ParallaxMask = i.uv_texcoord * _ParallaxMask_ST.xy + _ParallaxMask_ST.zw;
			float4 lerpResult588_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _ParallaxEmission, Offset573_g83 ) , tex2D( _ParallaxMask, uv_ParallaxMask ));
			float4 temp_output_452_0_g83 = ( ScanLineEmission534_g83 + ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ) + lerpResult706_g83 + lerpResult588_g83 );
			float4 Emission679_g83 = temp_output_452_0_g83;
			float Opacity674_g83 = saturate( max( temp_output_84_0_g83.a , Emission679_g83.a ) );
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 tex2DNode207_g83 = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult214_g83 = dot( (WorldNormalVector( i , lerp(float3( 0,0,1 ),tex2DNode207_g83,_RimLightNormal) )) , ase_worldViewDir );
			float2 uv_RimLightMask225_g83 = i.uv_texcoord;
			float4 lerpResult230_g83 = lerp( ( ( ( ( ( abs( ( 1.0 - dotResult214_g83 ) ) * _RimLightPower ) - 0.5 ) * _RimLightContrast ) + 0.5 ) * _RimLightColor ) , float4( 0,0,0,0 ) , ( 1.0 - tex2D( _RimLightMask, uv_RimLightMask225_g83 ) ));
			float4 lerpResult708_g83 = lerp( float4( 0,0,0,0 ) , lerpResult230_g83 , _RimLightToggle);
			float4 RimLight233_g83 = saturate( lerpResult708_g83 );
			float3 NormalMap208_g83 = tex2DNode207_g83;
			float3 temp_output_240_0_g83 = mul( UNITY_MATRIX_V, float4( (WorldNormalVector( i , NormalMap208_g83 )) , 0.0 ) ).xyz;
			float3 worldToViewDir556_g83 = mul( UNITY_MATRIX_V, float4( ase_worldViewDir, 0 ) ).xyz;
			float2 lerpResult737_g83 = lerp( (temp_output_240_0_g83).xy , (BlendNormals( ( worldToViewDir556_g83 * float3(-1,-1,1) ) , temp_output_240_0_g83 )).xy , _MatcapCameraFix);
			float2 temp_output_244_0_g83 = ( 0.5 + ( 0.5 * lerpResult737_g83 ) );
			float4 blendOpSrc251_g83 = tex2D( _Matcap, temp_output_244_0_g83 );
			float4 blendOpDest251_g83 = _MatcapColor;
			float2 uv_MatcapMask246_g83 = i.uv_texcoord;
			float4 tex2DNode246_g83 = tex2D( _MatcapMask, uv_MatcapMask246_g83 );
			float4 lerpResult254_g83 = lerp( float4( 0,0,0,0 ) , ( saturate( ( blendOpSrc251_g83 * blendOpDest251_g83 ) )) , tex2DNode246_g83);
			float4 lerpResult709_g83 = lerp( float4( 0,0,0,0 ) , lerpResult254_g83 , _MatcapToggle);
			float4 DiffuseBase606_g83 = temp_output_84_0_g83;
			float grayscale611_g83 = dot(DiffuseBase606_g83.rgb, float3(0.299,0.587,0.114));
			float4 temp_cast_6 = (grayscale611_g83).xxxx;
			float4 lerpResult745_g83 = lerp( DiffuseBase606_g83 , temp_cast_6 , _GrayscaleColor);
			float3 hsvTorgb595_g83 = RGBToHSV( lerpResult745_g83.rgb );
			float3 hsvTorgb603_g83 = HSVToRGB( float3(( hsvTorgb595_g83.x + _H ),( hsvTorgb595_g83.y + _S ),( hsvTorgb595_g83.z + _V )) );
			float4 lerpResult742_g83 = lerp( DiffuseBase606_g83 , float4( hsvTorgb603_g83 , 0.0 ) , _ColorShift);
			float4 Diffuse105_g83 = lerpResult742_g83;
			float4 lerpResult252_g83 = lerp( Diffuse105_g83 , float4( 0,0,0,0 ) , tex2DNode246_g83);
			float4 lerpResult713_g83 = lerp( Diffuse105_g83 , lerpResult252_g83 , _ForceMatcap);
			float4 Matcap260_g83 = ( lerpResult709_g83 + lerpResult713_g83 );
			float3 indirectNormal281_g83 = WorldNormalVector( i , NormalMap208_g83 );
			Unity_GlossyEnvironmentData g281_g83 = UnityGlossyEnvironmentSetup( _Smoothness, data.worldViewDir, indirectNormal281_g83, float3(0,0,0));
			float3 indirectSpecular281_g83 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal281_g83, g281_g83 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV275_g83 = dot( mul(ase_tangentToWorldFast,NormalMap208_g83), ase_worldViewDir );
			float fresnelNode275_g83 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV275_g83, _FresnelPower ) );
			float lerpResult699_g83 = lerp( 1.0 , fresnelNode275_g83 , _FresnelToggle);
			float4 lerpResult278_g83 = lerp( float4( 0,0,0,0 ) , ( ( float4( indirectSpecular281_g83 , 0.0 ) * _ReflectionColor ) * _ReflectionIntensity ) , saturate( lerpResult699_g83 ));
			#ifdef _REFLECTIONTOGGLE_ON
				float4 staticSwitch549_g83 = lerpResult278_g83;
			#else
				float4 staticSwitch549_g83 = float4( 0,0,0,0 );
			#endif
			float4 Reflection280_g83 = saturate( staticSwitch549_g83 );
			float4 lerpResult740_g83 = lerp( float4( 1,1,1,1 ) , tex2D( _MatcapShadow, temp_output_244_0_g83 ) , _MatcapShadowToggle);
			float4 blendOpSrc259_g83 = lerpResult740_g83;
			float4 blendOpDest259_g83 = _MatcapShadowColor;
			float4 MatcapShadow261_g83 = ( saturate( ( blendOpSrc259_g83 + blendOpDest259_g83 ) ));
			float3 localFunction_ShadeSH9411_g83 = Function_ShadeSH9();
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 ifLocalVar196_g83 = 0;
			if( _WorldSpaceLightPos0.w <= 0.0 )
				ifLocalVar196_g83 = ase_lightColor;
			else
				ifLocalVar196_g83 = ( ase_lightAtten * ase_lightColor );
			float4 temp_cast_11 = (_AmbientMinimum).xxxx;
			float4 clampResult650_g83 = clamp( ( float4( localFunction_ShadeSH9411_g83 , 0.0 ) + ifLocalVar196_g83 ) , temp_cast_11 , float4( 1,1,1,1 ) );
			float4 temp_cast_12 = (1.0).xxxx;
			float4 lerpResult723_g83 = lerp( saturate( clampResult650_g83 ) , temp_cast_12 , _Unlit);
			float4 Lighting201_g83 = lerpResult723_g83;
			float4 temp_cast_13 = (1.0).xxxx;
			float4 blendOpSrc365_g83 = _Shadow1Color;
			float4 blendOpDest365_g83 = _Shadow2Color;
			float4 lerpResult733_g83 = lerp( _Shadow2Color , ( saturate( min( blendOpSrc365_g83 , blendOpDest365_g83 ) )) , _ShadowColorDarken);
			float3 lerpResult333_g83 = lerp( float3( 0,0,1 ) , NormalMap208_g83 , _NormalIntensity);
			float3 newWorldNormal334_g83 = (WorldNormalVector( i , lerpResult333_g83 ));
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult5_g84 = dot( newWorldNormal334_g83 , ase_worldlightDir );
			float temp_output_335_0_g83 = (dotResult5_g84*0.5 + 0.5);
			float lerpResult726_g83 = lerp( temp_output_335_0_g83 , saturate( ( temp_output_335_0_g83 * ase_lightAtten ) ) , _ObjectShadow);
			float grayscale544_g83 = (ase_lightColor.rgb.r + ase_lightColor.rgb.g + ase_lightColor.rgb.b) / 3;
			float3 localFunction_ShadeSH9567_g83 = Function_ShadeSH9();
			float grayscale568_g83 = (localFunction_ShadeSH9567_g83.r + localFunction_ShadeSH9567_g83.g + localFunction_ShadeSH9567_g83.b) / 3;
			float blendOpSrc566_g83 = grayscale544_g83;
			float blendOpDest566_g83 = grayscale568_g83;
			float lerpResult729_g83 = lerp( lerpResult726_g83 , ( ( saturate( 	max( blendOpSrc566_g83, blendOpDest566_g83 ) )) * lerpResult726_g83 ) , _LightIntensityShadowPos);
			float3 localBakedDirectionalLight746_g83 = BakedDirectionalLight746_g83();
			float dotResult441_g83 = dot( localBakedDirectionalLight746_g83 , newWorldNormal334_g83 );
			float temp_output_538_0_g83 = ( ( dotResult441_g83 * 0.5 ) + 0.5 );
			float ifLocalVar431_g83 = 0;
			if( ase_lightColor.a <= 0.0 )
				ifLocalVar431_g83 = temp_output_538_0_g83;
			else
				ifLocalVar431_g83 = lerpResult729_g83;
			float3 VDirLight648_g83 = _VDirLight;
			float4 transform617_g83 = mul(unity_ObjectToWorld,float4( VDirLight648_g83 , 0.0 ));
			float3 lerpResult624_g83 = lerp( float3( 0,0,1 ) , NormalMap208_g83 , _NormalIntensity);
			float dotResult613_g83 = dot( transform617_g83 , float4( (WorldNormalVector( i , lerpResult624_g83 )) , 0.0 ) );
			float FixedShadow627_g83 = ( ( dotResult613_g83 * 0.5 ) + 0.5 );
			float lerpResult724_g83 = lerp( ifLocalVar431_g83 , FixedShadow627_g83 , _Unlit);
			float temp_output_351_0_g83 = ( ( ( ( _Shadow1Place + lerpResult724_g83 ) - 0.5 ) * _Shadow1Contrast ) + 0.5 );
			float4 temp_cast_17 = (temp_output_351_0_g83).xxxx;
			float4 temp_cast_19 = (temp_output_351_0_g83).xxxx;
			float div354_g83=256.0/float((int)255.0);
			float4 posterize354_g83 = ( floor( temp_cast_19 * div354_g83 ) / div354_g83 );
			float4 lerpResult720_g83 = lerp( temp_cast_17 , posterize354_g83 , _PosterizeToggle);
			float4 temp_cast_20 = (0.0).xxxx;
			float4 temp_cast_21 = (1.0).xxxx;
			float4 clampResult364_g83 = clamp( lerpResult720_g83 , temp_cast_20 , temp_cast_21 );
			float4 lerpResult366_g83 = lerp( _Shadow1Color , float4( 1,1,1,0 ) , clampResult364_g83);
			float lerpResult732_g83 = lerp( _Shadow1Contrast , _Shadow2Contrast , _Shadow2ContrastToggle);
			float temp_output_353_0_g83 = ( ( ( ( _Shadow2Place + lerpResult724_g83 ) - 0.5 ) * lerpResult732_g83 ) + 0.5 );
			float4 temp_cast_22 = (temp_output_353_0_g83).xxxx;
			float4 temp_cast_24 = (temp_output_353_0_g83).xxxx;
			float div356_g83=256.0/float((int)255.0);
			float4 posterize356_g83 = ( floor( temp_cast_24 * div356_g83 ) / div356_g83 );
			float4 lerpResult721_g83 = lerp( temp_cast_22 , posterize356_g83 , _PosterizeToggle);
			float4 temp_cast_25 = (0.0).xxxx;
			float4 temp_cast_26 = (1.0).xxxx;
			float4 clampResult363_g83 = clamp( lerpResult721_g83 , temp_cast_25 , temp_cast_26 );
			float4 lerpResult368_g83 = lerp( lerpResult733_g83 , lerpResult366_g83 , clampResult363_g83);
			float2 uv_ShadowMask369_g83 = i.uv_texcoord;
			float4 lerpResult372_g83 = lerp( float4( 1,1,1,1 ) , lerpResult368_g83 , tex2D( _ShadowMask, uv_ShadowMask369_g83 ));
			float4 lerpResult735_g83 = lerp( temp_cast_13 , lerpResult372_g83 , _HalfLambertToggle);
			float4 Shadow375_g83 = lerpResult735_g83;
			float4 EmissiveScrollMask508_g83 = tex2DNode466_g83;
			float4 lerpResult715_g83 = lerp( float4( 0,0,0,0 ) , EmissiveScrollMask508_g83 , _ForceEmissiveToggle);
			float4 lerpResult451_g83 = lerp( saturate( ( ( RimLight233_g83 + Matcap260_g83 + Reflection280_g83 ) * MatcapShadow261_g83 * Lighting201_g83 * Shadow375_g83 ) ) , float4( 0,0,0,0 ) , lerpResult715_g83);
			c.rgb = lerpResult451_g83.rgb;
			c.a = 1;
			clip( Opacity674_g83 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_ScanLineTex526_g83 = i.uv_texcoord;
			float3 ase_worldPos = i.worldPos;
			float3 worldToObj529_g83 = mul( unity_WorldToObject, float4( ase_worldPos, 1 ) ).xyz;
			float4 lerpResult513_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _ScanLineTex, uv_ScanLineTex526_g83 ) ,  ( ( worldToObj529_g83.y + _ScanLinePosition ) - (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) > ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) ? 0.0 : ( worldToObj529_g83.y + _ScanLinePosition ) - (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) <= ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) && ( worldToObj529_g83.y + _ScanLinePosition ) + (0.0 + (_ScanLineWidth - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) >= ( (0.0 + (frac( ( ( _Time.y / 3.0 ) * _ScanLineSpeed ) ) - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 1.0 ) ? 1.0 : 0.0 ) );
			float mulTime583_g83 = _Time.y * _Color2ChangeSpeed;
			float4 lerpResult578_g83 = lerp( _ScanLineColor , _ScanLineColor2 , sin( mulTime583_g83 ));
			float4 lerpResult704_g83 = lerp( _ScanLineColor , lerpResult578_g83 , _ScanLineColor2Toggle);
			float4 lerpResult702_g83 = lerp( float4( 0,0,0,0 ) , ( lerpResult513_g83 * lerpResult704_g83 ) , _ScanLineToggle);
			float4 ScanLineEmission534_g83 = lerpResult702_g83;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv_TexCoord485_g83 = i.uv_texcoord * _EmissiveScrollTiling + ( _Time.x * _EmissiveScrollSpeed );
			float2 uv_EmissiveScrollMask466_g83 = i.uv_texcoord;
			float4 tex2DNode466_g83 = tex2D( _EmissiveScrollMask, uv_EmissiveScrollMask466_g83 );
			float4 lerpResult468_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _EmissiveScrollTex, uv_TexCoord485_g83 ) , tex2DNode466_g83);
			float2 ScrollDir469_g83 = _EmissiveScrollSpeed;
			float dotResult461_g83 = dot( i.uv_texcoord , ScrollDir469_g83 );
			float4 lerpResult504_g83 = lerp( float4( 0,0,0,0 ) , ( _EmissiveScrollColor * ( 1.0 - saturate( ( ( ( ( ( cos( ( UNITY_PI * ( ( dotResult461_g83 + _Time.y ) * ScrollDir469_g83 ) ) ).x + 0.0 ) + _EmissiveScrollStrength ) - 0.5 ) * _EmissiveScrollContrast ) + 0.5 ) ) ) ) , tex2DNode466_g83);
			float4 lerpResult700_g83 = lerp( ( lerpResult468_g83 * _EmissiveScrollColor ) , lerpResult504_g83 , _EmissiveScrollGradient);
			float4 EmissiveScroll507_g83 = saturate( lerpResult700_g83 );
			float4 lerpResult706_g83 = lerp( float4( 0,0,0,0 ) , EmissiveScroll507_g83 , _EmissiveScrollToggle);
			float2 uv_TexCoord574_g83 = i.uv_texcoord * _ParallaxTiling;
			float2 Offset573_g83 = ( ( _ParallaxHight - 1 ) * i.viewDir.xy * _ParallaxScale ) + uv_TexCoord574_g83;
			float2 uv_ParallaxMask = i.uv_texcoord * _ParallaxMask_ST.xy + _ParallaxMask_ST.zw;
			float4 lerpResult588_g83 = lerp( float4( 0,0,0,0 ) , tex2D( _ParallaxEmission, Offset573_g83 ) , tex2D( _ParallaxMask, uv_ParallaxMask ));
			float4 temp_output_452_0_g83 = ( ScanLineEmission534_g83 + ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ) + lerpResult706_g83 + lerpResult588_g83 );
			o.Emission = temp_output_452_0_g83.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			Stencil
			{
				Ref [_StencilReference]
				Comp NotEqual
				Pass Keep
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "RSInspector"
}
/*ASEBEGIN
Version=17000
1927;18;1906;1014;835.7276;416.8727;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;225;415.1616,-347.5059;Float;False;727.0001;345;Stencil;7;220;219;218;224;221;222;223;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;46;69.28168,-267.6262;Float;False;266.991;191.938;Properties;1;48;Miscellaneous;0.5514706,0.5514706,0.5514706,1;0;0
Node;AmplifyShaderEditor.FunctionNode;237;-617.6109,124.1579;Float;False;Reflex Shader Function;0;;83;f5d8f584674c8984ab029c8868eb5bf3;0;0;6;COLOR;186;FLOAT;265;COLOR;0;COLOR;402;FLOAT;403;COLOR;404
Node;AmplifyShaderEditor.RangedFloatNode;48;107.2817,-195.6262;Float;False;Property;_CullMode;Cull Mode;79;0;Create;True;0;0;True;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;673.1616,-297.5059;Float;False;Property;_StencilComparison;Stencil Comparison;84;0;Create;True;0;0;False;0;255;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;219;469.1616,-203.5059;Float;False;Property;_StencilReadMask;Stencil Read Mask;82;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;220;469.1616,-119.5059;Float;False;Property;_StencilWriteMask;Stencil Write Mask;83;0;Create;True;0;0;False;0;255;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;685.1616,-117.5059;Float;False;Property;_StencilFailFront;Stencil Fail Front;86;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;895.1616,-295.5059;Float;False;Property;_StencilZFailFront;Stencil Z Fail Front;87;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;222;681.1616,-209.5059;Float;False;Property;_StencilPassFront;Stencil Pass Front;85;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;218;465.1616,-293.5059;Float;False;Property;_StencilReference;Stencil Reference;80;0;Create;True;0;0;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;31;-214.9875,303.7681;Float;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;150,-18;Float;False;True;2;Float;RSInspector;0;0;CustomLighting;Reflex Shader 2/Stencil/Reader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;1;False;TransparentCutout;;AlphaTest;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;True;2;True;218;255;False;219;255;False;220;6;False;221;1;False;222;0;False;223;0;False;224;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;81;-1;-1;-1;0;False;0;0;False;48;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;237;402
WireConnection;31;1;237;404
WireConnection;0;2;237;186
WireConnection;0;10;237;265
WireConnection;0;13;237;0
WireConnection;0;11;31;0
ASEEND*/
//CHKSM=16B1026812497E56052FAD1133C4173B33E99FE5