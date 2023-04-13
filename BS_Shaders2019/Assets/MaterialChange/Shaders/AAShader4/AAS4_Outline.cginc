//AAS4_Outline.cginc
//アウトライン
struct appdata
{
	float4 pos : POSITION;
	float3 normal : NORMAL; //法線ベクトル
	float2 uv : TEXCOORD0;
	half4 color : COLOR; //頂点カラーを得る
	UNITY_VERTEX_INPUT_INSTANCE_ID //挿入
};
struct v2f
{
	float2 uv : TEXCOORD0;
	float4 pos : SV_POSITION;
	float4 lpos : TEXCOORD2;
	half3 lightcolor : TEXCOORD1;
	UNITY_VERTEX_INPUT_INSTANCE_ID //挿入
	UNITY_VERTEX_OUTPUT_STEREO //挿入

};

half4 _LightColor0;//どこからともなくライトの光を得るおまじない

sampler2D _MainTex;
float4 _MainTex_ST;
float _LineWidth; //インスペクタからアウトラインの太さを取得する
half4 _LineColor; //インスペクタからアウトラインの色を取得する
sampler2D _Line_MaskTex;


v2f vert(appdata v)
{
	v2f o;
	UNITY_SETUP_INSTANCE_ID(v); //挿入
	UNITY_INITIALIZE_OUTPUT(v2f, o); //挿入
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o); //挿入
	UNITY_TRANSFER_INSTANCE_ID(v, o);
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);


	float3 wpos = mul(unity_ObjectToWorld, float4(v.pos.xyz, 1)).xyz;

	float3 CameraVecter = _WorldSpaceCameraPos - wpos; // カメラからの方向
	float width = _LineWidth * v.color.r * tex2Dlod(_Line_MaskTex, float4(o.uv, 0, 0).r);
	half3 normal = UnityObjectToWorldNormal(normalize(v.normal));


	float4 oPos = float4(wpos + normalize(normal) * width * 0.001, 0);//とりあえずずらす

	if (unity_OrthoParams.w < 0.5) {			//平衡投影でない
		o.pos = UnityWorldToClipPos(oPos - normalize(CameraVecter) * width * 0.1);
	}
	else {										// カメラが orthographic のときはシフト後の z のみ採用する
		o.pos = UnityWorldToClipPos(oPos);
		o.pos.z = UnityWorldToClipPos(oPos - normalize(CameraVecter) * width * 0.1).z;
	}

	o.lpos = UnityWorldToClipPos(wpos);


	float3 V = normalize(WorldSpaceViewDir(v.pos)); //視線のベクトルを取得する
	half3 WorldlightDirection = normalize(WorldSpaceLightDir(v.pos));

	half BL = saturate(dot(V, WorldlightDirection) * 5);//逆光時に明るくならない処置

	half NtoL = saturate(dot(normal, WorldlightDirection));

	half3 LightColor = saturate(ShadeSH9(half4(V, 1.0)) * (0.5 + NtoL * 0.5) + _LightColor0 * saturate(NtoL * 100 * BL));

	o.lightcolor = LightColor * v.color.g;
	return o;
}

[maxvertexcount(18)]
void Geometry(triangle v2f i[3], inout TriangleStream<v2f> outStream)
{
	UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i[0]);
	v2f o;

	/*
	float3x3 m = { i[0].pos.xyw, i[1].pos.xyw, i[2].pos.xyw };
	float d = determinant(m) * (1.0 - 2.0 * (unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f));//元の面に合わせたカリング
	if (UNITY_MATRIX_P[2][2] <= 0) d = d * -1;//ミラー内で反転
	if (-d <= 0.0) return;
	*/


	o = i[0]; o.pos = o.lpos;		outStream.Append(o);
	o = i[1]; o.pos = o.lpos;		outStream.Append(o);
	o = i[2]; o.pos = o.lpos;		outStream.Append(o);
	outStream.RestartStrip();


	o = i[0];			outStream.Append(o);
	o.pos = o.lpos;		outStream.Append(o);
	o = i[1];			outStream.Append(o);
	o.pos = o.lpos;		outStream.Append(o);
	o = i[2];			outStream.Append(o);
	o.pos = o.lpos;		outStream.Append(o);
	o = i[0];			outStream.Append(o);
	o.pos = o.lpos;		outStream.Append(o);

	//o.pos	= i[0].pos;		outStream.Append(o);
	o = i[2];			outStream.Append(o);
	o.pos = o.lpos;		outStream.Append(o);
	o = i[1];			outStream.Append(o);
	o.pos = o.lpos;			outStream.Append(o);
	o = i[0];			outStream.Append(o);
	o.pos = o.lpos;		outStream.Append(o);


	outStream.RestartStrip();


}
fixed4 frag(v2f i) : SV_Target
{
	half4 col = tex2D(_MainTex, i.uv) * _LineColor * half4(i.lightcolor,1);
#ifdef IS_BEATSABER
	col.a = 0;
#else
	col.a = 1;
#endif 

	return col;
}
