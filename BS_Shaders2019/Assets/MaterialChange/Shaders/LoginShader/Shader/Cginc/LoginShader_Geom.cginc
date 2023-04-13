
//----ランダム関数
float rand(float2 co)
{
	return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
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
void geom(triangle VOUT input[3], inout TriangleStream<VOUT> stream)
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
		float3 up = float3(0, _PositionAdd*2, 0);

		[unroll]
		for (int i = 0; i < 3; i++)
		{

			VOUT v = input[i];
			VOUT o = v;

			// 以下では、各要素（位置、回転、スケール）に対して係数に応じて変化を与えます。
			// center位置を起点にスケールを変化させます。
			v.vertex.xyz = (v.vertex.xyz - center) * (1.0 - destruction * _ScaleFactor) + center + (up * destruction);

			// center位置を起点に、乱数を用いて回転を変化させます。
			v.vertex.xyz = rotate(v.vertex.xyz, r3 * destruction * _RotationFactor);

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
		for (int i = 0; i < 3; i++)
		{
			stream.Append(input[i]);
		}

		stream.RestartStrip();
	}
}