//--------------------------------------------------------------
//              Sunao Shader Fragment
//                      Copyright (c) 2021 揚茄子研究所
//--------------------------------------------------------------


//----ディゾルブ
float3 Disolve(fixed4 rgba, VOUT IN, float2 MainUV) {
	float3 DisolveEmission = (float3)0.0f;
	if (_DisolveEnable) {
		fixed4 m = rgba;
		half g = m.r * 0.2 + m.g * 0.7 + m.b * 0.1;
		if (g < _DisolveThreshold) {
			clip(-1);
		}

		//----ディゾルブエミッション
		DisolveEmission = _DisolveEmission * _DisolveEmissionColor.rgb;


		//----テレポート	
		if (_TeleportEnable && _DisolveThreshold != 0)
		{
			//float on = ((1 + IN.worldNormal.y) * 0.5) -(1 - _DisolveThreshold) ;//_DisplayUpPosition;
			//float on = (1 - _DisolveThreshold) - ((1 + IN.worldNormal.y) * 0.5);//_DisplayUpPosition;
			//float on = ((1 - _DisolveThreshold)) - ((1+ IN.vertex.y) * 0.75);//_DisplayUpPosition;
			float on = ((1 + IN.uv.y) * (_DisolveThreshold * 10));;
			if (IN.offsetY > 0)
			{
				float dt = (_DisolveThreshold + 1) / 2;
				rgba.a = clamp(rand(MainUV) - dt, 0, 1);
				//clip(rgba.a - _DisolveThreshold );
				//if (rgba.a <= (_DisolveThreshold * (0.01 / _DisolveThreshold)) && _DisolveThreshold != 0)
				//{
				//	clip(-1);
				//}
			}
		}
	}
	return DisolveEmission;
}

//----ディゾルブ混合
float3 DisolveAdd(float3 ds) {
	return _DisolveEnable * ds;
}

float4 frag (VOUT IN) : COLOR {
//----ワールド座標
	float3 WorldPos     = mul(unity_ObjectToWorld , IN.vertex).xyz;

//----カメラ視点方向
	float3 View         = normalize(_WorldSpaceCameraPos - WorldPos);

//-------------------------------------メインカラー
	float4 OUT          = float4(0.0f , 0.0f , 0.0f , 1.0f);

	float2 MainUV       = IN.uv;

	float3 Color        = UNITY_SAMPLE_TEX2D(_MainTex, MainUV).rgb;
	       Color        = Color * _Color.rgb;

//----ディゾルブ
	float3 DisolveEmission     =Disolve(tex2D (_DisolveTex, MainUV),IN,MainUV);

//-------------------------------------最終カラー計算
	OUT.rgb      = Color;

//----ディゾルブ混合
	OUT.rgb += DisolveAdd(DisolveEmission);

//-------------------------------------フォグ
	UNITY_APPLY_FOG(IN.fogCoord, OUT);


	return OUT;
}

