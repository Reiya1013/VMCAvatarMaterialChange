//--------------------------------------------------------------
//              Login Shader Vertex
//                      Copyright (c) 2022 Reiya1013
//--------------------------------------------------------------


//----vrtxテレポート
float VrtxTelepo(VIN v,inout VOUT o)
{
	if (_TeleportEnable & _DisolveEnable)
	{
		float3 n = o.worldNormal;
		//float on = ((0.5 - _DisolveThreshold) * 2) - ((1 + o.worldNormal.y) * 0.5);//_DisplayUpPosition;
		//float on = _DisolveThreshold - o.vertex.y;//_DisplayUpPosition;
		//return o.pos.y - ((1 + n.y) * (_DisolveThreshold * 10));

		if (o.vertex.y * 0.5 + 0.5 > _DisolveThreshold)
		{
			o.offsetY = ((1 + n.y) * (_DisolveThreshold * 10));
		}
	}

	return o.pos.y - o.offsetY;
}

VOUT vert (VIN v) {

	VOUT o;

//-------------------------------------頂点座標変換
	o.pos     = UnityObjectToClipPos(v.vertex);
	o.vertex  = v.vertex;

//-------------------------------------ワールド座標
	float3 PosW = mul(unity_ObjectToWorld, v.vertex).xyz;
	o.posWorld = PosW;

//-------------------------------------UV
	o.uv = TRANSFORM_TEX(v.uv , _MainTex);


//-------------------------------------Normal
	o.worldNormal = UnityObjectToWorldNormal(v.normal);

//----テレポート
	o.pos.y = VrtxTelepo(v,o);

//-------------------------------------フォグ
	UNITY_TRANSFER_FOG(o,o.pos);

	return o;
}

