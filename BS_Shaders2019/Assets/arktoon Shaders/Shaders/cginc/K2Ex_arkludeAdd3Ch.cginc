// K2Ex用拡張宣言
// common ch
UNITY_DECLARE_TEX2D_NOSAMPLER(_ChMaskTex); uniform float4 _ChMaskTex_ST;
uniform float4 _ColorC1;
uniform float4 _ColorC2;
uniform float4 _ColorC3;
// gloss
uniform float _GlossBlendCh1;
uniform float _GlossBlendCh2;
uniform float _GlossBlendCh3;
uniform float _GlossPowerCh1;
uniform float _GlossPowerCh2;
uniform float _GlossPowerCh3;
uniform float4 _GlossColorCh1;
uniform float4 _GlossColorCh2;
uniform float4 _GlossColorCh3;
// matcap
UNITY_DECLARE_TEX2D_NOSAMPLER(_MatcapTexture1ch); uniform float4 _MatcapTexture1ch_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_MatcapTexture2ch); uniform float4 _MatcapTexture2ch_ST;
UNITY_DECLARE_TEX2D_NOSAMPLER(_MatcapTexture3ch); uniform float4 _MatcapTexture3ch_ST;
uniform float4 _MatcapColor1ch;
uniform float4 _MatcapColor2ch;
uniform float4 _MatcapColor3ch;
// shadowcap
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowcapTexture1ch); uniform float4 _ShadowcapTexture1ch_ST;
uniform float4 _ShadowColor1ch;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowcapTexture2ch); uniform float4 _ShadowcapTexture2ch_ST;
uniform float4 _ShadowColor2ch;
UNITY_DECLARE_TEX2D_NOSAMPLER(_ShadowcapTexture3ch); uniform float4 _ShadowcapTexture3ch_ST;
uniform float4 _ShadowColor3ch;
// reflection
/*
// 未使用
uniform float _ReflectionReflectionPower1ch;
uniform float _ReflectionReflectionPower2ch;
uniform float _ReflectionReflectionPower3ch;
*/
//refraction
#ifdef ARKTOON_REFRACTED
uniform float _RefractionFresnelExpCh1;
uniform float _RefractionFresnelExpCh2;
uniform float _RefractionFresnelExpCh3;
uniform float _RefractionStrengthCh1;
uniform float _RefractionStrengthCh2;
uniform float _RefractionStrengthCh3;
#endif


float4 frag(VertexOutput i) : COLOR {

    i.normalDir = normalize(i.normalDir);

    float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir * lerp(1, i.faceSign, _DoubleSidedFlipBackfaceNormal));
    float3 viewDirection = normalize(UnityWorldSpaceViewDir(i.posWorld.xyz));
    float3 _BumpMap_var = UnpackScaleNormal(tex2D(REF_BUMPMAP,TRANSFORM_TEX(i.uv0, REF_BUMPMAP)), REF_BUMPSCALE);
    float3 normalLocal = _BumpMap_var.rgb;
    float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals

    float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
    float3 lightColor = _LightColor0.rgb;
    float3 halfDirection = normalize(viewDirection+lightDirection);
    float3 cameraSpaceViewDir = mul((float3x3)unity_WorldToCamera, viewDirection);
    UNITY_LIGHT_ATTENUATION(attenuation,i, i.posWorld.xyz);
    float4 _MainTex_var = UNITY_SAMPLE_TEX2D(REF_MAINTEX, TRANSFORM_TEX(i.uv0, REF_MAINTEX));
    float3 Diffuse = (_MainTex_var.rgb*REF_COLOR.rgb);

    // K2Ex 改造追記部-------------------------------------------------------------------------------------------------
    float4 _ChMaskTex_ver = UNITY_SAMPLE_TEX2D_SAMPLER(_ChMaskTex, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ChMaskTex));
    float3 ChColored1 = Diffuse*_ColorC1.rgb;
    float3 ChColored2 = Diffuse*_ColorC2.rgb;
    float3 ChColored3 = Diffuse*_ColorC3.rgb;

    Diffuse = ChColored1 * _ChMaskTex_ver.r + Diffuse * (1-_ChMaskTex_ver.r);
    Diffuse = ChColored2 * _ChMaskTex_ver.g + Diffuse * (1-_ChMaskTex_ver.g);
    Diffuse = ChColored3 * _ChMaskTex_ver.b + Diffuse * (1-_ChMaskTex_ver.b);

    // 透過ありだったらカラーチャンネルごとのAlphaも考慮する
    #ifdef ARKTOON_FADE
    float chAlpha =1;
    chAlpha = _ColorC1.a * _ChMaskTex_ver.r + chAlpha * (1-_ChMaskTex_ver.r);
    chAlpha = _ColorC2.a * _ChMaskTex_ver.g + chAlpha * (1-_ChMaskTex_ver.g);
    chAlpha = _ColorC3.a * _ChMaskTex_ver.b + chAlpha * (1-_ChMaskTex_ver.b);
    #endif

    // ---------------------------------------------------------------------------------------------------------------

    Diffuse = lerp(Diffuse, Diffuse * i.color,_VertexColorBlendDiffuse); // 頂点カラーを合成


    // アウトラインであればDiffuseとColorを混ぜる
    if (_OutlineUseColorShift) {
        float3 Outline_Diff_HSV = CalculateHSV((Diffuse * _OutlineTextureColorRate + mad(i.col, - _OutlineTextureColorRate,i.col)), _OutlineHueShiftFromBase, _OutlineSaturationFromBase, _OutlineValueFromBase);
        Diffuse = lerp(Diffuse, Outline_Diff_HSV, i.isOutline);
    } else {
        Diffuse = lerp(Diffuse, (Diffuse * _OutlineTextureColorRate + mad(i.col, - _OutlineTextureColorRate,i.col)), i.isOutline);
    }

    #ifdef ARKTOON_CUTOUT
        clip((_MainTex_var.a * REF_COLOR.a) - _CutoutCutoutAdjust);
    #endif

    #if defined(ARKTOON_CUTOUT) || defined(ARKTOON_FADE)
        if (i.isOutline) {
            float _OutlineMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_OutlineMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _OutlineMask)).r;
            clip(_OutlineMask_var.r - _OutlineCutoffRange);
        }
    #endif

    fixed _PointShadowborderBlur_var = UNITY_SAMPLE_TEX2D_SAMPLER(_PointShadowborderBlurMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _PointShadowborderBlurMask)).r * _PointShadowborderBlur;
    float ShadowborderMin = saturate( -_PointShadowborderBlur_var*0.5 +_PointShadowborder);
    float ShadowborderMax = saturate( _PointShadowborderBlur_var * 0.5 + _PointShadowborder);

    float lightContribution = dot(lightDirection, normalDirection)*attenuation;
    float directContribution = 1.0 - ((1.0 - saturate(( (saturate(lightContribution) - ShadowborderMin)) / (ShadowborderMax - ShadowborderMin))));
    // #ifdef USE_POINT_SHADOW_STEPS
        directContribution = lerp(directContribution, saturate(floor(directContribution * _PointShadowSteps) / (_PointShadowSteps - 1)), _PointShadowUseStep);
    // #endif

    // 光の受光に関する更なる補正
    // ・LightIntensityIfBackface(裏面を描画中に変動する受光倍率)
    // ・ShadowCapのModeがLightShutterの時にかかるマスク乗算
    float additionalContributionMultiplier = 1;
    additionalContributionMultiplier *= i.lightIntensityIfBackface;

    if (_ShadowCapBlendMode == 2) { // Light Shutter
        float3 normalDirectionShadowCap = normalize(mul( float3(normalLocal.r*_ShadowCapNormalMix,normalLocal.g*_ShadowCapNormalMix,normalLocal.b), tangentTransform )); // Perturbed normals
        float2 transformShadowCap = float2(0,0);
        //ここだけ他のComputeTransformCapと式が違った
        if (_UsePositionRelatedCalc) {
            float3 transformShadowCapViewDir = cameraSpaceViewDir  - float3(0,0,1);
            float3 transformShadowCapNormal = mul((float3x3)unity_WorldToCamera, normalDirectionShadowCap);
            float3 transformShadowCapCombined = transformShadowCapViewDir * (dot(transformShadowCapViewDir, transformShadowCapNormal) / transformShadowCapViewDir.z) + transformShadowCapNormal;
            transformShadowCap = ((transformShadowCapCombined.rg*0.5)+0.5);
        } else {
            transformShadowCap = (mul((float3x3)unity_WorldToCamera, normalDirectionShadowCap).rg*0.5+0.5);
        }
        float4 _ShadowCapTexture_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapTexture, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowCapTexture));
        float4 _ShadowCapBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ShadowCapBlendMask));
        // K2Ex 改造エリア Start -----------------------------------------------------------------------------------------------------------------

        float4  _ShadowcapTexture1ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture1ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture1ch))*_ShadowColor1ch;
        float4  _ShadowcapTexture2ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture2ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture2ch))*_ShadowColor2ch;
        float4  _ShadowcapTexture3ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture3ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture3ch))*_ShadowColor3ch;

        float3 shadowcap3ch_var = float3(1,1,1);
        shadowcap3ch_var = _ShadowcapTexture1ch_var.rgb * _ChMaskTex_ver.r + shadowcap3ch_var * (1-_ChMaskTex_ver.r);
        shadowcap3ch_var = _ShadowcapTexture2ch_var.rgb * _ChMaskTex_ver.g + shadowcap3ch_var * (1-_ChMaskTex_ver.g);
        shadowcap3ch_var = _ShadowcapTexture3ch_var.rgb * _ChMaskTex_ver.b + shadowcap3ch_var * (1-_ChMaskTex_ver.b);

        _ShadowCapTexture_var *= float4(shadowcap3ch_var, 1);  // 上書きしちゃう
        // K2Ex 改造エリア End -----------------------------------------------------------------------------------------------------------------
        additionalContributionMultiplier *= (1.0 - ((1.0 - (_ShadowCapTexture_var.rgb))*_ShadowCapBlendMask_var.rgb)*_ShadowCapBlend);
    }

    directContribution *= additionalContributionMultiplier;
    float _ShadowStrengthMask_var = tex2D(_ShadowStrengthMask, TRANSFORM_TEX(i.uv0, _ShadowStrengthMask));
    float3 finalLight = saturate(directContribution + ((1 - (_PointShadowStrength * _ShadowStrengthMask_var)) * attenuation));
    float3 coloredLight = saturate(lightColor*finalLight*_PointAddIntensity);
    float3 toonedMap = Diffuse * coloredLight;

    float3 specular = float3(0,0,0);
    float3 shadowcap = float3(1000,1000,1000);
    float3 matcap = float3(0,0,0);
    float3 RimLight = float3(0,0,0);

    #if !defined(ARKTOON_REFRACTED)
    if (_UseOutline == 0 || !i.isOutline) {
    #endif
        // オプション：Gloss
        if(_UseGloss) {
            // K2Ex 改造部 ---------------------------------------------------------------------------
            float chGlossBlend = _GlossBlend;
            chGlossBlend = _GlossBlendCh1 * _ChMaskTex_ver.r + chGlossBlend * (1-_ChMaskTex_ver.r);
            chGlossBlend = _GlossBlendCh2 * _ChMaskTex_ver.g + chGlossBlend * (1-_ChMaskTex_ver.g);
            chGlossBlend = _GlossBlendCh3 * _ChMaskTex_ver.b + chGlossBlend * (1-_ChMaskTex_ver.b);


            float chGlossPower = _GlossPower;
            chGlossPower = _GlossPowerCh1 * _ChMaskTex_ver.r + chGlossPower * (1-_ChMaskTex_ver.r);
            chGlossPower = _GlossPowerCh2 * _ChMaskTex_ver.g + chGlossPower * (1-_ChMaskTex_ver.g);
            chGlossPower = _GlossPowerCh3 * _ChMaskTex_ver.b + chGlossPower * (1-_ChMaskTex_ver.b);

            float4 chGlossColor = _GlossColor;
            chGlossColor = _GlossColorCh1 * _ChMaskTex_ver.r + chGlossColor * (1-_ChMaskTex_ver.r);
            chGlossColor = _GlossColorCh2 * _ChMaskTex_ver.g + chGlossColor * (1-_ChMaskTex_ver.g);
            chGlossColor = _GlossColorCh3 * _ChMaskTex_ver.b + chGlossColor * (1-_ChMaskTex_ver.b);
            // --------------------------------------------------------------------------------------

            float _GlossBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_GlossBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _GlossBlendMask));

            float gloss = chGlossBlend * _GlossBlendMask_var; // 改造部
            float perceptualRoughness = 1.0 - gloss;
            float roughness = perceptualRoughness * perceptualRoughness;
            float specPow = exp2( gloss * 10.0+1.0);

            float NdotL = saturate(dot( normalDirection, lightDirection ));
            float LdotH = saturate(dot(lightDirection, halfDirection));
            float3 specularColor = chGlossPower; // 改造部
            float specularMonochrome;
            float3 diffuseColor = Diffuse;
            diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
            specularMonochrome = 1.0-specularMonochrome;
            float NdotV = abs(dot( normalDirection, viewDirection ));
            float NdotH = saturate(dot( normalDirection, halfDirection ));
            float VdotH = saturate(dot( viewDirection, halfDirection ));
            float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
            float normTerm = GGXTerm(NdotH, roughness);
            float specularPBL = (visTerm*normTerm) * UNITY_PI;
            #ifdef UNITY_COLORSPACE_GAMMA
                specularPBL = sqrt(max(1e-4h, specularPBL));
            #endif
            specularPBL = max(0, specularPBL * NdotL);
            #if defined(_SPECULARHIGHLIGHTS_OFF)
                specularPBL = 0.0;
            #endif
            specularPBL *= any(specularColor) ? 1.0 : 0.0;
            float3 attenColor = attenuation * _LightColor0.xyz;
            float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
            half grazingTerm = saturate( gloss + specularMonochrome );
            specular = attenuation * directSpecular * chGlossColor.rgb; // 改造部
        }

        // オプション:ShadeCap
        if (_ShadowCapBlendMode < 2) {
            float3 normalDirectionShadowCap = normalize(mul( float3(normalLocal.r*_ShadowCapNormalMix,normalLocal.g*_ShadowCapNormalMix,normalLocal.b), tangentTransform )); // Perturbed normals
            float2 transformShadowCap = ComputeTransformCap(cameraSpaceViewDir,normalDirectionShadowCap);
            float4 _ShadowCapTexture_var =  UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapTexture, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowCapTexture));
            float4 _ShadowCapBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ShadowCapBlendMask));
            shadowcap = (1.0 - ((1.0 - (_ShadowCapTexture_var.rgb))*_ShadowCapBlendMask_var.rgb)*_ShadowCapBlend);
        }

        // オプション：MatCap
        if (_MatcapBlendMode < 3) {
            float3 normalDirectionMatcap = normalize(mul( float3(normalLocal.r*_MatcapNormalMix,normalLocal.g*_MatcapNormalMix,normalLocal.b), tangentTransform )); // Perturbed normals
            float2 transformMatcap = ComputeTransformCap(cameraSpaceViewDir,normalDirectionMatcap);
            float4 _MatcapTexture_var = UNITY_SAMPLE_TEX2D_SAMPLER(_MatcapTexture, REF_MAINTEX, TRANSFORM_TEX(transformMatcap, _MatcapTexture));
            float4 _MatcapBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_MatcapBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _MatcapBlendMask));

            // K2Ex 改造エリア Start -----------------------------------------------------------------------------------------------------------------

            float4  _MatcapTexture1ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_MatcapTexture1ch, REF_MAINTEX, TRANSFORM_TEX(transformMatcap, _MatcapTexture1ch))*_MatcapColor1ch;
            float4  _MatcapTexture2ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_MatcapTexture2ch, REF_MAINTEX, TRANSFORM_TEX(transformMatcap, _MatcapTexture2ch))*_MatcapColor2ch;
            float4  _MatcapTexture3ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_MatcapTexture3ch, REF_MAINTEX, TRANSFORM_TEX(transformMatcap, _MatcapTexture3ch))*_MatcapColor3ch;

            float3 matcap3ch_var = float3(0,0,0);
            matcap3ch_var = _MatcapTexture1ch_var.rgb * _ChMaskTex_ver.r + matcap3ch_var * (1-_ChMaskTex_ver.r);
            matcap3ch_var = _MatcapTexture2ch_var.rgb * _ChMaskTex_ver.g + matcap3ch_var * (1-_ChMaskTex_ver.g);
            matcap3ch_var = _MatcapTexture3ch_var.rgb * _ChMaskTex_ver.b + matcap3ch_var * (1-_ChMaskTex_ver.b);

            float3 matcapResult = ((_MatcapColor.rgb*_MatcapTexture_var.rgb+matcap3ch_var)*_MatcapBlendMask_var.rgb*_MatcapBlend);

            matcap = min(matcapResult, matcapResult * (coloredLight * _MatcapShadeMix));
 
            // K2Ex 改造エリア End -----------------------------------------------------------------------------------------------------------------
        }

        // オプション：Rim
        if (_UseRim) {
            float _RimBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_RimBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _RimBlendMask));
            float4 _RimTexture_var = UNITY_SAMPLE_TEX2D_SAMPLER(_RimTexture, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _RimTexture));
            RimLight = (
                lerp( _RimTexture_var.rgb, Diffuse, _RimUseBaseTexture )
                * pow(
                    saturate(1.0 - saturate(dot(normalDirection, viewDirection)) + _RimUpperSideWidth)
                    , _RimFresnelPower
                )
                * _RimBlend
                * _RimColor.rgb
                * _RimBlendMask_var
            );
            RimLight = min(RimLight, RimLight * (coloredLight * _RimShadeMix));
        }
    #if !defined(ARKTOON_REFRACTED)
    }
    #endif

    float3 finalColor = max(toonedMap, RimLight) + specular;

    // ShadeCapのブレンドモード
    if (_ShadowCapBlendMode == 0) { // Darken
        finalColor = min(finalColor, shadowcap);
    } else if  (_ShadowCapBlendMode == 1) { // Multiply
        finalColor = finalColor * shadowcap;
    }

    // MatCapのブレンドモード
    if (_MatcapBlendMode == 0) { // Add
        finalColor = finalColor + matcap;
    } else if (_MatcapBlendMode == 1) { // Lighten
        finalColor = max(finalColor, matcap);
    } else if (_MatcapBlendMode == 2) { // Screen
        finalColor = 1-(1-finalColor) * (1-matcap);
    }

    #ifdef ARKTOON_FADE
        fixed _AlphaMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_AlphaMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _AlphaMask)).r;
        fixed4 finalRGBA = fixed4(finalColor * (_MainTex_var.a * REF_COLOR.a * _AlphaMask_var * chAlpha),0); // 改造部
    #else
        fixed4 finalRGBA = fixed4(finalColor * 1,0);
    #endif
    UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
    return finalRGBA;
}