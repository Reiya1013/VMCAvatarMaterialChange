//--------------------------------------------------------------
//              AlphaOFFPass
//                      Copyright (c) 2021 Reiya1013
//--------------------------------------------------------------
//-------------------------------------Include
#include "../Includes/CGI_PoiPass.cginc"
    fixed4 alpha_off_frag (v2f IN) : SV_Target
    {
        fixed4 rtn = fixed4(0,0,0,0);




  //      //-------------------------------------エミッション
		//float3 Emission     = (float3)0.0f;
		//if (_EmissionEnable) {
		//		   Emission    = _Emission * _EmissionColor.rgb;
		//		   Emission   *= tex2D(_EmissionMap  , IN.euv.xy).rgb * tex2D(_EmissionMap  , IN.euv.xy).a * IN.eprm.x;
		//		   Emission   *= tex2D(_EmissionMap2 , IN.euv.zw).rgb * tex2D(_EmissionMap2 , IN.euv.zw).a;

		//	if (_EmissionLighting) {
		//		#ifdef PASS_FB
		//			Emission   *= saturate(MonoColor(LightBase) + MonoColor(IN.shmax) + MonoColor(VLightBase));
		//		#endif
		//		#ifdef PASS_FA
		//			Emission   *= saturate(MonoColor(LightBase));
		//		#endif
		//	}

		//	//Emission /= 2;
		//	rtn.a = Emission;
		//}

		return rtn;

    }
