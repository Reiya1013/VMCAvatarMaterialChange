//--------------------------------------------------------------
//              AlphaOFFPass
//                      Copyright (c) 2021 Reiya1013
//--------------------------------------------------------------
#include "UCTS_ShadingGradeMap_Tess.cginc"

    fixed4 alpha_off_frag (VertexOutput i) : SV_Target
    {
        fixed4 rtn = fixed4(0,0,0,0);

        float4 _Emissive_Tex_var = tex2D(_Emissive_Tex,TRANSFORM_TEX(i.uv0, _Emissive_Tex));
        float emissiveMask = _Emissive_Tex_var.a;
        emissive = _Emissive_Tex_var.rgb * _Emissive_Color.rgb * (emissiveMask/2);
        rtn.a = emissive;

        return rtn;
    }
