//--------------------------------------------------------------
//              AlphaOFFPass
//                      Copyright (c) 2021 Reiya1013
//--------------------------------------------------------------
#include "UnityCG.cginc"
#include "UCTS_Outline_Tess.cginc"

    fixed4 alpha_off_frag (VertexOutput i) : SV_Target
    {
        float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );

        fixed4 rtn = fixed4(0,0,0,0);
        return rtn;
    }
