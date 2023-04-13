//AAS 3.1seiso


Shader "BeatSaber/Toon/AAShader3DENSHOW_seiso" 
{
	Properties
	{
		_MainTex("AlbedoTextuer (RGB)", 2D) = "white" {} //テクスチャ
		[NoScaleOffset] _MaterialTex("MaterialTextuer (RGB)", 2D) = "gray" {} //質感テクスチャ
		_ShadowPos("ShadowPos",Range(-1,1)) = 0
		_SpecularSharp("HirightSharp",Range(1,500)) = 200
		_LineColor("LineColor",Color) = (0,0,0,1) // アウトラインの色
		_LineWidth("LineWidth", Range(0,10)) = 1 // アウトラインの幅
		_LineModurate("LineModurate", Range(0,1)) = 0 // アウトラインの強弱
		_BackLightCorrection("BackLightCorrection",Range(0,1.0)) = 0.66//ライトの補正値
		_BackLightCorrectionPos("BackLightCorrectionPos",Range(-1.0,1.0)) = 0.0//ライトの補正位置
		_DefaultLightDirection("DefaultLightDirection",Range(-1.0,1.0)) = 1//ディレクショナルライトがない場合に作るライトの傾き
		_ShadowSaturationCorrection("ShadowSaturationCorrection",Range(0,1.0)) = 0.8//影の彩度補正
		_EmissionPower("EmissionPower",Range(1,50)) = 2//エミッション強度
		_BackLightSeiso("BackLightSeiso", Range(0, 20)) = 5 //逆光時の清楚感
		_BackLightAddition("BackLightAddition", Range(0, 2)) = 0.5 //逆光時にリムライトに足すライトの度合い
		_NormalLightSeiso("NormalLightSeiso", Range(0, 20)) = 5//順光時の清楚感

	}
	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
		LOD 100
			 

		Pass
		{
			Name "FORWARD"
			Tags{ "LightMode" = "ForwardBase" } //フォワードベース
			Cull Back //表面のみ描写する
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"
			#define _AAS_SEISO
			#define _AAS_FWDBASE
			//FOWARDBASE処理はAASD_Forward.cgincへ
			#include "AASD3_Forward.cginc"
			ENDCG
		}
		Pass //2パス目　2つ目以降のライトの計算
		{
			Name "FORWARD_DELTA"
			Tags{ "LightMode" = "ForwardAdd" }
			Cull Back
			Blend One One //超重要　これを指定しとかないと最後に描写されるライトのみになっちまう
			ZWrite Off //もう一遍描写してあるのでゼットバッファは書き出さない
			ColorMask RGB
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd


			#include "UnityCG.cginc"
			#include "AutoLight.cginc"


			#define _AAS_FWDADD
			//FOWARDBASE処理はAASD_Forward.cgincへ
			#include "AASD3_Forward.cginc"
			ENDCG
		}
		Pass
		{
			Cull Front
			ColorMask RGB
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag 
			#include "UnityCG.cginc" 

			//アウトライン処理はAASD_Outline.cgincへ
			#include "AASD3_Outline.cginc"

			ENDCG
		}
		Pass//シャドゥマップの処理　ほぼ丸投げ
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ColorMask RGB
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			float _BiginShadow;

			struct v2f {
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)

			}
			ENDCG
		}

	}
 }
