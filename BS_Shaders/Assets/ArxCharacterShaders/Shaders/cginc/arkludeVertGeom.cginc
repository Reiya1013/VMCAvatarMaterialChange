struct VertexOutput
{
    // appdata_full
    #ifdef AXCS_OUTLINE
        float4 vertex : SV_POSITION;
    #endif
    // float3 normal : NORMAL; TODO:アウトラインの幅の調整方法を後程検討する。その際にgeom内での膨らまし方によっては使う。

    float2 uv0 : TEXCOORD0;
    float4 color : COLOR0; // ※ a値をアウトラインの判断に使用。 Outlineであれば1,そうでなければ0

    #ifdef AXCS_OUTLINE
        float4 pos : CLIP_POS;
    #else
        float4 pos : SV_POSITION;
    #endif
    float3 normalDir : TEXCOORD1;
    float3 tangentDir : TEXCOORD2;
    float3 bitangentDir : TEXCOORD3;
    float4 posWorld : TEXCOORD4;

    SHADOW_COORDS(5)
    UNITY_FOG_COORDS(6)
    #ifndef AXCS_ADD
        float3 lightColor0 : LIGHT_COLOR0;
        float3 lightColor1 : LIGHT_COLOR1;
        float3 lightColor2 : LIGHT_COLOR2;
        float3 lightColor3 : LIGHT_COLOR3;
        float4 ambientAttenuation : AMBIENT_ATTEN;
        float4 ambientIndirect : AMBIENT_INDIRECT;
    #endif
    #ifdef AXCS_REFRACTED
        noperspective float2 grabUV : TEXCOORD7;
    #endif
    UNITY_VERTEX_OUTPUT_STEREO
};

struct v2g
{
    float4 vertex : SV_POSITION;
    // float3 normal : NORMAL; TODO:アウトラインの幅の調整方法を後程検討する。その際にgeom内での膨らまし方によっては使う。

    float2 uv0 : TEXCOORD0;
    float4 color : COLOR0;

    float4 pos : CLIP_POS;
    float3 normalDir : TEXCOORD1;
    float3 tangentDir : TEXCOORD2;
    float3 bitangentDir : TEXCOORD3;
    float4 posWorld : TEXCOORD4;

    SHADOW_COORDS(5)
    UNITY_FOG_COORDS(6)
    #ifndef AXCS_ADD
        float3 lightColor0 : LIGHT_COLOR0;
        float3 lightColor1 : LIGHT_COLOR1;
        float3 lightColor2 : LIGHT_COLOR2;
        float3 lightColor3 : LIGHT_COLOR3;
        float4 ambientAttenuation : AMBIENT_ATTEN;
        float4 ambientIndirect : AMBIENT_INDIRECT;
    #endif
    #ifdef AXCS_REFRACTED
        noperspective float2 grabUV : TEXCOORD7;
    #endif
    UNITY_VERTEX_OUTPUT_STEREO
};

struct g2f {

    float2 uv0 : TEXCOORD0;
    float4 color : COLOR0;

    float4 pos : SV_POSITION;
    float3 normalDir : TEXCOORD1;
    float3 tangentDir : TEXCOORD2;
    float3 bitangentDir : TEXCOORD3;
    float4 posWorld : TEXCOORD4;

    SHADOW_COORDS(5)
    UNITY_FOG_COORDS(6)
    #ifndef AXCS_ADD
        float3 lightColor0 : LIGHT_COLOR0;
        float3 lightColor1 : LIGHT_COLOR1;
        float3 lightColor2 : LIGHT_COLOR2;
        float3 lightColor3 : LIGHT_COLOR3;
        float4 ambientAttenuation : AMBIENT_ATTEN;
        float4 ambientIndirect : AMBIENT_INDIRECT;
    #endif
    #ifdef AXCS_REFRACTED
        noperspective float2 grabUV : TEXCOORD7;
    #endif
    UNITY_VERTEX_OUTPUT_STEREO
};


#ifndef AXCS_ADD
    inline void calcAmbientByShade4PointLights(float flipNormal, inout VertexOutput o) {
        // Shade4PointLightsを展開して改変
        // {
            // to light vectors
            float4 toLightX = unity_4LightPosX0 - o.posWorld.x;
            float4 toLightY = unity_4LightPosY0 - o.posWorld.y;
            float4 toLightZ = unity_4LightPosZ0 - o.posWorld.z;
            // squared lengths
            float4 lengthSq = 0;
            lengthSq += toLightX * toLightX;
            lengthSq += toLightY * toLightY;
            lengthSq += toLightZ * toLightZ;
            // don't produce NaNs if some vertex position overlaps with the light
            lengthSq = max(lengthSq, 0.000001);

            // NdotL
            float4 ndotl = 0;
            ndotl += toLightX * (o.normalDir.x * lerp(1, -1, _DoubleSidedFlipBackfaceNormal));
            ndotl += toLightY * (o.normalDir.y * lerp(1, -1, _DoubleSidedFlipBackfaceNormal));
            ndotl += toLightZ * (o.normalDir.z * lerp(1, -1, _DoubleSidedFlipBackfaceNormal));

            // correct NdotL
            float4 corr = rsqrt(lengthSq);
            ndotl = max (float4(0,0,0,0), ndotl * corr);
            // attenuation
            float4 atten = 1.0 / (1.0 + lengthSq * unity_4LightAtten0);
            float4 diff = ndotl * atten;
        // }
        o.ambientAttenuation = diff;
        o.ambientIndirect = sqrt(min(1,corr* atten));
    }
#endif

VertexOutput vert(appdata_full v) {
    VertexOutput o;
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    o.uv0 = v.texcoord;
    // o.normal = v.normal;
    o.color = float4(v.color.rgb, 0);
    o.normalDir = UnityObjectToWorldNormal(v.normal);
    o.tangentDir = UnityObjectToWorldDir(v.tangent);
    o.bitangentDir = cross(o.normalDir, o.tangentDir) * v.tangent.w * unity_WorldTransformParams.w;
    o.posWorld = mul(unity_ObjectToWorld, v.vertex);

    #ifdef AXCS_OUTLINE
    o.vertex = v.vertex;
    #endif

    o.pos = UnityObjectToClipPos(v.vertex);
    TRANSFER_SHADOW(o);
    UNITY_TRANSFER_FOG(o, o.pos);

    #ifdef AXCS_REFRACTED
        o.grabUV = ComputeGrabScreenPos (o.pos).xy/o.pos.w;
    #endif

    #ifndef AXCS_ADD
        // 頂点ライティングが必要な場合に取得
        #if UNITY_SHOULD_SAMPLE_SH && defined(VERTEXLIGHT_ON)
            o.lightColor0 = unity_LightColor[0].rgb;
            o.lightColor1 = unity_LightColor[1].rgb;
            o.lightColor2 = unity_LightColor[2].rgb;
            o.lightColor3 = unity_LightColor[3].rgb;
            calcAmbientByShade4PointLights(0, o);
        #else
            o.lightColor0 = 0;
            o.lightColor1 = 0;
            o.lightColor2 = 0;
            o.lightColor3 = 0;
            o.ambientAttenuation = o.ambientIndirect = 0;
        #endif
    #endif

    return o;
}

[maxvertexcount(6)]
void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
{
    g2f o;
    #if !defined(AXCS_REFRACTED) && defined(AXCS_OUTLINE)
        for (int i = 2; i >= 0; i--)
        {
            float4 posWorld = (mul(unity_ObjectToWorld, IN[i].vertex));
            float _OutlineWidthMask_var = tex2Dlod (_OutlineWidthMask, float4( TRANSFORM_TEX(IN[i].uv0, _OutlineWidthMask), 0, 0));
            float width = _OutlineWidth * _OutlineWidthMask_var;

            o.normalDir = IN[i].normalDir;
            o.pos = mul( UNITY_MATRIX_VP, mul( unity_ObjectToWorld, IN[i].vertex ) + float4(normalize(o.normalDir) * (width * 0.01), 0));
            o.uv0 = IN[i].uv0;
            o.color = float4(IN[i].color.rgb, 1);
            o.posWorld = posWorld;
            o.tangentDir = IN[i].tangentDir;
            o.bitangentDir = IN[i].bitangentDir;

            // Pass-through the shadow coordinates if this pass has shadows.
            #if defined (SHADOWS_SCREEN) || ( defined (SHADOWS_DEPTH) && defined (SPOT) ) || defined (SHADOWS_CUBE)
                o._ShadowCoord = IN[i]._ShadowCoord;
            #endif

            // Pass-through the fog coordinates if this pass has shadows.
            #if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
                o.fogCoord = IN[i].fogCoord;
            #endif

            #ifdef AXCS_REFRACTED
                o.grabUV = IN[i].grabUV;
            #endif

            #ifndef AXCS_ADD
                o.lightColor0        = IN[i].lightColor0;
                o.lightColor1        = IN[i].lightColor1;
                o.lightColor2        = IN[i].lightColor2;
                o.lightColor3        = IN[i].lightColor3;
                o.ambientAttenuation = IN[i].ambientAttenuation;
                o.ambientIndirect    = IN[i].ambientIndirect;
            #endif

            tristream.Append(o);
        }
        tristream.RestartStrip();
    #endif

    for (int ii = 0; ii < 3; ii++)
    {
        o.pos = UnityObjectToClipPos(IN[ii].vertex);
        o.uv0 = IN[ii].uv0;
        o.color = float4(IN[ii].color.rgb, 0);
        o.posWorld = IN[ii].posWorld;
        o.normalDir = IN[ii].normalDir;
        o.tangentDir = IN[ii].tangentDir;
        o.bitangentDir = IN[ii].bitangentDir;

        // Pass-through the shadow coordinates if this pass has shadows.
        #if defined (SHADOWS_SCREEN) || ( defined (SHADOWS_DEPTH) && defined (SPOT) ) || defined (SHADOWS_CUBE)
            o._ShadowCoord = IN[ii]._ShadowCoord;
        #endif

        // Pass-through the fog coordinates if this pass has shadows.
        #if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
            o.fogCoord = IN[ii].fogCoord;
        #endif

        #ifdef AXCS_REFRACTED
            o.grabUV = IN[ii].grabUV;
        #endif

        #ifndef AXCS_ADD
            o.lightColor0        = IN[ii].lightColor0;
            o.lightColor1        = IN[ii].lightColor1;
            o.lightColor2        = IN[ii].lightColor2;
            o.lightColor3        = IN[ii].lightColor3;
            o.ambientAttenuation = IN[ii].ambientAttenuation;
            o.ambientIndirect    = IN[ii].ambientIndirect;
        #endif

        tristream.Append(o);
    }

    tristream.RestartStrip();
}
