//--------------------------------------------------------------
//              Sunao Shader Vertex
//                      Copyright (c) 2021 揚茄子研究所
//--------------------------------------------------------------


VOUT vert (VIN v) {

	VOUT o;

//-------------------------------------頂点座標変換
	o.pos     = UnityObjectToClipPos(v.vertex);
	float3 PosW = mul(unity_ObjectToWorld , v.vertex).xyz;

	o.vertex  = v.vertex;

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

//-------------------------------------法線
	o.normal  = v.normal;

//-------------------------------------頂点カラー
	o.color   = (float3)1.0f;
	if (_VertexColor) o.color = v.color;

//-------------------------------------デカール

	o.decal   = (float4)1.0f;
	o.decal2  = float4(_DecalSizeX , _DecalSizeY , _DecalSizeX * 0.5f , _DecalSizeY * 0.5f);
	o.decanm  = float4(0.0f , 0.0f , 1.0f , 1.0f);

	float2 DecalAnimRatio = (float2)1.0f;

	if (_DecalEnable) {

		if (_DecalAnimation > 0.0f) {
			o.decanm.zw  = 1.0f / float2(_DecalAnimX , _DecalAnimY);

			float2 DecalAnimSpeed    = _DecalAnimation * _DecalAnimY;
			       DecalAnimSpeed.y *= -o.decanm.w;

			o.decanm.xy   += floor(frac(DecalAnimSpeed * _Time.y) * float2(_DecalAnimX , _DecalAnimY));

			DecalAnimRatio = float2(_DecalAnimY / _DecalAnimX , _DecalAnimX / _DecalAnimY);
			DecalAnimRatio = max(DecalAnimRatio , 1.0f);
		}

		if (_DecalTex_TexelSize.z < _DecalTex_TexelSize.w) o.decal2.x *= _DecalTex_TexelSize.y * _DecalTex_TexelSize.z;
		if (_DecalTex_TexelSize.z > _DecalTex_TexelSize.w) o.decal2.y *= _DecalTex_TexelSize.x * _DecalTex_TexelSize.w;
		o.decal2.xy *= DecalAnimRatio;
		o.decal2.zw  = o.decal2.xy * 0.5f;

		o.decal.xy   = 1.0f / max(o.decal2.xy , 0.00001f);
		o.decal.z    = cos(0.017453293f * _DecalRotation);		//0.017453293 = π/180
		o.decal.w    = sin(0.017453293f * _DecalRotation);
	}

//-------------------------------------ライト方向
	o.ldir    = _WorldSpaceLightPos0.xyz;

	#ifdef PASS_FA
		o.ldir -= PosW;
	#endif

	o.ldir    = normalize(o.ldir);

//-------------------------------------SHライト
	#ifdef PASS_FB
		float3 SHColor[6];
		SHColor[0]   = ShadeSH9(float4(-1.0f ,  0.0f ,  0.0f , 1.0f));
		SHColor[1]   = ShadeSH9(float4( 1.0f ,  0.0f ,  0.0f , 1.0f));
		SHColor[2]   = ShadeSH9(float4( 0.0f , -1.0f ,  0.0f , 1.0f));
		SHColor[3]   = ShadeSH9(float4( 0.0f ,  1.0f ,  0.0f , 1.0f));
		SHColor[4]   = ShadeSH9(float4( 0.0f ,  0.0f , -1.0f , 1.0f));
		SHColor[5]   = ShadeSH9(float4( 0.0f ,  0.0f ,  1.0f , 1.0f));

		float SHLength[6];
		SHLength[0]  = MonoColor(SHColor[0]);
		SHLength[1]  = MonoColor(SHColor[1]);
		SHLength[2]  = MonoColor(SHColor[2]);
		SHLength[3]  = MonoColor(SHColor[3]) + 0.000001f;
		SHLength[4]  = MonoColor(SHColor[4]);
		SHLength[5]  = MonoColor(SHColor[5]);

		o.shdir      = SHLightDirection(SHLength);
		o.shmax      = SHLightMax(SHColor) * _SHLight;
		o.shmin      = SHLightMin(SHColor) * _SHLight;

		if (_MonochromeLit) {
			o.shmax  = MonoColor(o.shmax);
			o.shmin  = MonoColor(o.shmin);
		}

		o.shmax      = max(o.shmax , _MinimumLight        );
		o.shmin      = max(o.shmin , _MinimumLight * 0.75f);

	#endif

//-------------------------------------Vertexライト
	#ifdef PASS_FB
		#if defined(UNITY_SHOULD_SAMPLE_SH) && defined(VERTEXLIGHT_ON)

			o.vldirX  = unity_4LightPosX0 - PosW.x;
			o.vldirY  = unity_4LightPosY0 - PosW.y;
			o.vldirZ  = unity_4LightPosZ0 - PosW.z;

			float4 VLLength = VLightLength(o.vldirX , o.vldirY , o.vldirZ);
			o.vlcorr  = rsqrt(VLLength);
			o.vlatn   = VLightAtten(VLLength) * _PointLight;

		#else

			o.vldirX  = (float4)0.0f;
			o.vldirY  = (float4)0.0f;
			o.vldirZ  = (float4)0.0f;
			o.vlcorr  = (float4)0.0f;
			o.vlatn   = (float4)0.0f;

		#endif
	#endif

//-------------------------------------Toon
	o.toon    = Toon(_Toon , _ToonSharpness);

//-------------------------------------エミッションUV
	o.euv.xy   = MixingTransformTex(v.uv , _MainTex_ST , _EmissionMap_ST );
	o.euv.zw   = MixingTransformTex(v.uv , _MainTex_ST , _EmissionMap2_ST);

	float4 EmissionAnim = float4(0.0f , 0.0f , 1.0f , 1.0f);

	if (_EmissionAnimation > 0.0f) {
		EmissionAnim.zw  = 1.0f / float2(_EmissionAnimX , _EmissionAnimY);

		float2 EmissionAnimSpeed    = _EmissionAnimation * _EmissionAnimY;
		       EmissionAnimSpeed.y *= -EmissionAnim.w;

		EmissionAnim.xy += floor(frac(EmissionAnimSpeed * _Time.y) * float2(_EmissionAnimX , _EmissionAnimY));
	}

	o.euv.xy  = (o.euv.xy + EmissionAnim.xy) * EmissionAnim.zw;
	o.euv.xy += float2(_EmissionScrX , _EmissionScrY) * _Time.y;

	if (_UVAnimOtherTex) {
		o.euv.zw  = (o.euv.zw + o.uvanm.xy) * o.uvanm.zw;
		o.euv.zw += float2(_UVScrollX , _UVScrollY) * _Time.y;
	}

//-------------------------------------エミッション時間変化パラメータ
	o.eprm    = (float3)0.0f;
	if (_EmissionEnable) {
		o.eprm.x   = EmissionWave(_EmissionWaveform , _EmissionBlink , _EmissionFrequency , 0);
	}

//-------------------------------------視差エミッション
	TANGENT_SPACE_ROTATION;
	o.pview   = mul(rotation, ObjSpaceViewDir(v.vertex)).xzy;

//-------------------------------------視差エミッションUV
	o.peuv.xy = MixingTransformTex(v.uv , _MainTex_ST , _ParallaxMap_ST     );
	o.peuv.zw = MixingTransformTex(v.uv , _MainTex_ST , _ParallaxMap2_ST    );
	o.pduv    = MixingTransformTex(v.uv , _MainTex_ST , _ParallaxDepthMap_ST);

	float4 ParallaxAnim = float4(0.0f , 0.0f , 1.0f , 1.0f);

	if (_ParallaxAnimation > 0.0f) {
		ParallaxAnim.zw  = 1.0f / float2(_ParallaxAnimX , _ParallaxAnimY);

		float2 ParallaxAnimSpeed    = _ParallaxAnimation * _ParallaxAnimY;
		       ParallaxAnimSpeed.y *= -ParallaxAnim.w;

		ParallaxAnim.xy += floor(frac(ParallaxAnimSpeed * _Time.y) * float2(_ParallaxAnimX , _ParallaxAnimY));
	}

	o.peuv.xy  = (o.peuv.xy + ParallaxAnim.xy) * ParallaxAnim.zw;
	o.peuv.xy += float2(_ParallaxScrX , _ParallaxScrY) * _Time.y;


	if (_UVAnimOtherTex) {
		o.peuv.zw  = (o.peuv.zw + o.uvanm.xy) * o.uvanm.zw;
		o.peuv.zw += float2(_UVScrollX , _UVScrollY) * _Time.y;
		o.pduv     = (o.pduv    + o.uvanm.xy) * o.uvanm.zw;
		o.pduv    += float2(_UVScrollX , _UVScrollY) * _Time.y;
	}

//-------------------------------------視差エミッション時間変化パラメータ
	o.peprm   = (float3)0.0f;
	if (_ParallaxEnable) {
		o.peprm.x  = EmissionWave(_ParallaxWaveform , _ParallaxBlink , _ParallaxFrequency , _ParallaxPhaseOfs);
	}

//-------------------------------------タンジェント
	o.tangent = v.tangent;
	o.tanW    = UnityObjectToWorldDir(v.tangent.xyz);
	o.tanB    = cross(UnityObjectToWorldNormal(v.normal) , o.tanW) * v.tangent.w * unity_WorldTransformParams.w;

//-------------------------------------カメラ前方向
	o.vfront  = normalize(UNITY_MATRIX_V[1].xyz);

//-------------------------------------ポイントライト
	#ifdef PASS_FA
		TRANSFER_VERTEX_TO_FRAGMENT(o);
	#endif

//-------------------------------------フォグ
	UNITY_TRANSFER_FOG(o,o.pos);


	return o;
}
