//AASD_Outline.cginc
//AAShader3DENSHOW 3.1
		//新　色トレスの導入
struct appdata
{
    float4 pos : POSITION;
	float3 normal : NORMAL; //法線ベクトル
	float2 uv : TEXCOORD0;
	half4 color : COLOR; //頂点カラーを得る
};

struct v2f
{
	float2 uv : TEXCOORD0;
	float4 pos : SV_POSITION;
	half colordepth : TEXCOORD1;
};
half4 _LightColor0;//どこからともなくライトの光を得るおまじない

sampler2D _MainTex;
float4 _MainTex_ST;
float _LineWidth; //インスペクタからアウトラインの太さを取得する
half4 _LineColor; //インスペクタからアウトラインの色を取得する
half _LineModurate;

v2f vert(appdata v)
{
    v2f o;

	half3 normal = UnityObjectToWorldNormal(v.normal);
	v.pos += float4(normalize(v.normal) * 0.001f * _LineWidth * v.color.r , 0); //ポリゴンの頂点を法線方向に若干ずらす。これによってはみ出る部分がアウトラインになる　頂点カラーから色成分を取り出し線の太さの調整を行う
	o.pos = UnityObjectToClipPos(v.pos);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

	half3 WorldlightDirection = WorldSpaceLightDir(v.pos);
	half3 LightColor = saturate(ShadeSH9(half4(normal, 1.0)) + _LightColor0* saturate(dot(normal, WorldlightDirection)*2));//環境光を得る
	o.colordepth = saturate(v.color.r*2 - 1) * max(LightColor.r,max(LightColor.g, LightColor.b));
    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    fixed4 col = tex2D(_MainTex, i.uv) * _LineColor * i.colordepth;
	col.a = 1;

return col;
} 

/*		//旧
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
	half3 WorldlightDirection = WorldSpaceLightDir(v.pos);
	half3 normal = UnityObjectToWorldNormal(v.normal);
	half NtoL = saturate(dot(normal, WorldlightDirection)) * _LineModurate;
	v.pos += float4(normalize(v.normal) * 0.001f * _LineWidth * v.color.r * (1 - NtoL), 0); //ポリゴンの頂点を法線方向に若干ずらす。これによってはみ出る部分がアウトラインになる　頂点カラーから色成分を取り出し線の太さの調整を行う
	o.pos = UnityObjectToClipPos(v.pos); //さらっと書いてるけど上のインクルードファイルにあるこいつでオブジェクト座標をスクリーン座標に変換してくれている　すげえ！めどくない！
	return o;
}

half4 frag(v2f i) : SV_Target //フラグメント（ピクセル）シェーダ
{
	return _LineColor; //アウトラインの色をダイレクトに出力
}
*/