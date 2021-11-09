//--------------------------------------------------------------
//              Sunao Shader ShadowCaster
//                      Copyright (c) 2021 揚茄子研究所
//--------------------------------------------------------------


//-------------------------------------Include

	#include "UnityCG.cginc"
	#include "SunaoShader_Function.cginc"

//-------------------------------------変数宣言

	uniform sampler2D _MainTex;
	uniform float4    _MainTex_ST;
	uniform float4    _Color;
	uniform float     _Cutout;
	uniform float     _Alpha;
	uniform sampler2D _AlphaMask;
	uniform float     _AlphaMaskStrength;
	uniform float     _UVScrollX;
	uniform float     _UVScrollY;
	uniform float     _UVAnimation;
	uniform uint      _UVAnimX;
	uniform uint      _UVAnimY;
	uniform bool      _UVAnimOtherTex;

//-------------------------------------頂点シェーダ入力構造体

struct VIN {
	float4 vertex  : POSITION;
	float2 uv      : TEXCOORD0;
};

//-------------------------------------頂点シェーダ出力構造体

struct VOUT {
	float2 uv      : TEXCOORD0;
	float4 uvanm   : TEXCOORD1;

	V2F_SHADOW_CASTER;
};

//-------------------------------------頂点シェーダ

VOUT vert (VIN v) {

	VOUT o;

//-------------------------------------頂点座標変換
	o.pos = UnityObjectToClipPos(v.vertex);

//-------------------------------------UV
	o.uv      = (v.uv * _MainTex_ST.xy) + _MainTex_ST.zw;

//-------------------------------------UVアニメーション
	o.uvanm   = float4(0.0f , 0.0f , 1.0f , 1.0f);

	if (_UVAnimation > 0.0f) {
		o.uvanm.zw  = 1.0f / float2(_UVAnimX , _UVAnimY);

		float2 UVAnimSpeed    = _UVAnimation * _UVAnimY;
		       UVAnimSpeed.y *= -o.uvanm.w;

		o.uvanm.xy += floor(frac(UVAnimSpeed * _Time.y) * float2(_UVAnimX , _UVAnimY));
	}

	TRANSFER_SHADOW_CASTER(o)

	return o;
}

//-------------------------------------フラグメントシェーダ

float4 frag (VOUT IN) : COLOR {

	float4 OUT          = (float4)1.0f;

	#if defined(TRANSPARENT) || defined(CUTOUT)
		float2 MainUV       = (IN.uv + IN.uvanm.xy) * IN.uvanm.zw;
		       MainUV      += float2(_UVScrollX , _UVScrollY) * _Time.y;
		float2 SubUV        = IN.uv;
		if (_UVAnimOtherTex) SubUV = MainUV;

	           OUT.a        = saturate(tex2D(_MainTex , MainUV).a * _Color.a * _Alpha);
	           OUT.a       *= lerp(1.0f , MonoColor(tex2D(_AlphaMask  , SubUV).rgb) , _AlphaMaskStrength);
	#endif

	#ifdef TRANSPARENT
		clip(OUT.a - 0.3);
	#endif

	#ifdef CUTOUT
		clip(OUT.a - _Cutout);
	#endif

	SHADOW_CASTER_FRAGMENT(IN)
	
	return OUT;
}
