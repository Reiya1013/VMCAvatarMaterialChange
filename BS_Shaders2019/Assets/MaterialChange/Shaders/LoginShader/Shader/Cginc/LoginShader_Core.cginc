//--------------------------------------------------------------
//              Sunao Shader Core
//                      Copyright (c) 2021 揚茄子研究所
//--------------------------------------------------------------


//-------------------------------------Include

	#include "UnityCG.cginc"
	#include "AutoLight.cginc"
	#include "Lighting.cginc"

//-------------------------------------変数宣言

//----Main
	UNITY_DECLARE_TEX2D(_MainTex);
	uniform float4    _MainTex_ST;
	uniform float4    _Color;

//----ジオメトリシェーダー用
	uniform bool      _EnableGeometry;
	uniform float     _Destruction;
	uniform float     _ScaleFactor;
	uniform float     _RotationFactor;
	uniform float     _PositionFactor;
	uniform float     _PositionAdd;


	//----Teleport
	uniform bool      _TeleportEnable;

	//----Disolve
	uniform bool      _DisolveEnable;
	uniform sampler2D _DisolveTex;
	uniform float4    _DisolveEmissionColor;
	uniform float     _DisolveEmission;
	uniform float     _DisolveThreshold;
	uniform float     _DisplayUpPosition;


//-------------------------------------頂点シェーダ入力構造体

struct VIN {
	float4 vertex  : POSITION;
	float2 uv      : TEXCOORD;
	float3 normal  : NORMAL;
};

//-------------------------------------頂点シェーダ出力構造体

struct VOUT {

	float4 pos     : SV_POSITION;
	float4 vertex  : VERTEX;
	float2 uv      : TEXCOORD0;
	float3 posWorld: TEXCOORD1;
	float3 worldNormal: TEXCOORD2;
	float  offsetY : TEXCOORD3;
	UNITY_FOG_COORDS(17)

};


struct VOUT_geo {

	float4 pos     : SV_POSITION;
	float4 vertex  : VERTEX;
	float2 uv      : TEXCOORD0;
	float3 posWorld: TEXCOORD1;
	float3 worldNormal: TEXCOORD2;
	float  offsetY : TEXCOORD3;

	UNITY_FOG_COORDS(17)

};


//-------------------------------------ジオメトリシェーダー

	#include "LoginShader_Geom.cginc"

//-------------------------------------頂点シェーダ

	#include "LoginShader_Vert.cginc"


//-------------------------------------フラグメントシェーダ

	#include "LoginShader_Frag.cginc"
