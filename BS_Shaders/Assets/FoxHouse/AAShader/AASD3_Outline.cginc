//AASD_Outline.cginc
//AAShader3DENSHOW 3.0

struct appdata //頂点シェーダが受け取る構造体
{
	float4 pos : POSITION; //頂点座標
	float3 normal : NORMAL; //法線ベクトル
	half4 color : COLOR; //頂点カラーを得る
};
struct v2f
{
	float4 pos : SV_POSITION;//頂点座標
};

float _LineWidth; //インスペクタからアウトラインの太さを取得する
half4 _LineColor; //インスペクタからアウトラインの色を取得する
half _LineModurate;

v2f vert(appdata v) //頂点シェーダ
{
	v2f o; //出力用

	//おぬーのコード　スクリーン座標に対して横にのみずらすようにしてある
	float3 N = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
	float2 outline = TransformViewToProjection(N.xy);

	o.pos = UnityObjectToClipPos(v.pos);
	//線にメリハリをつけてみるやつ
	half3 WorldlightDirection = WorldSpaceLightDir(v.pos);
	half3 normal = UnityObjectToWorldNormal(v.normal);
	half NtoL = saturate(dot(normal,WorldlightDirection)) * _LineModurate;

	o.pos.xy = o.pos.xy + outline * 0.001f * _LineWidth * v.color.r * (1 - NtoL);
	return o;
}

half4 frag(v2f i) : SV_Target //フラグメント（ピクセル）シェーダ
{
	return _LineColor; //アウトラインの色をダイレクトに出力
}