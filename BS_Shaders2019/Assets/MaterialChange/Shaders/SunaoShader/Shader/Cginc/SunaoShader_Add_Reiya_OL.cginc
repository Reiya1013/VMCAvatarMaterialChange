//----Gameing
	uniform bool      _GameingEnable;
	uniform float     _GameingSpeed;

//----Teleport
	uniform bool      _TeleportEnable;

//----Disolve
	uniform bool      _DisolveEnable;
	uniform sampler2D _DisolveTex;
	uniform sampler2D _DisolveEmissionMap;
	uniform float4    _DisolveEmissionColor;
	uniform float     _DisolveEmission;
	uniform float     _DisolveThreshold;
	uniform sampler2D _DisolveTimeTex;
	uniform float     _DisolveStartTime;
	uniform float     _DisolveEndTime;
	

//----Hidden
	uniform uint      _Hidden;
	UNITY_DECLARE_TEX2D(_HiddenMainTex);
	uniform sampler2D _HiddenEmissionMap;
	uniform sampler2D _HiddenEmissionMap2;
	int HiddenTexMode;
    uniform float	  _HiddenDistance;
	
//----HiddenTexMode
void HiddemMode()
{
	//-------------------------------------VRCカメラに映らないようにする(Reiya)
	HiddenTexMode = 0;
	if (_Hidden == 1 && _ScreenParams.x == 1280 && _ScreenParams.y == 720)
        clip(-1);
	else if (_Hidden == 4 && _ScreenParams.x != 1280 && _ScreenParams.y != 720)
        clip(-1);
	else if (_Hidden == 2 && _ScreenParams.x == 1280 && _ScreenParams.y == 720)
		HiddenTexMode = 1;
	else if (_Hidden == 3 && _ScreenParams.x != 1280 && _ScreenParams.y != 720)
		HiddenTexMode = 1;
}

void HiddenDistance(VOUT IN)
{
	// カメラとオブジェクトの距離(長さ)を取得
	float dist = length(_WorldSpaceCameraPos - IN.posWorld);
    if (dist <= _HiddenDistance)
        clip(-1);
}

//----SetMainTex
float4 MainTexSampleTex2D(float2 UV)
{
	if(HiddenTexMode == 1)
	{
		return UNITY_SAMPLE_TEX2D(_HiddenMainTex,UV);
	}
	else
	{
		return UNITY_SAMPLE_TEX2D(_MainTex,UV);
	}
}

float4 MainTexSampleTex2D(UNITY_DECLARE_TEX2D_NOSAMPLER(Map) ,float2 UV)
{
	if(HiddenTexMode == 1)
	{
		return UNITY_SAMPLE_TEX2D_SAMPLER(Map,_HiddenMainTex,UV);
	}
	else
	{
		return UNITY_SAMPLE_TEX2D_SAMPLER(Map,_MainTex,UV);
	}
}




//----ランダム関数
float rand(float2 co)
{
    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

//----ディゾルブ
void Disolve(VOUT IN){
	if(_DisolveEnable){
		fixed4 m = tex2D (_DisolveTex, IN.uv);
		half g = m.r * 0.2 + m.g * 0.7 + m.b * 0.1;
		if( g < _DisolveThreshold ){
			clip(-1);
		} 

		float4 dtime = tex2D(_DisolveTimeTex  , IN.uv);
		if (dtime.y <= 0.2f)
			clip(-1);
	}
}

//----ディゾルブ混合
float3 DisolveAdd(float3 ds){
	return _DisolveEnable * ds;
}

//----ゲーミングカラー追加
fixed3 Gameing(fixed3 OUT)
{
	OUT.x += _GameingEnable * clamp(OUT.x + (_SinTime.w ) ,0,1);
	OUT.y += _GameingEnable * clamp(OUT.y + (_SinTime.z ) ,0,1);
	OUT.z += _GameingEnable * clamp(OUT.z + (_SinTime.y ) ,0,1);

	return OUT;
}

//----vrtxテレポート
float VrtxTelepo(VIN v,VOUT o)
{	
	if (_TeleportEnable & _DisolveEnable)
	{
        float3 n = UnityObjectToWorldNormal(v.normal);

		n =  float4(n * _DisolveThreshold * 100, 0);

		if (n.y < 0)
		{
			n.y = 0;
		}

		return UnityObjectToClipPos (v.vertex).y - n.y;    
	}

	return o.pos.y;
}

//----frgmテレポート
void FrgmTelepo(VOUT IN)
{	
	if (_DisolveEnable & _TeleportEnable)
	{
		float dt = (_DisolveThreshold +1) / (1);
		if (clamp(rand(IN.uv) - dt ,0,1) <= _DisolveThreshold*_DisolveThreshold & _DisolveThreshold != 0)
		{
			clip(-1);
		}
	}
}

//----UVローテーション
fixed3 rotate(fixed3 p, fixed3 rotation)
{
    fixed3 a = normalize(rotation);
    fixed angle = length(rotation);
    if (abs(angle) < 0.001) return p;
    fixed s = sin(angle);
    fixed c = cos(angle);
    fixed r = 1.0 - c;
    fixed3x3 m = fixed3x3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
    return mul(m, p);
}


// ジオメトリシェーダー
[maxvertexcount(3)]
void geom (triangle VOUT input[3], inout TriangleStream<VOUT> stream)
{
	if (_EnableGeometry)
	{
		// ポリゴンの中心を計算。
		// ポリゴン単位で計算を行えるため、「ポリゴンの中心位置」も計算可能です。
		float3 center = (input[0].vertex + input[1].vertex + input[2].vertex) / 3;

		// ポリゴンの辺ベクトルを計算し、ポリゴンの法線を計算する。
		// 続いて、前のサンプルでもあった「ポリゴン法線」の計算です。
		float3 vec1 = input[1].vertex - input[0].vertex;
		float3 vec2 = input[2].vertex - input[0].vertex;
		float3 normal = normalize(cross(vec1, vec2));

		fixed destruction = _Destruction;

		// 省略していますが、独自で定義した「rand」関数を使って乱数を生成しています。
		// ここではポリゴン位置などをseedにして乱数を生成しています。
		fixed r = 2.0 * (rand(center.xy) - 0.5);
		fixed3 r3 = r.xxx;
		float3 up = float3(0, _PositionAdd, 0);

		[unroll]
		for(int i = 0; i < 3; i++)
		{

			VOUT v = input[i];
			VOUT o = v;

			// 以下では、各要素（位置、回転、スケール）に対して係数に応じて変化を与えます。

			// center位置を起点にスケールを変化させます。
			v.vertex.xyz = (v.vertex.xyz - center) * (1.0 - destruction * _ScaleFactor) + center + (up * destruction);

			// center位置を起点に、乱数を用いて回転を変化させます。
			v.vertex.xyz = rotate(v.vertex.xyz , r3 * destruction * _RotationFactor) ;

			// 法線方向に位置を変化させます
			v.vertex.xyz += normal * destruction * _PositionFactor * r3;

			// 最後に、修正した頂点位置を射影変換しレンダリング用に変換します。
			o.vertex = v.vertex;
			o.pos = UnityObjectToClipPos(o.vertex);


			stream.Append(o);
		}
		stream.RestartStrip();
	}
	else
	{

		[unroll]
		for(int i = 0; i < 3; i++)
		{
			stream.Append(input[i]);
		}

		stream.RestartStrip();
	}
}