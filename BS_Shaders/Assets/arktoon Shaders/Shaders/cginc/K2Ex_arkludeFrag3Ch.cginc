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
uniform float _ReflectionReflectionPower1ch;
uniform float _ReflectionReflectionPower2ch;
uniform float _ReflectionReflectionPower3ch;
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

    float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir * lerp(1, i.faceSign, _DoubleSidedFlipBackfaceNormal));
    float3 viewDirection = normalize(UnityWorldSpaceViewDir(i.posWorld.xyz));
    float3 _BumpMap_var = UnpackScaleNormal(tex2D(REF_BUMPMAP,TRANSFORM_TEX(i.uv0, REF_BUMPMAP)), REF_BUMPSCALE);
    float3 normalLocal = _BumpMap_var.rgb;
    float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
    float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz + float3(0, +0.0000000001, 0));
    float3 lightColor = _LightColor0.rgb;
    float3 halfDirection = normalize(viewDirection+lightDirection);
    float3 cameraSpaceViewDir = mul((float3x3)unity_WorldToCamera, viewDirection);
    #if !defined(SHADOWS_SCREEN)
        float attenuation = 1;
    #else
        UNITY_LIGHT_ATTENUATION(attenuation, i, i.posWorld.xyz);
    #endif

    float4 _MainTex_var = UNITY_SAMPLE_TEX2D(REF_MAINTEX, TRANSFORM_TEX(i.uv0, REF_MAINTEX));
    float3 Diffuse = (_MainTex_var.rgb*REF_COLOR.rgb);

    // K2Ex ChannelColor 改造したところStart----------------------------------------------------------------------------------------------

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


    // K2Ex ChannelColor 改造End---------------------------------------------------------------------------------------------------------

    Diffuse = lerp(Diffuse, Diffuse * i.color,_VertexColorBlendDiffuse);


    // アウトラインであればDiffuseとColorを混ぜる
    if (_OutlineUseColorShift) {
        float3 Outline_Diff_HSV = CalculateHSV((Diffuse * _OutlineTextureColorRate + mad(i.col, - _OutlineTextureColorRate,i.col)), _OutlineHueShiftFromBase, _OutlineSaturationFromBase, _OutlineValueFromBase);
        Diffuse = lerp(Diffuse, Outline_Diff_HSV, i.isOutline);
    } else {
        Diffuse = lerp(Diffuse, (Diffuse * _OutlineTextureColorRate + mad(i.col,-_OutlineTextureColorRate,i.col)), i.isOutline);
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

    // 光源サンプリング方法(0:Arktoon, 1:Cubed)
    float3 ShadeSH9Plus = float3(0,0,0);
    float3 ShadeSH9Minus = float3(0,0,0);
    if (_LightSampling == 0) {
        // 明るい部分と暗い部分をサンプリング・グレースケールでリマッピングして全面の光量を再計算
        ShadeSH9Plus = GetSHLength();
        ShadeSH9Minus = ShadeSH9(float4(0,0,0,1));
    } else {
        // 空間上、真上を向いたときの光と真下を向いたときの光でサンプリング
        ShadeSH9Plus = ShadeSH9Direct();
        ShadeSH9Minus = ShadeSH9Indirect();
    }

    // 陰の計算
    float3 directLighting = saturate((ShadeSH9Plus+lightColor));
    ShadeSH9Minus *= _ShadowIndirectIntensity;
    float3 indirectLighting = saturate(ShadeSH9Minus);

    float3 grayscale_vector = grayscale_vector_node();
    float grayscalelightcolor = dot(lightColor,grayscale_vector);
    float grayscaleDirectLighting = (((dot(lightDirection,normalDirection)*0.5+0.5)*grayscalelightcolor*attenuation)+dot(ShadeSH9Normal( normalDirection ),grayscale_vector));
    float bottomIndirectLighting = dot(ShadeSH9Minus,grayscale_vector);
    float topIndirectLighting = dot(ShadeSH9Plus,grayscale_vector);
    float lightDifference = ((topIndirectLighting+grayscalelightcolor)-bottomIndirectLighting);
    float remappedLight = ((grayscaleDirectLighting-bottomIndirectLighting)/lightDifference);
    float _ShadowStrengthMask_var = tex2D(_ShadowStrengthMask, TRANSFORM_TEX(i.uv0, _ShadowStrengthMask));

    fixed _ShadowborderBlur_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowborderBlurMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ShadowborderBlurMask)).r * _ShadowborderBlur;
    //0< _Shadowborder< 1,0 < _ShadowborderBlur < 1 より  _Shadowborder - _ShadowborderBlur_var/2 < 1 , 0 < _Shadowborder + _ShadowborderBlur_var/2
    //float ShadowborderMin = max(0, _Shadowborder - _ShadowborderBlur_var/2);
    //float ShadowborderMax = min(1, _Shadowborder + _ShadowborderBlur_var/2);
    float ShadowborderMin = saturate(_Shadowborder - _ShadowborderBlur_var/2);//この場合saturateはコスト０でmaxより軽量です
    float ShadowborderMax = saturate(_Shadowborder + _ShadowborderBlur_var/2);//この場合saturateはコスト０でminより軽量です
    float grayscaleDirectLighting2 = (((dot(lightDirection,normalDirection)*0.5+0.5)*grayscalelightcolor) + dot(ShadeSH9Normal( normalDirection ),grayscale_vector));
    float remappedLight2 = ((grayscaleDirectLighting2-bottomIndirectLighting)/lightDifference);
    float directContribution = 1.0 - ((1.0 - saturate(( (saturate(remappedLight2) - ShadowborderMin)) / (ShadowborderMax - ShadowborderMin))));

    float selfShade = saturate(dot(lightDirection,normalDirection)+1+_OtherShadowAdjust);
    float otherShadow = saturate(saturate(mad(attenuation,2 ,-1))+mad(_OtherShadowBorderSharpness,-selfShade,_OtherShadowBorderSharpness));
    float tmpDirectContributionFactor0 = saturate(dot(lightColor,grayscale_for_light())*1.5);
    directContribution = lerp(0, directContribution, saturate(1-(mad(tmpDirectContributionFactor0,-otherShadow,tmpDirectContributionFactor0))));

    // #ifdef USE_SHADOW_STEPS
        directContribution = lerp(directContribution, min(1,floor(directContribution * _ShadowSteps) / (_ShadowSteps - 1)), _ShadowUseStep);
    // #endif
    float tmpDirectContributionFactor1 = _ShadowStrengthMask_var * _ShadowStrength;
    directContribution = 1.0 - mad(tmpDirectContributionFactor1,-directContribution,tmpDirectContributionFactor1);

    // 光の受光に関する更なる補正
    // ・LightIntensityIfBackface(裏面を描画中に変動する受光倍率)
    // ・ShadowCapのModeがLightShutterの時にかかるマスク乗算
    float additionalContributionMultiplier = i.lightIntensityIfBackface;

    if (_ShadowCapBlendMode == 2) { // Light Shutter
        float3 normalDirectionShadowCap = normalize(mul( float3(normalLocal.r*_ShadowCapNormalMix,normalLocal.g*_ShadowCapNormalMix,normalLocal.b), tangentTransform )); // Perturbed normals
        float2 transformShadowCap = ComputeTransformCap(cameraSpaceViewDir,normalDirectionShadowCap);
        float4 _ShadowCapTexture_var =  UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapTexture, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowCapTexture));
        float4 _ShadowCapBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ShadowCapBlendMask));
        // K2Ex 改造エリア Start -----------------------------------------------------------------------------------------------------------------

        float4  _ShadowcapTexture1ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture1ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture1ch))*_ShadowColor1ch;
        float4  _ShadowcapTexture2ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture2ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture2ch))*_ShadowColor2ch;
        float4  _ShadowcapTexture3ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture3ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture3ch))*_ShadowColor3ch;

        float3 shadowcap3ch_var = float3(1,1,1);
        shadowcap3ch_var = _ShadowcapTexture1ch_var.rgb * _ChMaskTex_ver.r + shadowcap3ch_var * (1-_ChMaskTex_ver.r);
        shadowcap3ch_var = _ShadowcapTexture2ch_var.rgb * _ChMaskTex_ver.g + shadowcap3ch_var * (1-_ChMaskTex_ver.g);
        shadowcap3ch_var = _ShadowcapTexture3ch_var.rgb * _ChMaskTex_ver.b + shadowcap3ch_var * (1-_ChMaskTex_ver.b);

        _ShadowCapTexture_var *= float4(shadowcap3ch_var,1);  // 上書きしちゃう
        // K2Ex 改造エリア End -----------------------------------------------------------------------------------------------------------------

        additionalContributionMultiplier *= saturate(1.0 - mad(_ShadowCapBlendMask_var.rgb,-_ShadowCapTexture_var.rgb,_ShadowCapBlendMask_var.rgb)*_ShadowCapBlend);
    }

    directContribution *= additionalContributionMultiplier;

    // 頂点ライティング：PixelLightから溢れた4光源をそれぞれ計算
    float3 coloredLight_sum = float3(0,0,0);
    if (_UseVertexLight) {
        fixed _PointShadowborderBlur_var = UNITY_SAMPLE_TEX2D_SAMPLER(_PointShadowborderBlurMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _PointShadowborderBlurMask)).r * _PointShadowborderBlur;
        float VertexShadowborderMin = saturate(-_PointShadowborderBlur_var*0.5+_PointShadowborder);
        float VertexShadowborderMax = saturate(_PointShadowborderBlur_var*0.5+_PointShadowborder);
        float4 directContributionVertex = 1.0 - ((1.0 - saturate(( (saturate(i.ambientAttenuation) - VertexShadowborderMin)) / (VertexShadowborderMax - VertexShadowborderMin))));
        // #ifdef USE_POINT_SHADOW_STEPS
            directContributionVertex = lerp(directContributionVertex, min(1,floor(directContributionVertex * _PointShadowSteps) / (_PointShadowSteps - 1)), _PointShadowUseStep);
        // #endif
        directContributionVertex *= additionalContributionMultiplier;
        //ベクトル演算を減らしつつ、複数のスカラー演算を一つのベクトル演算にまとめました。
        //現代のPC向けGPUはほぼ100%がスカラー型であり、ベクトル演算は基本的にその次元数分ALU負荷が倍増します。
        //複数の掛け算は基本的にスカラーを左に寄せるだけでベクトル演算が減って最適化に繋がります。
        float4 tmpColoredLightFactorAttenuated = directContributionVertex * i.ambientAttenuation;
        float4 tmpColoredLightFactorIndirect = mad(i.ambientIndirect,-_PointShadowStrength,i.ambientIndirect);
        float3 coloredLight_0 = max(tmpColoredLightFactorAttenuated.r ,tmpColoredLightFactorIndirect.r) * i.lightColor0;
        float3 coloredLight_1 = max(tmpColoredLightFactorAttenuated.g ,tmpColoredLightFactorIndirect.g) * i.lightColor1;
        float3 coloredLight_2 = max(tmpColoredLightFactorAttenuated.b ,tmpColoredLightFactorIndirect.b) * i.lightColor2;
        float3 coloredLight_3 = max(tmpColoredLightFactorAttenuated.a ,tmpColoredLightFactorIndirect.a) * i.lightColor3;
        coloredLight_sum = (coloredLight_0 + coloredLight_1 + coloredLight_2 + coloredLight_3) * _PointAddIntensity;
    }

    float3 finalLight = lerp(indirectLighting,directLighting,directContribution)+coloredLight_sum;

    // カスタム陰を使っている場合、directContributionや直前のfinalLightを使い、finalLightを上書きする
    float3 toonedMap = float3(0,0,0);
    if (_ShadowPlanBUsePlanB) {
        float3 shadeMixValue = lerp(directLighting, finalLight, _ShadowPlanBDefaultShadowMix);
        float3 ShadeMap = float3(0,0,0);
        if (_ShadowPlanBUseCustomShadowTexture) {
            float4 _ShadowPlanBCustomShadowTexture_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowPlanBCustomShadowTexture, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ShadowPlanBCustomShadowTexture));
            float3 shadowCustomTexture = _ShadowPlanBCustomShadowTexture_var.rgb * _ShadowPlanBCustomShadowTextureRGB.rgb;
            ShadeMap = shadowCustomTexture*shadeMixValue;
        } else {
            float3 Diff_HSV = CalculateHSV(Diffuse, _ShadowPlanBHueShiftFromBase, _ShadowPlanBSaturationFromBase, _ShadowPlanBValueFromBase);
            ShadeMap = Diff_HSV*shadeMixValue;
        }

        if (_CustomShadow2nd) {
            float ShadowborderMin2 = saturate((_ShadowPlanB2border * _Shadowborder) - _ShadowPlanB2borderBlur/2);
            float ShadowborderMax2 = saturate((_ShadowPlanB2border * _Shadowborder) + _ShadowPlanB2borderBlur/2);
            float directContribution2 = 1.0 - ((1.0 - saturate(( (saturate(remappedLight2) - ShadowborderMin2)) / (ShadowborderMax2 - ShadowborderMin2))));  // /2の部分をパラメーターにしたい
            directContribution2 *= additionalContributionMultiplier;
            float3 ShadeMap2 = float3(0,0,0);
            if (_ShadowPlanB2UseCustomShadowTexture) {
                float4 _ShadowPlanB2CustomShadowTexture_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowPlanB2CustomShadowTexture, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ShadowPlanB2CustomShadowTexture));
                float3 shadowCustomTexture2 = _ShadowPlanB2CustomShadowTexture_var.rgb * _ShadowPlanB2CustomShadowTextureRGB.rgb;
                shadowCustomTexture2 =  lerp(shadowCustomTexture2, shadowCustomTexture2 * i.color,_VertexColorBlendDiffuse); // 頂点カラーを合成
                ShadeMap2 = shadowCustomTexture2*shadeMixValue;
            } else {
                float3 Diff_HSV2 = CalculateHSV(Diffuse, _ShadowPlanB2HueShiftFromBase, _ShadowPlanB2SaturationFromBase, _ShadowPlanB2ValueFromBase);
                ShadeMap2 = Diff_HSV2*shadeMixValue;
            }
            ShadeMap = lerp(ShadeMap2,ShadeMap,directContribution2);
        }

        finalLight = lerp(ShadeMap,directLighting,directContribution)+coloredLight_sum;
        toonedMap = lerp(ShadeMap,Diffuse*finalLight,finalLight);
    } else {
        toonedMap = Diffuse*finalLight;
    }

    float3 tmpToonedMapFactor = (Diffuse+(Diffuse*coloredLight_sum));
    // アウトラインであればShadeMixを反映
    toonedMap = lerp(toonedMap, (toonedMap * _OutlineShadeMix + mad(tmpToonedMapFactor,-_OutlineShadeMix,tmpToonedMapFactor)), i.isOutline);

    // 裏面であればHSVShiftを反映
    if(_DoubleSidedBackfaceUseColorShift) {
        toonedMap = lerp(toonedMap, CalculateHSV(toonedMap, _DoubleSidedBackfaceHueShiftFromBase, _DoubleSidedBackfaceSaturationFromBase, _DoubleSidedBackfaceValueFromBase), i.isBackface);
        Diffuse = lerp(Diffuse, CalculateHSV(Diffuse, _DoubleSidedBackfaceHueShiftFromBase, _DoubleSidedBackfaceSaturationFromBase, _DoubleSidedBackfaceValueFromBase), i.isBackface);
    }

    float3 ReflectionMap = float3(0,0,0);
    float3 specular = float3(0,0,0);
    float3 matcap = float3(0,0,0);
    float3 RimLight = float3(0,0,0);
    float3 shadowcap = float3(1000,1000,1000);

    #if !defined(ARKTOON_REFRACTED)
    if (_UseOutline == 0 || !i.isOutline) {
    #endif
        // オプション：Reflection
        if (_UseReflection) {
            float3 normalDirectionReflection = normalize(mul( float3(normalLocal.rg*_ReflectionNormalMix,normalLocal.b), tangentTransform ));
            float reflNdotV = abs(dot( normalDirectionReflection, viewDirection ));
            float _ReflectionSmoothnessMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ReflectionReflectionMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ReflectionReflectionMask));

            // K2Ex 3ch
            float ref3chpower = 1.0;
            ref3chpower = _ReflectionReflectionPower1ch * _ChMaskTex_ver.r + ref3chpower * (1-_ChMaskTex_ver.r);
            ref3chpower = _ReflectionReflectionPower2ch * _ChMaskTex_ver.g + ref3chpower * (1-_ChMaskTex_ver.g);
            ref3chpower = _ReflectionReflectionPower3ch * _ChMaskTex_ver.b + ref3chpower * (1-_ChMaskTex_ver.b);

            float reflectionSmoothness = _ReflectionReflectionPower*ref3chpower*_ReflectionSmoothnessMask_var;  // 改造部K2Ex
            float perceptualRoughnessRefl = 1.0 - reflectionSmoothness;
            float3 reflDir = reflect(-viewDirection, normalDirectionReflection);
            float roughnessRefl = SmoothnessToRoughness(reflectionSmoothness);
            float3 indirectSpecular = float3(0,0,0);
            if (_UseReflectionProbe) {
                indirectSpecular = GetIndirectSpecular(lightColor, lightDirection,
                    normalDirectionReflection, viewDirection, reflDir, attenuation, roughnessRefl, i.posWorld.xyz
                );
                if (any(indirectSpecular.xyz) == 0) indirectSpecular = GetIndirectSpecularCubemap(_ReflectionCubemap, _ReflectionCubemap_HDR, reflDir, roughnessRefl);
            } else {
                indirectSpecular = GetIndirectSpecularCubemap(_ReflectionCubemap, _ReflectionCubemap_HDR, reflDir, roughnessRefl);
            }
            float3 specularColorRefl = reflectionSmoothness;
            float specularMonochromeRefl;
            float3 diffuseColorRefl = Diffuse;
            diffuseColorRefl = DiffuseAndSpecularFromMetallic( diffuseColorRefl, specularColorRefl, specularColorRefl, specularMonochromeRefl );
            specularMonochromeRefl = 1.0-specularMonochromeRefl;
            half grazingTermRefl = saturate( reflectionSmoothness + specularMonochromeRefl );
            #ifdef UNITY_COLORSPACE_GAMMA
                half surfaceReduction = 1.0-0.28*roughnessRefl*perceptualRoughnessRefl;
            #else
                half surfaceReduction = rcp(roughnessRefl*roughnessRefl + 1.0);
            #endif
            indirectSpecular *= FresnelLerp (specularColorRefl, grazingTermRefl, reflNdotV);
            indirectSpecular *= surfaceReduction *lerp(float3(1,1,1), finalLight,_ReflectionShadeMix);
            float reflSuppress = _ReflectionSuppressBaseColorValue * reflectionSmoothness;
            toonedMap = lerp(toonedMap,mad(toonedMap,-surfaceReduction,toonedMap), reflSuppress);
            ReflectionMap = indirectSpecular*lerp(float3(1,1,1), finalLight,_ReflectionShadeMix);
        }

        // オプション：Gloss
        if(_UseGloss) {
            // K2Ex 改造部・追加部---------------------------------------------------------------------
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
            // ---------------------------------------------------------------------------------------

            float glossNdotV = abs(dot( normalDirection, viewDirection ));
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
            float NdotH = saturate(dot( normalDirection, halfDirection ));
            float VdotH = saturate(dot( viewDirection, halfDirection ));
            float visTerm = SmithJointGGXVisibilityTerm( NdotL, glossNdotV, roughness );
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
            specular = attenuation * directSpecular * chGlossColor.rgb;     //  K2Ex 元：_GlossColor.rgb
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


            matcap = ((_MatcapColor.rgb*_MatcapTexture_var.rgb+matcap3ch_var)*_MatcapBlendMask_var.rgb*_MatcapBlend) * lerp(float3(1,1,1), finalLight,_MatcapShadeMix);
            // K2Ex 改造エリア End -----------------------------------------------------------------------------------------------------------------


        }

        // オプション：Rim
        if (_UseRim) {
            float _RimBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_RimBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _RimBlendMask));
            float4 _RimTexture_var = UNITY_SAMPLE_TEX2D_SAMPLER(_RimTexture, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _RimTexture));
            RimLight = (
                            lerp( _RimTexture_var.rgb, Diffuse, _RimUseBaseTexture )
                            * pow(
                                saturate(1.0 - saturate(dot(normalDirection * lerp(i.faceSign, 1, _DoubleSidedFlipBackfaceNormal), viewDirection) ) + _RimUpperSideWidth)
                                , _RimFresnelPower
                                )
                            * _RimBlend
                            * _RimColor.rgb
                            * _RimBlendMask_var
                            * lerp(float3(1,1,1), finalLight,_RimShadeMix)
                        );
        }

        // オプション:ShadeCap
        if (_ShadowCapBlendMode < 2) {
            float3 normalDirectionShadowCap = normalize(mul( float3(normalLocal.r*_ShadowCapNormalMix,normalLocal.g*_ShadowCapNormalMix,normalLocal.b), tangentTransform )); // Perturbed normals
            float2 transformShadowCap = ComputeTransformCap(cameraSpaceViewDir,normalDirectionShadowCap);
            float4 _ShadowCapTexture_var =  UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapTexture, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowCapTexture));
            float4 _ShadowCapBlendMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowCapBlendMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _ShadowCapBlendMask));

            // K2Ex 改造エリア Start -----------------------------------------------------------------------------------------------------------------

            float4  _ShadowcapTexture1ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture1ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture1ch))*_ShadowColor1ch;
            float4  _ShadowcapTexture2ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture2ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture2ch))*_ShadowColor2ch;
            float4  _ShadowcapTexture3ch_var = UNITY_SAMPLE_TEX2D_SAMPLER(_ShadowcapTexture3ch, REF_MAINTEX, TRANSFORM_TEX(transformShadowCap, _ShadowcapTexture3ch))*_ShadowColor3ch;

            float3 shadowcap3ch_var = float3(1,1,1);
            shadowcap3ch_var = _ShadowcapTexture1ch_var.rgb * _ChMaskTex_ver.r + shadowcap3ch_var * (1-_ChMaskTex_ver.r);
            shadowcap3ch_var = _ShadowcapTexture2ch_var.rgb * _ChMaskTex_ver.g + shadowcap3ch_var * (1-_ChMaskTex_ver.g);
            shadowcap3ch_var = _ShadowcapTexture3ch_var.rgb * _ChMaskTex_ver.b + shadowcap3ch_var * (1-_ChMaskTex_ver.b);

            shadowcap = (1.0 - mad(_ShadowCapBlendMask_var.rgb,-(_ShadowCapTexture_var.rgb*shadowcap3ch_var),_ShadowCapBlendMask_var.rgb)*_ShadowCapBlend);
            // K2Ex 改造エリア End -----------------------------------------------------------------------------------------------------------------
        }
    #if !defined(ARKTOON_REFRACTED)
    }
    #endif

    float3 finalcolor2 = toonedMap+ReflectionMap + specular;

    // ShadeCapのブレンドモード
    if (_ShadowCapBlendMode == 0) { // Darken
        finalcolor2 = min(finalcolor2, shadowcap);
    } else if  (_ShadowCapBlendMode == 1) { // Multiply
        finalcolor2 = finalcolor2 * shadowcap;
    }

    // MatCapのブレンドモード
    if (_MatcapBlendMode == 0) { // Add
        finalcolor2 = finalcolor2 + matcap;
    } else if (_MatcapBlendMode == 1) { // Lighten
        finalcolor2 = max(finalcolor2, matcap);
    } else if (_MatcapBlendMode == 2) { // Screen
        finalcolor2 = 1-(1-finalcolor2) * (1-matcap);
    }

    // 屈折
    #ifdef ARKTOON_REFRACTED
        // K2Ex改造追記部--------------------------------------------------------------------------
        float chFresnel = _RefractionFresnelExp;
        chFresnel = _RefractionFresnelExpCh1 * _ChMaskTex_ver.r + chFresnel * (1-_ChMaskTex_ver.r);
        chFresnel = _RefractionFresnelExpCh2 * _ChMaskTex_ver.g + chFresnel * (1-_ChMaskTex_ver.g);
        chFresnel = _RefractionFresnelExpCh3 * _ChMaskTex_ver.b + chFresnel * (1-_ChMaskTex_ver.b);

        float chStrength = _RefractionStrength;
        chStrength = _RefractionStrengthCh1 * _ChMaskTex_ver.r + chStrength * (1-_ChMaskTex_ver.r);
        chStrength = _RefractionStrengthCh2 * _ChMaskTex_ver.g + chStrength * (1-_ChMaskTex_ver.g);
        chStrength = _RefractionStrengthCh3 * _ChMaskTex_ver.b + chStrength * (1-_ChMaskTex_ver.b);
        //----------------------------------------------------------------------------------------

        float refractionValue = pow(1.0-saturate(dot(normalDirection, viewDirection)),chFresnel); // K2Ex改造箇所。元：_RefractionFresnelExp
        float2 sceneUVs = (i.grabUV) + ((refractionValue*chStrength) * mul(unity_WorldToCamera, float4(normalDirection,0) ).xyz.rgb.rg);    // K2Ex改造箇所。元：_RefractionStrength
        float4 sceneColor = tex2D(_GrabTexture, sceneUVs);



    #endif


    // Emission Parallax
    float3 emissionParallax = float3(0,0,0);
    if(_UseEmissionParallax) {
        float _EmissionParallaxDepthMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissionParallaxDepthMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _EmissionParallaxDepthMask)).r;
        float2 emissionParallaxTransform = _EmissionParallaxDepth * (_EmissionParallaxDepthMask_var - _EmissionParallaxDepthMaskInvert) * mul(tangentTransform, viewDirection).xy + i.uv0;
        float _EmissionMask_var =  UNITY_SAMPLE_TEX2D_SAMPLER(_EmissionParallaxMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _EmissionParallaxMask)).r;
        float3 _EmissionParallaxTex_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissionParallaxTex, REF_MAINTEX, TRANSFORM_TEX(emissionParallaxTransform, _EmissionParallaxTex)).rgb * _EmissionParallaxColor.rgb;
        emissionParallax = _EmissionParallaxTex_var * _EmissionMask_var;
    }

    #ifdef ARKTOON_EMISSIVE_FREAK
        float time = _Time.r;

        float2 emissiveFreak1uv = i.uv0 + float2(fmod(_EmissiveFreak1U * time, 1.0 / _EmissiveFreak1Tex_ST.x), fmod(time * _EmissiveFreak1V, 1.0 / _EmissiveFreak1Tex_ST.y));
        float _EmissiveFreak1DepthMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissiveFreak1DepthMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _EmissiveFreak1DepthMask)).r;
        float2 emissiveFreak1Transform = _EmissiveFreak1Depth * (_EmissiveFreak1DepthMask_var - _EmissiveFreak1DepthMaskInvert) * mul(tangentTransform, viewDirection).xy + emissiveFreak1uv;
        float _EmissiveFreak1Mask_var =  UNITY_SAMPLE_TEX2D_SAMPLER(_EmissiveFreak1Mask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _EmissiveFreak1Mask)).r;
        float3 _EmissiveFreak1Tex_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissiveFreak1Tex, REF_MAINTEX, TRANSFORM_TEX(emissiveFreak1Transform, _EmissiveFreak1Tex)).rgb * _EmissiveFreak1Color.rgb;
        float emissiveFreak1Breathing = cos(_EmissiveFreak1Breathing*time) * 0.5 + 0.5;//sin(x+π/2)=cos(x)
        float emissiveFreak1BlinkOut = 1 - ((_EmissiveFreak1BlinkOut*time) % 1.0);
        float emissiveFreak1BlinkIn = (_EmissiveFreak1BlinkIn*time) % 1.0;
        float emissiveFreak1Hue = (_EmissiveFreak1HueShift*time) % 1.0;
        _EmissiveFreak1Tex_var = CalculateHSV(_EmissiveFreak1Tex_var, emissiveFreak1Hue, 1.0, 1.0);
        float3 emissiveFreak1 = _EmissiveFreak1Tex_var * _EmissiveFreak1Mask_var;
        emissiveFreak1 = lerp(emissiveFreak1, emissiveFreak1 * emissiveFreak1Breathing, _EmissiveFreak1BreathingMix);
        emissiveFreak1 = lerp(emissiveFreak1, emissiveFreak1 * emissiveFreak1BlinkOut, _EmissiveFreak1BlinkOutMix);
        emissiveFreak1 = lerp(emissiveFreak1, emissiveFreak1 * emissiveFreak1BlinkIn, _EmissiveFreak1BlinkInMix);

        float2 emissiveFreak2uv = i.uv0 + float2(fmod(_EmissiveFreak2U * time, 1.0 / _EmissiveFreak2Tex_ST.x), fmod(time * _EmissiveFreak2V, 1.0 / _EmissiveFreak2Tex_ST.y));
        float _EmissiveFreak2DepthMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissiveFreak2DepthMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _EmissiveFreak2DepthMask)).r;
        float2 emissiveFreak2Transform = _EmissiveFreak2Depth * (_EmissiveFreak2DepthMask_var - _EmissiveFreak2DepthMaskInvert) * mul(tangentTransform, viewDirection).xy + emissiveFreak2uv;
        float _EmissiveFreak2Mask_var =  UNITY_SAMPLE_TEX2D_SAMPLER(_EmissiveFreak2Mask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _EmissiveFreak2Mask)).r;
        float3 _EmissiveFreak2Tex_var = UNITY_SAMPLE_TEX2D_SAMPLER(_EmissiveFreak2Tex, REF_MAINTEX, TRANSFORM_TEX(emissiveFreak2Transform, _EmissiveFreak2Tex)).rgb * _EmissiveFreak2Color.rgb;
        float emissiveFreak2Breathing = cos(_EmissiveFreak2Breathing*time) * 0.5 + 0.5;//sin(x+π/2)=cos(x)
        float emissiveFreak2BlinkOut = 1 - ((_EmissiveFreak2BlinkOut*time) % 1.0);
        float emissiveFreak2BlinkIn = (_EmissiveFreak2BlinkIn*time) % 1.0;
        float emissiveFreak2Hue = (_EmissiveFreak2HueShift*time) % 1.0;
        _EmissiveFreak2Tex_var = CalculateHSV(_EmissiveFreak2Tex_var, emissiveFreak2Hue, 1.0, 1.0);
        float3 emissiveFreak2 = _EmissiveFreak2Tex_var * _EmissiveFreak2Mask_var;
        emissiveFreak2 = lerp(emissiveFreak2, emissiveFreak2 * emissiveFreak2Breathing, _EmissiveFreak2BreathingMix);
        emissiveFreak2 = lerp(emissiveFreak2, emissiveFreak2 * emissiveFreak2BlinkOut, _EmissiveFreak2BlinkOutMix);
        emissiveFreak2 = lerp(emissiveFreak2, emissiveFreak2 * emissiveFreak2BlinkIn, _EmissiveFreak2BlinkInMix);

    #else
        float3 emissiveFreak1 = float3(0,0,0);
        float3 emissiveFreak2 = float3(0,0,0);
    #endif

    // Emissive合成・FinalColor計算
    float3 _Emission = tex2D(REF_EMISSIONMAP,TRANSFORM_TEX(i.uv0, REF_EMISSIONMAP)).rgb *REF_EMISSIONCOLOR.rgb;
    _Emission = _Emission + emissionParallax + emissiveFreak1 + emissiveFreak2;
    float3 emissive = max( lerp(_Emission.rgb, _Emission.rgb * i.color, _VertexColorBlendEmissive) , RimLight) * !i.isOutline;
    float3 finalColor = emissive + finalcolor2;

    #ifdef ARKTOON_FADE
        fixed _AlphaMask_var = UNITY_SAMPLE_TEX2D_SAMPLER(_AlphaMask, REF_MAINTEX, TRANSFORM_TEX(i.uv0, _AlphaMask)).r;
        #ifdef ARKTOON_REFRACTED
            fixed4 finalRGBA = fixed4(lerp(sceneColor, finalColor, (_MainTex_var.a*REF_COLOR.a*_AlphaMask_var*chAlpha)),1); // K2Ex:chAlphaを追加
        #else
            fixed4 finalRGBA = fixed4(finalColor,(_MainTex_var.a*REF_COLOR.a*_AlphaMask_var*chAlpha)); // K2Ex:chAlphaを追加
        #endif
    #else
        fixed4 finalRGBA = fixed4(finalColor,1);
    #endif
    UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
    return finalRGBA;
}