#include "UnityCG.cginc"
#include "UnityStandardUtils.cginc"

UNITY_DECLARE_TEX2D(_MainTex); uniform float4 _MainTex_ST;
uniform float4 _Color;
// Alpha Mask
UNITY_DECLARE_TEX2D_NOSAMPLER(_AlphaMask); uniform float4 _AlphaMask_ST;

#define _ALPHABLEND_ON

#if (SHADER_TARGET < 30) || defined(SHADER_API_GLES) || defined(SHADER_API_D3D11_9X) || defined (SHADER_API_PSP2)
    #undef UNITY_USE_DITHER_MASK_FOR_ALPHABLENDED_SHADOWS
#endif

#if defined(UNITY_USE_DITHER_MASK_FOR_ALPHABLENDED_SHADOWS)
    #define UNITY_STANDARD_USE_DITHER_MASK 1
#endif

#define UNITY_STANDARD_USE_SHADOW_UVS 1
#define UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT 1

#ifdef UNITY_STANDARD_USE_DITHER_MASK
sampler3D   _DitherMaskLOD;
#endif

struct VertexInputS
{
    float4 vertex   : POSITION;
    float3 normal   : NORMAL;
    float2 uv0      : TEXCOORD0;
};

#ifdef UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT
struct VertexOutputShadowCaster
{
    V2F_SHADOW_CASTER_NOPOS
    float2 tex : TEXCOORD1;
};
#endif

// We have to do these dances of outputting SV_POSITION separately from the vertex shader,
// and inputting VPOS in the pixel shader, since they both map to "POSITION" semantic on
// some platforms, and then things don't go well.

void vertShadowCaster (VertexInputS v,
    #ifdef UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT
    out VertexOutputShadowCaster o,
    #endif
    out float4 opos : SV_POSITION)
{
    #ifdef UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT
        UNITY_INITIALIZE_OUTPUT(VertexOutputShadowCaster, o);
    #endif

    TRANSFER_SHADOW_CASTER_NOPOS(o,opos)
    #if defined(UNITY_STANDARD_USE_SHADOW_UVS)
        o.tex = TRANSFORM_TEX(v.uv0, _MainTex);
    #endif
}

half4 fragShadowCaster (
#ifdef UNITY_STANDARD_USE_SHADOW_OUTPUT_STRUCT
    VertexOutputShadowCaster i
#endif
#ifdef UNITY_STANDARD_USE_DITHER_MASK
    , UNITY_VPOS_TYPE vpos : VPOS
#endif
    ) : SV_Target
{
    #if defined(UNITY_STANDARD_USE_SHADOW_UVS)
        float4 _MainTex_var = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(i.tex, _MainTex));
        fixed _AlphaMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_AlphaMask, _MainTex, TRANSFORM_TEX(i.tex, _AlphaMask)).r;
        half alpha = _MainTex_var.a*_Color.a*_AlphaMask_var;
        #if defined(UNITY_STANDARD_USE_DITHER_MASK)
            half alphaRef = tex3D(_DitherMaskLOD, float3(vpos.xy*0.25,alpha*0.9375)).a;
            clip (alphaRef - 0.01);
        #else
            clip (alpha - _CutoutCutoutAdjust);
        #endif
    #endif
    SHADOW_CASTER_FRAGMENT(i)
}