#include "Lighting.cginc"

float3 ShadeSH9Indirect(){
    return ShadeSH9(half4(0.0, -1.0, 0.0, 1.0));
}

float3 ShadeSH9Direct(){
    return ShadeSH9(half4(0.0, 1.0, 0.0, 1.0));
}

float3 grayscale_vector_node(){
    return float3(0, 0.3823529, 0.01845836);
}

float3 grayscale_for_light(){
    return float3(0.298912, 0.586611, 0.114478);
}

float3 ShadeSH9Normal( float3 normalDirection ){
    return ShadeSH9(half4(normalDirection, 1.0));
}

float3 CalculateHSV(float3 baseTexture, float hueShift, float saturation, float value ){
    float4 node_5443_k = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 node_5443_p = lerp(float4(float4(baseTexture,0.0).zy, node_5443_k.wz), float4(float4(baseTexture,0.0).yz, node_5443_k.xy), step(float4(baseTexture,0.0).z, float4(baseTexture,0.0).y));
    float4 node_5443_q = lerp(float4(node_5443_p.xyw, float4(baseTexture,0.0).x), float4(float4(baseTexture,0.0).x, node_5443_p.yzx), step(node_5443_p.x, float4(baseTexture,0.0).x));
    float node_5443_d = node_5443_q.x - min(node_5443_q.w, node_5443_q.y);
    float node_5443_e = 1.0e-10;
    float3 node_5443 = float3(abs(node_5443_q.z + (node_5443_q.w - node_5443_q.y) / (6.0 * node_5443_d + node_5443_e)), node_5443_d / (node_5443_q.x + node_5443_e), node_5443_q.x);;
    return (lerp(float3(1,1,1),saturate(3.0*abs(1.0-2.0*frac((hueShift+node_5443.r)+float3(0.0,-1.0/3.0,1.0/3.0)))-1),(node_5443.g*saturation))*(value*node_5443.b));
}

// SH変数群から最大光量を取得
half3 GetSHLength ()
{
    half3 x, x1;
    x.r = length(unity_SHAr);
    x.g = length(unity_SHAg);
    x.b = length(unity_SHAb);
    x1.r = length(unity_SHBr);
    x1.g = length(unity_SHBg);
    x1.b = length(unity_SHBb);
    return x + x1;
}

float3 GetIndirectSpecular(float3 lightColor, float3 lightDirection, float3 normalDirection,float3 viewDirection,
float3 viewReflectDirection, float attenuation, float roughness, float3 worldPos){
    UnityLight light;
    light.color = lightColor;
    light.dir = lightDirection;
    light.ndotl = max(0.0h,dot( normalDirection, lightDirection));
    UnityGIInput d;
    d.light = light;
    d.worldPos = worldPos;
    d.worldViewDir = viewDirection;
    d.atten = attenuation;
    d.ambient = 0.0h;
    d.boxMax[0] = unity_SpecCube0_BoxMax;
    d.boxMin[0] = unity_SpecCube0_BoxMin;
    d.probePosition[0] = unity_SpecCube0_ProbePosition;
    d.probeHDR[0] = unity_SpecCube0_HDR;
    d.boxMax[1] = unity_SpecCube1_BoxMax;
    d.boxMin[1] = unity_SpecCube1_BoxMin;
    d.probePosition[1] = unity_SpecCube1_ProbePosition;
    d.probeHDR[1] = unity_SpecCube1_HDR;
    Unity_GlossyEnvironmentData ugls_en_data;
    ugls_en_data.roughness = roughness;
    ugls_en_data.reflUVW = viewReflectDirection;
    float3 indirectSpecular = UnityGI_IndirectSpecular(d, 1.0h, ugls_en_data);
    return saturate(indirectSpecular);
}

float3 GetIndirectSpecularCubemap(samplerCUBE _ReflectionCubemap, half4 _ReflectionCubemap_HDR, float3 viewReflectDirection, float roughness){
    half3 specular;
    #ifdef _GLOSSYREFLECTIONS_OFF
        specular = unity_IndirectSpecColor.rgb;
    #else
        half perceptualRoughness = roughness*(1.7 - 0.7*roughness);
        half mip = perceptualRoughnessToMipmapLevel(perceptualRoughness);
        half4 rgbm  = texCUBElod(_ReflectionCubemap,float4(viewReflectDirection,mip));
        specular = DecodeHDR(rgbm, _ReflectionCubemap_HDR);
    #endif
    return specular;
}

float2 ComputePositionRelatedTransformCap(in float3 cameraSpaceViewDir, in float3 normalDirectionCap){
    
   float3 transformCapViewDir = cameraSpaceViewDir - float3(0,0,1);
   float3 transformCapNormal = mul( (float3x3)unity_WorldToCamera, normalDirectionCap );
   float2 transformCap_old = transformCapNormal.rg*0.5+0.5;
   float3 transformCapCombined = transformCapViewDir * (dot(transformCapViewDir, transformCapNormal) / transformCapViewDir.z) + transformCapNormal;
   return lerp(((transformCapCombined.rg*0.5)+0.5), transformCap_old, saturate(-transformCapNormal.z));             
}
float2 ComputeNonPositionRelatedTransformCap(in float3 normalDirectionCap){
    return (mul((float3x3)unity_WorldToCamera, normalDirectionCap ).rg*0.5+0.5);
}

float2 ComputeTransformCap(in float3 cameraSpaceViewDir, in float3 normalDirectionCap){
    if(_UsePositionRelatedCalc){
        return ComputePositionRelatedTransformCap(cameraSpaceViewDir,normalDirectionCap);
    }
    else{
        return ComputeNonPositionRelatedTransformCap(normalDirectionCap);
    }
}