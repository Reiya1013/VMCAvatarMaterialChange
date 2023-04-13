//--------------------------------------------------------------
//              AlphaOFFPass
//                      Copyright (c) 2021 Reiya1013
//--------------------------------------------------------------
//-------------------------------------Include
	#include "./../LamePatchForSunaoShader/Shader/cginc/SunaoShader_Core.cginc"

    fixed4 alpha_off_frag (VOUT IN) : SV_Target
    {
        fixed4 rtn = fixed4(0,0,0,0);




        //-------------------------------------エミッション
		float3 Emission     = (float3)0.0f;
		if (_EmissionEnable) {
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

			#ifdef SPARKLES
				if (_SparkleEnable) {
					float4 p = tex2D(_SparkleParameterMap, IN.euv.xy);
					float SparkleValue = Sparkles(View, float3(IN.euv.xy, 1.0f),
												  _SparkleDensity * p.r, _SparkleSmoothness * p.g, _SparkleFineness * p.b,
												  _SparkleAngularBlink, _SparkleTimeBlink);
					Emission *= saturate(SparkleValue);
				}
			#endif


			//Emission /= 2;
			rtn.a = Emission / 5;
		}

		return rtn;

    }
