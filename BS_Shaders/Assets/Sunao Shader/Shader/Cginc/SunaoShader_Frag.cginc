//--------------------------------------------------------------
//              Sunao Shader Fragment
//                      Copyright (c) 2021 揚茄子研究所
//--------------------------------------------------------------


float4 frag (VOUT IN) : COLOR {
//----ワールド座標
	float3 WorldPos     = mul(unity_ObjectToWorld , IN.vertex).xyz;

//----カメラ視点方向
	float3 View         = normalize(_WorldSpaceCameraPos - WorldPos);

//-------------------------------------メインカラー
	float4 OUT          = float4(0.0f , 0.0f , 0.0f , 1.0f);

	float2 MainUV       = (IN.uv + IN.uvanm.xy) * IN.uvanm.zw;
	       MainUV      += float2(_UVScrollX , _UVScrollY) * _Time.y;
	float2 SubUV        = IN.uv;
	if (_UVAnimOtherTex) SubUV = MainUV;

	#if defined(TRANSPARENT) || defined(CUTOUT)
	       OUT.a        = saturate(UNITY_SAMPLE_TEX2D(_MainTex , MainUV).a * _Color.a * _Alpha);
	       OUT.a       *= lerp(1.0f , MonoColor(UNITY_SAMPLE_TEX2D_SAMPLER(_AlphaMask  , _MainTex , SubUV).rgb) , _AlphaMaskStrength);
	#endif

	float3 Color        = UNITY_SAMPLE_TEX2D(_MainTex , MainUV).rgb;
	       Color        = Color * _Color.rgb * _Bright * IN.color;

//----デカール
	float4 DecalColor   = float4(0.0f , 0.0f , 0.0f , 1.0f);

	if (_DecalEnable) {

		float2   DecalUV       = (float2)0.0f;
		float2x2 DecalRot      = float2x2(IN.decal.z, -IN.decal.w, IN.decal.w, IN.decal.z);

		if  (_DecalMirror <  4) {
			DecalUV    = IN.uv   - float2(_DecalPosX , _DecalPosY) + IN.decal2.zw;
		} else {
			DecalUV.x  = 0.5f + (floor(_DecalPosX + 0.5f) - 0.5f) * abs(2.0f * IN.uv.x -1.0f);
			DecalUV.y  = IN.uv.y;
			DecalUV    = DecalUV - float2(_DecalPosX , _DecalPosY) + IN.decal2.zw;
		}

		if ((_DecalMirror == 1) || (_DecalMirror == 3)) {
			DecalUV    = lerp(DecalUV , float2(-DecalUV.x , DecalUV.y) , saturate(IN.tangent.w));
			DecalUV.x += IN.decal2.z * saturate(IN.tangent.w) * 2.0f;
		}
		if  (_DecalMirror == 5) {
			DecalUV    = lerp(DecalUV , float2(-DecalUV.x , DecalUV.y) , floor(IN.uv.x + 0.5f));
			DecalUV.x += IN.decal2.z * floor(IN.uv.x + 0.5f) * 2.0f;
		}

		         DecalUV       = mul(DecalRot, DecalUV - IN.decal2.zw) + IN.decal2.zw;
		         DecalUV      *= IN.decal.xy;

		float2   DecalScrUV    = (DecalUV + IN.decanm.xy) * IN.decanm.zw;
		         DecalScrUV   += float2(_DecalScrollX , _DecalScrollY) * _Time.y;

		         DecalColor    = tex2Dbias(_DecalTex  , float4(DecalScrUV , 0.0f , IN.decal2.x * IN.decal2.y - 1.0f)) * _DecalColor;
		         DecalColor.a *= saturate((0.5f - abs(DecalUV.x - 0.5f)) * 1000.0f) * saturate((0.5f - abs(DecalUV.y - 0.5f)) * 1000.0f);

		if (_DecalMirror == 2) DecalColor.a = DecalColor.a * (1.0f - saturate(IN.tangent.w));
		if (_DecalMirror == 3) DecalColor.a = DecalColor.a *         saturate(IN.tangent.w);

		#ifdef TRANSPARENT
			if ((_DecalMode == 0) | (_DecalMode == 5)) {
				Color        = lerp(Color , lerp(DecalColor.rgb , Color , OUT.a) , DecalColor.a);
			}
			if  (_DecalMode == 1) {
				Color        = lerp(Color ,                       Color * OUT.a  , DecalColor.a);
				DecalColor.a = MonoColor(DecalColor.rgb) * DecalColor.a;
			}
			if ((_DecalMode == 2) | (_DecalMode == 3)) {
				DecalColor.a = DecalColor.a * OUT.a;
			}
			if  (_DecalMode == 4) {
				DecalColor.a = MonoColor(DecalColor.rgb) * DecalColor.a * _DecalEmission;
			}
		#endif

		         OUT.a         = max(OUT.a , DecalColor.a);

		if ((_DecalMode == 0) | (_DecalMode == 5)) {
			Color = lerp(Color ,          DecalColor.rgb , DecalColor.a);
		}
		if  (_DecalMode == 1) {
			Color = saturate(    Color  + DecalColor.rgb * DecalColor.a);
		}
		if  (_DecalMode == 2) {
			Color = lerp(Color , Color  * DecalColor.rgb , DecalColor.a);
		}
		if  (_DecalMode == 3) {
			float DecalMixCol = saturate(max(Color.r , max(Color.g , Color.b)) + _DecalBright);
			Color = lerp(Color , DecalMixCol * DecalColor.rgb , DecalColor.a);
		}
		if ((_DecalMode == 4) | (_DecalMode == 5)) {
			DecalColor.rgb = DecalColor.rgb * DecalColor.a;
		}

	}

//----オクルージョン
	if (_OcclusionMode == 1) Color *= lerp(1.0f , UNITY_SAMPLE_TEX2D_SAMPLER(_OcclusionMap , _MainTex , SubUV).rgb , _OcclusionStrength);

//-------------------------------------カットアウト
	#ifdef CUTOUT
	       clip(OUT.a - _Cutout);
	#endif

//-------------------------------------ノーマルマップ
	float3 Normal       = UnityObjectToWorldNormal(IN.normal);

	float3 tan_sx       = float3(IN.tanW.x , IN.tanB.x , Normal.x);
	float3 tan_sy       = float3(IN.tanW.y , IN.tanB.y , Normal.y);
	float3 tan_sz       = float3(IN.tanW.z , IN.tanB.z , Normal.z);

	float2 NormalMapUV  = MixingTransformTex(SubUV , _MainTex_ST , _BumpMap_ST);
	float3 NormalMap    = normalize(UnpackScaleNormal(tex2D(_BumpMap , NormalMapUV) , _BumpScale));
	       Normal.x     = dot(tan_sx , NormalMap);
	       Normal.y     = dot(tan_sy , NormalMap);
	       Normal.z     = dot(tan_sz , NormalMap);

//-------------------------------------シェーディング
	float3 ShadeMask    = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadeMask , _MainTex , SubUV).rgb * _Shade;
	float3 LightBoost   = 1.0f + (UNITY_SAMPLE_TEX2D_SAMPLER(_LightMask , _MainTex , SubUV).rgb * (_LightBoost - 1.0f));

//----ディフューズ
	float  Diffuse      = DiffuseCalc(Normal , IN.ldir , _ShadeGradient , _ShadeWidth);

	#ifdef PASS_FB
		float  SHDiffuse    = DiffuseCalc(Normal , IN.shdir , _ShadeGradient , _ShadeWidth);

		float4 VLDiffuse    = IN.vldirX * Normal.x;
		       VLDiffuse   += IN.vldirY * Normal.y;
		       VLDiffuse   += IN.vldirZ * Normal.z;
		       VLDiffuse    = max((float4)0.0f , VLDiffuse * IN.vlcorr);
	#endif

//----トゥーンシェーディング
	if (_ToonEnable) {
		Diffuse   = ToonCalc(Diffuse , IN.toon);
		#ifdef PASS_FB
			SHDiffuse = ToonCalc(SHDiffuse , IN.toon);
			VLDiffuse = ToonCalc(VLDiffuse , IN.toon);
		#endif
	}

//----影の色
	float3 ShadeColor   = saturate(Color * 3.0f - 1.5f) * _ShadeColor;
	       ShadeColor   = lerp(ShadeColor , _CustomShadeColor.rgb , _CustomShadeColor.a);

//-------------------------------------ライティング
	float3 LightBase    = (float3)0.0f;

	#ifdef PASS_FB
		       LightBase    = _LightColor0 * _DirectionalLight;
		float3 VLight0      = unity_LightColor[0].rgb * IN.vlatn.x;
		float3 VLight1      = unity_LightColor[1].rgb * IN.vlatn.y;
		float3 VLight2      = unity_LightColor[2].rgb * IN.vlatn.z;
		float3 VLight3      = unity_LightColor[3].rgb * IN.vlatn.w;
		float3 VLightBase   = (float3)0.0f;

		if (_BlendOperation == 4) {
			   VLightBase   = saturate((VLight0 + VLight1 + VLight2 + VLight3) * 0.8f);
		} else {
			   VLightBase   = saturate((VLight0 + VLight1 + VLight2 + VLight3) * 0.6f);
		}
	#endif
	#ifdef PASS_FA
		       LightBase    = LIGHT_ATTENUATION(IN);
		//思うようにならなかったので没。Sunao Shader 2でなんとかするかも
		//if (_ToonEnable) {
		//	   LightBase    = ToonCalc(LIGHT_ATTENUATION(IN) , IN.toon);
		//	   LightBase    = lerp(LightBase , LIGHT_ATTENUATION(IN) , 0.15f);
		//}
			   LightBase   *= _LightColor0 * _PointLight;
		if (_BlendOperation == 4) {
			   LightBase   *= 0.8f;
		} else {
			   LightBase   *= 0.6f;
		}
	#endif

//----モノクロライティング
	if (_MonochromeLit) {
		LightBase  = MonoColor(LightBase);
		#ifdef PASS_FB
			VLight0    = MonoColor(VLight0);
			VLight1    = MonoColor(VLight1);
			VLight2    = MonoColor(VLight2);
			VLight3    = MonoColor(VLight3);
			VLightBase = MonoColor(VLightBase);
		#endif
	}

//----ライト反映
	float3 Lighting     = LightBase;

	float3 DiffColor    = LightingCalc(Lighting , Diffuse , ShadeColor , ShadeMask);

	#ifdef PASS_FB
		float3 SHDiffColor  = LightingCalc(IN.shmax , SHDiffuse , ShadeColor , ShadeMask);
		       SHDiffColor  = saturate(SHDiffColor - IN.shmin) + IN.shmin;
		if (_OcclusionMode == 0) SHDiffColor *= lerp(1.0f , UNITY_SAMPLE_TEX2D_SAMPLER(_OcclusionMap , _MainTex , SubUV).rgb , _OcclusionStrength);

		float3 VL4Diff[4];
		       VL4Diff[0]   = LightingCalc(VLight0 , VLDiffuse.x , ShadeColor , ShadeMask);
		       VL4Diff[1]   = LightingCalc(VLight1 , VLDiffuse.y , ShadeColor , ShadeMask);
		       VL4Diff[2]   = LightingCalc(VLight2 , VLDiffuse.z , ShadeColor , ShadeMask);
		       VL4Diff[3]   = LightingCalc(VLight3 , VLDiffuse.w , ShadeColor , ShadeMask);
		float3 VLDiffColor  = saturate(VL4Diff[0] + VL4Diff[1] + VL4Diff[2] + VL4Diff[3]);

		       Lighting     = (DiffColor + SHDiffColor + VLDiffColor) * LightBoost;
	#endif
	#ifdef PASS_FA
		       Lighting     = DiffColor * LightBoost;
	#endif

	if (_LightLimitter) {
		float  MaxLight   = 1.0f;
		       MaxLight   = max(MaxLight , Lighting.r);
		       MaxLight   = max(MaxLight , Lighting.g);
		       MaxLight   = max(MaxLight , Lighting.b);
		       MaxLight   = min(MaxLight , 1.5f);
		       Lighting   = saturate(Lighting / MaxLight);
	}

//-------------------------------------エミッション
	float3 Emission     = (float3)0.0f;

	bool   EmissionFlag = _EmissionEnable;
	#ifdef PASS_FA
		EmissionFlag = _EmissionEnable && _EmissionLighting;
	#endif

	if (EmissionFlag) {
		       Emission    = _Emission * _EmissionColor.rgb;
		       Emission   *= tex2D(_EmissionMap  , IN.euv.xy).rgb * tex2D(_EmissionMap  , IN.euv.xy).a * IN.eprm.x;
		       Emission   *= tex2D(_EmissionMap2 , IN.euv.zw).rgb * tex2D(_EmissionMap2 , IN.euv.zw).a;

		if (_EmissionLighting) {
			#ifdef PASS_FB
				Emission   *= saturate(MonoColor(LightBase) + MonoColor(IN.shmax) + MonoColor(VLightBase));
			#endif
			#ifdef PASS_FA
				Emission   *= saturate(MonoColor(LightBase));
			#endif
		}
	}

//-------------------------------------視差エミッション
	float3 Parallax     = (float3)0.0f;

	bool   ParallaxFlag = _ParallaxEnable;
	#ifdef PASS_FA
		ParallaxFlag = _ParallaxEnable && _ParallaxLighting;
	#endif

	if (ParallaxFlag) {
		float  Height      = (1.0f - MonoColor(UNITY_SAMPLE_TEX2D_SAMPLER(_ParallaxDepthMap , _MainTex , IN.pduv).rgb)) * _ParallaxDepth;
		float2 ParallaxUV  = IN.peuv.xy;
		       ParallaxUV -= normalize(IN.pview).xz * Height * _ParallaxMap_ST.xy;
		       Parallax    = _ParallaxEmission * _ParallaxColor.rgb;
		       Parallax   *= tex2D(_ParallaxMap  , ParallaxUV).rgb * tex2D(_ParallaxMap  , ParallaxUV).a * IN.peprm.x;
		       Parallax   *= tex2D(_ParallaxMap2 , IN.peuv.zw).rgb * tex2D(_ParallaxMap2 , IN.peuv.zw).a;

		if (_ParallaxLighting) {
			#ifdef PASS_FB
				Parallax   *= saturate(MonoColor(LightBase) + MonoColor(IN.shmax) + MonoColor(VLightBase));
			#endif
			#ifdef PASS_FA
				Parallax   *= saturate(MonoColor(LightBase));
			#endif
		}
	}

//-------------------------------------リフレクション
	float  Smoothness   = 0.0f;
	float3 SpecularMask = (float3)0.0f;
	float3 ReflectMask  = (float3)0.0f;
	float  MatCapSmooth = 0.0f;
	float3 MatCapMask   = (float3)0.0f;
	float3 Specular     = (float3)0.0f;
	float3 Reflection   = (float3)0.0f;
	float3 MatCapture   = (float3)0.0f;

	if (_ReflectionEnable) {
//----スペキュラ反射
		       Smoothness   = tex2D(_MetallicGlossMap , SubUV).a * _GlossMapScale;
		       SpecularMask = tex2D(_MetallicGlossMap , SubUV).rgb;
		       SpecularMask = lerp(1.0f , SpecularMask , _SpecularMask);

		float3 RLSpecular   = SpecularCalc(Normal , IN.ldir , View , Smoothness) * LightBase;

		#ifdef PASS_FB
			float3 SHSpecular   = (float3)0.0f;
			if (_SpecularSH) {
			       SHSpecular   = SpecularCalc(Normal , IN.shdir , View , Smoothness) * IN.shmax;
			}
			       Specular     = (RLSpecular + SHSpecular) * _Specular * ((Smoothness * Smoothness * Smoothness) + 0.25f);
		#endif
		#ifdef PASS_FA
			       Specular     =  RLSpecular               * _Specular * ((Smoothness * Smoothness * Smoothness) + 0.25f);
		#endif

//----環境マッピング
		       ReflectMask  = tex2D(_MetallicGlossMap , SubUV).rgb;

		#ifdef PASS_FB
			       Reflection   = ReflectionCalc(WorldPos , Normal , View , Smoothness);

			if (_ReflectLit == 1) Reflection *= saturate(LightBase + VLightBase);
			if (_ReflectLit == 2) Reflection *= saturate(IN.shmax);
			if (_ReflectLit == 3) Reflection *= saturate(LightBase + IN.shmax + VLightBase);
		#endif
		#ifdef PASS_FA
			if ((_ReflectLit == 1) || (_ReflectLit == 3)) {
			       Reflection   = ReflectionCalc(WorldPos , Normal , View , Smoothness);
				   Reflection  *= saturate(LightBase);
			}
		#endif

//----マットキャップ
		       MatCapSmooth = UNITY_SAMPLE_TEX2D_SAMPLER(_MatCapMask , _MainTex , IN.uv).a;
		       MatCapMask   = UNITY_SAMPLE_TEX2D_SAMPLER(_MatCapMask , _MainTex , IN.uv).rgb;
		       MatCapSmooth = lerp(MatCapSmooth , tex2D(_MetallicGlossMap , SubUV).a , _MatCapMaskEnable);
		       MatCapMask   = lerp(MatCapMask   , ReflectMask                        , _MatCapMaskEnable);

		float3 MatCapV      = normalize(IN.vfront - View * dot(View, IN.vfront));
		float3 MatCapH      = normalize(cross(View , MatCapV));

		#ifdef PASS_FB
			float2 MatCapUV     = float2(dot(MatCapH , Normal), dot(MatCapV , Normal)) * 0.5f + 0.5f;
			       MatCapture   = tex2Dbias(_MatCap , float4(MatCapUV , 0.0f , 3.0f * (1.0f - MatCapSmooth))).rgb * _MatCapStrength;

			if (_MatCapLit == 1) MatCapture *= saturate(LightBase + VLightBase);
			if (_MatCapLit == 2) MatCapture *= saturate(IN.shmax);
			if (_MatCapLit == 3) MatCapture *= saturate(LightBase + IN.shmax + VLightBase);
		#endif
		#ifdef PASS_FA
			if ((_MatCapLit  == 1) || (_MatCapLit  == 3)) {
				float2 MatCapUV    = float2(dot(MatCapH , Normal), dot(MatCapV , Normal)) * 0.5f + 0.5f;
				       MatCapture  = tex2Dbias(_MatCap , float4(MatCapUV , 0.0f , 3.0f * (1.0f - MatCapSmooth))).rgb * _MatCapStrength;
				       MatCapture *= saturate(LightBase);
			}
		#endif

//----トゥーンスペキュラ
		if (_ToonGlossEnable) {
			Specular = ToonCalc(Specular , Toon(_ToonGloss , 0.75f));
		}

//----
		       Specular     = Specular   * SpecularMask * _GlossColor;
		       Reflection   = Reflection * SpecularMask * _GlossColor;
		       MatCapture   = MatCapture * MatCapMask   * _MatCapColor;

		if (_SpecularTexColor ) Specular    *= Color;
		if (_MetallicTexColor ) Reflection  *= Color;
		if (_MatCapTexColor   ) MatCapture  *= Color;
	}

//-------------------------------------リムライティング
	float3 RimLight = (float3)0.0f;
	#ifdef PASS_FB
		if (_RimLitEnable) {
			       RimLight  = RimLightCalc(Normal , View , _RimLit , _RimLitGradient);
			       RimLight *= _RimLitColor.rgb * _RimLitColor.a * UNITY_SAMPLE_TEX2D_SAMPLER(_RimLitMask , _MainTex , SubUV).rgb;
			if (_RimLitLighthing) RimLight *= saturate(LightBase + IN.shmax + VLightBase);
			if (_RimLitTexColor ) RimLight *= Color;
		}
	#endif
	#ifdef PASS_FA
		if (_RimLitEnable && _RimLitLighthing) {
			       RimLight  = RimLightCalc(Normal , View , _RimLit , _RimLitGradient);
			       RimLight *= _RimLitColor.rgb * _RimLitColor.a * UNITY_SAMPLE_TEX2D_SAMPLER(_RimLitMask , _MainTex , SubUV).rgb;
			       RimLight *= saturate(LightBase);
			if (_RimLitTexColor ) RimLight *= Color;
		}
	#endif

//-------------------------------------最終カラー計算
	       OUT.rgb      = Color * Lighting;
	       OUT.rgb      = lerp(OUT.rgb , Color , _Unlit);
	       OUT.rgb      = lerp(OUT.rgb , Reflection , _Metallic * ReflectMask);
	       OUT.rgb     += Specular;
	       OUT.rgb     += MatCapture;

//----リムライティング混合
	if (_RimLitEnable) {
		if (_RimLitMode == 0) OUT.rgb += RimLight;
		if (_RimLitMode == 1) OUT.rgb *= RimLight;
		if (_RimLitMode == 2) OUT.rgb  = saturate(OUT.rgb - RimLight);
	}

//----デカールエミッション混合
	#ifdef PASS_FB
		if (_DecalEnable) {
			if (_DecalMode == 4) OUT.rgb += DecalColor.rgb * _DecalEmission;
			if (_DecalMode == 5) OUT.rgb += DecalColor.rgb * _DecalEmission;
		}
	#endif

//----エミッション混合
	if (EmissionFlag) {

		float EmissionRev   = MonoColor(LightBase);
		#ifdef PASS_FB
			EmissionRev += MonoColor(IN.shmax) + MonoColor(VLightBase);
		#endif

		      EmissionRev   = 1.0f - pow(saturate(EmissionRev) , 0.44964029f);
		      EmissionRev   = saturate((EmissionRev - _EmissionInTheDark + 0.1f) * 10.0f);
		      Emission     *= EmissionRev;

		if (_EmissionMode == 0) OUT.rgb += Emission;
		if (_EmissionMode == 1) {
			OUT.rgb *= saturate(1.0f - Emission);
			OUT.rgb += (lerp(Color , Reflection , (_Metallic * ReflectMask)) + ((Specular + MatCapture) * SpecularMask)) * Emission;
		}
		if (_EmissionMode == 2) OUT.rgb  = saturate(OUT.rgb - Emission);
	}

//----視差エミッション混合
	if (ParallaxFlag) {

		float ParallaxRev   = MonoColor(LightBase);
		#ifdef PASS_FB
			ParallaxRev += MonoColor(IN.shmax) + MonoColor(VLightBase);
		#endif

		      ParallaxRev   = 1.0f - pow(saturate(ParallaxRev) , 0.44964029f);
		      ParallaxRev   = saturate((ParallaxRev - _ParallaxInTheDark + 0.1f) * 10.0f);
		      Parallax     *= ParallaxRev;

		if (_ParallaxMode == 0) OUT.rgb += Parallax;
		if (_ParallaxMode == 1) {
			OUT.rgb *= saturate(1.0f - Parallax);
			OUT.rgb += (lerp(Color , Reflection , (_Metallic * ReflectMask)) + ((Specular + MatCapture) * SpecularMask)) * Parallax;
		}
		if (_ParallaxMode == 2) OUT.rgb  = saturate(OUT.rgb - Parallax);
	}

//----オクルージョンマスク
	if (_OcclusionMode == 2) OUT.rgb *= lerp(1.0f , UNITY_SAMPLE_TEX2D_SAMPLER(_OcclusionMap , _MainTex , SubUV).rgb , _OcclusionStrength);

//----エミッションのテクスチャアルファ無視
	#ifdef TRANSPARENT

		if (EmissionFlag && _IgnoreTexAlphaE) {
			float EmissionAlpha    = MonoColor(Emission);
			OUT.a = saturate(OUT.a + EmissionAlpha  );
		}

//----視差エミッションのテクスチャアルファ無視
		if (ParallaxFlag && _IgnoreTexAlphaPE) {
			float ParallaxAlpha    = MonoColor(Parallax);
			OUT.a = saturate(OUT.a + ParallaxAlpha  );
		}

//----リフレクションのテクスチャアルファ無視
		if (_ReflectionEnable && _IgnoreTexAlphaR) {
			float ReflectionAlpha  = 0.0f;
			      ReflectionAlpha += MonoColor(Reflection) * ReflectMask * _Metallic;
			      ReflectionAlpha += MonoColor(Specular)   * SpecularMask;
			      ReflectionAlpha += MonoColor(MatCapture) * ReflectMask;
			OUT.a = saturate(OUT.a + ReflectionAlpha);
		}

//----リムライトのテクスチャアルファ無視
		if (_RimLitEnable && _IgnoreTexAlphaRL) {
			float RimLightAlpha    = MonoColor(RimLight);
			OUT.a = saturate(OUT.a + RimLightAlpha  );
		}

	#endif

//-------------------------------------出力オプション
//----ガンマ修正
	if (_EnableGammaFix) {
		_GammaR = max(_GammaR , 0.00001f);
		_GammaG = max(_GammaG , 0.00001f);
		_GammaB = max(_GammaB , 0.00001f);

	       OUT.r    = pow(OUT.r , 1.0f / (1.0f / _GammaR));
	       OUT.g    = pow(OUT.g , 1.0f / (1.0f / _GammaG));
	       OUT.b    = pow(OUT.b , 1.0f / (1.0f / _GammaB));
	}

//----明度修正
	if (_EnableBlightFix) {
	       OUT.rgb *= _BlightOutput;
	       OUT.rgb  = max(OUT.rgb + _BlightOffset , 0.0f);
	}

//----出力リミッタ
	if (_LimitterEnable) {
	       OUT.rgb  = min(OUT.rgb , _LimitterMax);
	}

//----SrcAlphaの代用
	#ifdef TRANSPARENT
		#ifdef PASS_FA
			if (_BlendOperation == 4) {
				OUT.a    = 1.055f * pow(OUT.a , 0.41666667f) - 0.055f;
				OUT.rgb *= OUT.a;
			}
		#endif
	#endif

//-------------------------------------フォグ
	UNITY_APPLY_FOG(IN.fogCoord, OUT);


	return OUT;
}
