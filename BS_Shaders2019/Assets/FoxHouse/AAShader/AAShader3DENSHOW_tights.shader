//AAS 3.0DENSHOW



Shader "Toon/AAShader3DENSHOW_tights" {
	Properties{
		_MainTex("AlbedoTextuer (RGB)", 2D) = "white" {} //テクスチャ
		[NoScaleOffset] _MaterialTex("MaterialTextuer (RGB)", 2D) = "gray" {} //質感テクスチャ
		_SpecularSharp("HirightSharp",Range(1,500)) = 200
		_LineColor("LineColor",Color) = (0,0,0,1) // アウトラインの色
		_LineWidth("LineWidth", Range(0,10)) = 1 // アウトラインの幅
		_LineModurate("LineModurate", Range(0,1)) = 0 // アウトラインの強弱
		[NoScaleOffset]_TightsTex("TightsTextuer (RGB)", 2D) = "white" {} //透け側のテクスチャ 
		_TSharp("TSharp",Range(0.5,40)) = 1 //透け加減のシャープさ
		_BackLightCorrection("BackLightCorrection",Range(0,1.0)) = 0.66//ライトの補正値
		_ShadowSaturationCorrection("ShadowSaturationCorrection",Range(0,1.0)) = 0.8//影の彩度補正
		_EmissionPower("EmissionPower",Range(1,50)) = 2//エミッション強度
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
				Cull Front

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag 
				#include "UnityCG.cginc" 


			//アウトライン処理はAASD_Outline.cgincへ
			#include "AASD3_Outline.cginc"
			ENDCG
			}

			Pass //2パス目　ここでメインの光源でピクセルを書く
			{
				Name "FORWARD"
				Tags{ "LightMode" = "ForwardBase" } //フォワードベース
				Cull Back //表面のみ描写する

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase


				#include "UnityCG.cginc"
				#include "AutoLight.cginc"

				#define _AAS_TIGHTS
				#define _AAS_FWDBASE
				//FOWARDBASE処理はAASD_Forward.cgincへ
				#include "AASD3_Forward.cginc"
				ENDCG
			}
			Pass //3パス目　2つ目以降のライトは環境光として扱う　めんどくちぃので雑に計算
			{
				Name "FORWARD_DELTA"
				Tags{ "LightMode" = "ForwardAdd" }
				Cull Back
				Blend One One //超重要　これを指定しとかないと最後に描写されるライトのみになっちまう
				ZWrite Off //もう一遍描写してあるのでゼットバッファは書き出さない

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdadd


				#include "UnityCG.cginc"
				#include "AutoLight.cginc"

				#define _AAS_TIGHTS
				#define _AAS_FWDADD
				//FOWARDBASE処理はAASD_Forward.cgincへ
				#include "AASD3_Forward.cginc"
				ENDCG
			}
			Pass//シャドゥマップの処理　ほぼ丸投げ
			{
				Name "ShadowCaster"
				Tags{ "LightMode" = "ShadowCaster" }

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
			FallBack "Diffuse"
}
