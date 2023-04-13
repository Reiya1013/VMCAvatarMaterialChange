//AAShader4 From the New World
Shader "BeatSaber/AAShader4/SEISO_SHADOW"
{
    Properties
	{

	}

	SubShader
	{
    Tags {
		"RenderType" = "Opaque"
		"Queue" = "Geometry"
		"DisableBatching" = "True"
	}
	LOD 100

	Pass
	{
		Stencil {
			Ref 1
			Comp always
			Pass replace
		}
		Name "OUTLINE"
		Tags{ "LightMode" = "ForwardBase" }
		Cull BACK
		ColorMask 0     // ステンシルのみ書き込み
		ZTest Always    // 深度に左右されずに書き込む
		ZWrite Off      // デプスバッファに書き込まない
		Blend Zero One

		CGPROGRAM
		#pragma target 4.5
		#pragma require geometry
		#pragma vertex vert
		#pragma fragment frag 
		#pragma multi_compile_fwdbase
		#pragma multi_compile_instancing

		#include "UnityCG.cginc" 

		struct appdata
		{
			float4 pos : POSITION;
			UNITY_VERTEX_INPUT_INSTANCE_ID //挿入
		};
		struct v2f
			{
			float4 pos : SV_POSITION;
			UNITY_VERTEX_INPUT_INSTANCE_ID //挿入
			UNITY_VERTEX_OUTPUT_STEREO //挿入
		};


		v2f vert(appdata v)
		{
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v); //挿入
			UNITY_INITIALIZE_OUTPUT(v2f, o); //挿入
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o); //挿入
			UNITY_TRANSFER_INSTANCE_ID(v, o);

			o.pos = UnityObjectToClipPos(v.pos);
			return o;
		}


		fixed4 frag(v2f i) : SV_Target
		{

				return half4 (0,0,0,0);
		}

		ENDCG
		}
    }
}
