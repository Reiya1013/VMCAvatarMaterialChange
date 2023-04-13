//AAS4_FORWARD.cginc
//フォアード
//4.0

struct appdata
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
    float2 uv2 : TEXCOORD1;
    float2 uv3 : TEXCOORD2;
    float3 normal : NORMAL;
    half4 color : COLOR; //頂点カラーを得る
    float3 Tangent  : TANGENT0;
    // single pass instanced rendering
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float2 uv : TEXCOORD0;
    UNITY_FOG_COORDS(1)
    float4 pos : SV_POSITION;
    half3 normal : NORMAL;
    half3 specV : TEXCOORD2;
    half4 lightcolor : COLOR0;//ライトが当たっている個所の色 aはNtoL
    half4 ambient : COLOR1;//環境色
    half4 rimlight :COLOR2;//リムライト aはNtoV
    // single pass instanced rendering
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

sampler2D _MainTex;
float4 _MainTex_ST;

sampler2D _SpecularMap;
half _Specular;
half _BlueIsShadow;
half _AlphaIsEmission;

sampler2D _TightsTex;
sampler2D _TightsMap;
half _Tights;

half _UseUV3Configuration;
half _EyebrowsForwardWidth;


#ifdef _AAS4_SEISO
sampler2D _SeisoMap;
half _SeisoLight1;
half _SeisoLight2;
#endif

half _RimPoint;//

half4 _LightColor0;//どこからともなくライトの光を得るおまじない

half AAStep(half a,half b) 
{//アンチエイリアスをかけた二値化
    half difference = fwidth(b); //先に差分をとる　そうしないと想定以上に大きな差分を拾ってゴミが出る
    b = b - a;
    half adjacent = b + difference;
    half2 AA = normalize(half2(abs(b), abs(adjacent)));
    return saturate(step(0, b) + step(0, adjacent) * AA.y);
}

half MaxValue(half3 Value)
{
    return max(max(Value.r, Value.b), Value.g);
}
half MinValue(half3 Value)
{
    return min(min(Value.r, Value.b), Value.g);
}

v2f vert(appdata v)
{
    v2f o;

    // single pass instanced rendering
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    ////////////////////////////////////////////////////////////////////////////////★ごく基本的なお所の計算と出力　および後で必要になる数値の計算★
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

    half LightPower = saturate(MaxValue(_LightColor0));//まずディレクショナルライトがあるかどうかの判定
    half IsLight = step(0.1, LightPower);

    half3 normal = UnityObjectToWorldNormal(v.normal);//法線をワールド座標に変換
    half3 WorldlightDirection = lerp(half3(0.0, 1.0, 0.0), WorldSpaceLightDir(v.pos), IsLight);//ライトの方向 ライトがないときはデフォルト値を入れる
    half3 V = normalize(WorldSpaceViewDir(v.pos)); //視線のベクトルを取得する
    float3 C = normalize(UNITY_MATRIX_V._m20_m21_m22);//カメラのベクトルを取得する
    float3 worldPos = mul(unity_ObjectToWorld, v.pos).xyz;//頂点のワールド座標
    half VtoN = dot(-V, normal);//視線から法線
    half VtoC =  dot(C, WorldlightDirection);
    half NtoL = dot(WorldlightDirection, normal);//法線からライト
    half3 Ambient = ShadeSH9(half4(V, 1));//前方からのアンビエント
    half3 rimlight = ShadeSH9(half4(-V, 1));//後方からのアンビエント
    half3 light = lerp(saturate(ShadeSH9(half4(0.0, 1.0, 0.0, 1.0)) - Ambient),_LightColor0, IsLight);//まともなライトがない場合天頂方向からのアンビエントを入れる

    ////////////////////////////////////////////////////////////////////////////////★いい感じに光源をこね始める★
    LightPower = saturate(MaxValue(light));//ライトの強度を得て
    NtoL = clamp(NtoL - saturate(1 - LightPower * 3), -1, 1);//ライトの強度が低い場合NtoLを減らす
    //ディレクショナルライトにだけ逆光補正を入れる
    Ambient = max(Ambient, light * 0.2);//入れる前にアンビエントの最低保証値を入れておく

#ifdef VERTEXLIGHT_ON   //ヴァーテックスライトがある場合の処理
    //★★★★★★★★★★★★★ポイントライトバトルロイヤル！★★★★★★★★★★★★★//
    half3 PointLightColor[4];
    half NormalToPointlight[4];
    half3 lightDirection[4];
    //いったん各ポイントライトの明るさとNtoLを得る
    for (int index = 0; index < 4; index++) {
        float4 lightPosition = float4(unity_4LightPosX0[index], unity_4LightPosY0[index], unity_4LightPosZ0[index], 1.0);
        float3 vertexToLightSource = float3(lightPosition - worldPos);
        lightDirection[index] = normalize(vertexToLightSource);
        float squaredDistance = dot(vertexToLightSource, vertexToLightSource);
        float attenuation = 1.0 / (1.0 + unity_4LightAtten0[index] * squaredDistance);
        PointLightColor[index] = attenuation * unity_LightColor[index].rgb;
        light = max(light, PointLightColor[index]);//ライトの最大値を得る
    }
    //一番強いライトに対しての明るさでNormalToPointlightを減らして比較する
    for (index = 0; index < 4; index++) {
        half3 NormalToPointlight = dot(lightDirection[index], normal);
        half LightPow = saturate(MaxValue(PointLightColor[index]) * rcp(MaxValue(light)));
        half IsPLight = step(NtoL,NormalToPointlight);
        WorldlightDirection = lerp(WorldlightDirection, lightDirection[index], IsPLight);
        NtoL = max(NtoL, NormalToPointlight + LightPow -1);   
    }
#endif
    ////////////////////////////////////////////////////////////////////////////////★ライト最大値の補正★
    half3 TotalLight = light + Ambient;
    half maxlightcorrection = rcp(max(1.0, MaxValue(TotalLight)));
    TotalLight = TotalLight * maxlightcorrection;
    Ambient = min(Ambient, TotalLight * 0.8);
    Ambient = Ambient * maxlightcorrection;
    

    ////////////////////////////////////////////////////////////////////////////////★BEKKAKU★
    half3 binormal = UnityObjectToWorldNormal(normalize(v.Tangent));
    half3 SpecVec = V + WorldlightDirection;
    half3 bekkaku = normalize(cross(binormal,-normalize(cross(binormal, SpecVec))));
    SpecVec = lerp(SpecVec, bekkaku, v.uv3.x * _UseUV3Configuration );

    ////////////////////////////////////////////////////////////////////////////////★眉毛フォワーダと頂点出力★
    float3 wpos = mul(unity_ObjectToWorld, float4(v.pos.xyz, 1)).xyz;
    if (unity_OrthoParams.w < 0.5) {			//平衡投影でない
        o.pos = UnityWorldToClipPos(wpos + V  * _EyebrowsForwardWidth * v.uv3.y * _UseUV3Configuration);
    }
    else {										// カメラが orthographic のときはシフト後の z のみ採用する
        o.pos = UnityWorldToClipPos(wpos);
        o.pos.z = UnityWorldToClipPos(wpos + V  * _EyebrowsForwardWidth * v.uv3.y * _UseUV3Configuration).z;
    }
    UNITY_TRANSFER_FOG(o, o.pos);
 
    ////////////////////////////////////////////////////////////////////////////////★出力★
    NtoL = clamp(NtoL,-1,1) -saturate(1 - v.color.g)*2;//頂点カラーによる修正
    o.lightcolor = half4(TotalLight, NtoL);//ライトの出力 陰影を添えて
    o.ambient = half4(Ambient, VtoC);//アンビエントの出力 逆光補正を添えて
    o.rimlight = half4(rimlight , VtoN);//リムライト
    o.normal = normal; //法線は法線
    o.specV = SpecVec; //スペキュラーのベクトル
    return o;
}

////////////////////////////////////////////////////////////////////////////////●●フラグメントシェーダ●●
fixed4 frag(v2f i) : SV_Target
{
    // single pass instanced rendering
    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    // sample the texture
    half4 tex = tex2D(_MainTex, i.uv);
    half3 color = tex;
    half4 SpecularMap = tex2D(_SpecularMap, i.uv);
    //Tights計算
    half3 tightscolor = tex2D(_TightsTex,i.uv);
    half3 tightsmap = tex2D(_TightsMap, i.uv);
    color = lerp(tightscolor, color,AAStep(1 - _Tights * tightsmap.r, -i.rimlight.a));

    //陰影判定
    half FirstShadow = 0.6 - i.ambient.a;
    half SecondShadow = -0.6 - i.ambient.a;
    half ShadowAdd = SpecularMap.b * _BlueIsShadow * 2;
    half flt = AAStep(FirstShadow + ShadowAdd, i.lightcolor.a);
    half lt = AAStep(SecondShadow + ShadowAdd, i.lightcolor.a);
#ifdef _AAS4_SEISO
    half3 seiso = tex2D(_SeisoMap, i.uv);
#ifdef _AAS4_SEISO_SHIELDING//遮蔽物がある場合
    half SeisoLT = saturate(seiso.r * 2 - 1);
    lt = max(lt, SeisoLT * _SeisoLight2);
    flt = max(flt, SeisoLT * _SeisoLight1);
#else                       //遮蔽物がない場合
    half SeisoLT = saturate(seiso.r * 2);
    lt = max(lt, SeisoLT * _SeisoLight2);
    flt = max(flt, SeisoLT * _SeisoLight1);
#endif
#else
    half OverShadow = AAStep(-1 + ShadowAdd, i.lightcolor.a);//SEISOの時に追加影は入れない
#endif
    color = color * i.lightcolor;//まずライトの当たってる場合の色を作る
    half3 ShadowColor = color * (i.ambient);//影色を作る
    half ColorMax = MaxValue(color);
    half ShadowColorMax = MaxValue(ShadowColor);
    half ShadowPower = ColorMax - ShadowColorMax;//影の強さ
    half3 ColorWei = half3(ShadowColorMax, ShadowColorMax, ShadowColorMax) - ShadowColor;//影色から色ウェイを得る
    half ShadowColorCorrection = saturate(-i.ambient.a + 0.3)+ 0.05;//色ウェイの補正値
    half3 ColorWeiDef = normalize(ColorWei + half3(ShadowColorCorrection, ShadowColorCorrection, ShadowColorCorrection)) * ShadowPower;//色ウェイをノーマライズして彩度を上げる
    ColorWeiDef = ColorWeiDef * 0.5;//一影用なので半分
    half MaxWei = MaxValue(ColorWeiDef);
    half OverWei = saturate(MaxWei - MinValue(color));//彩度が飛び出る分
    half3 FirstShadowColor = saturate(color - ColorWeiDef - half3(OverWei, OverWei, OverWei));//彩度が高すぎる場合に輝度を減らす
    FirstShadowColor = lerp(ShadowColor, FirstShadowColor, saturate(i.ambient.a +0.7));//巡光でない場合二影に寄らせる
    half3 SecondShadowColor = lerp(FirstShadowColor, ShadowColor, saturate(0.5-i.ambient.a*2));//順光の場合一影に寄らせる

    //影の切り替え
    color = lerp(FirstShadowColor, color, flt);
    color = lerp(SecondShadowColor,color, lt);
#ifndef _AAS4_SEISO
    color = lerp(SecondShadowColor*(1 - saturate(-i.ambient.a +0.5)*0.2),color, OverShadow);
#endif
    //スペキュラーとリムライトを加える
    half3 SpecularS = pow(_Specular * SpecularMap.r,3);
    half Specular = AAStep(pow(_Specular * SpecularMap.g, 0.04),dot(normalize(i.normal), normalize(i.specV))) * SpecularS * flt;
    half3 AddColor = i.lightcolor * lt * Specular + i.rimlight * AAStep(-_RimPoint, i.rimlight.a) * SpecularS;
    color += AddColor;
    
    //エミッション
    color = lerp(color,tex.rgb* _AlphaIsEmission,saturate(_AlphaIsEmission * (1 - SpecularMap.a)));

    // apply fog
    UNITY_APPLY_FOG(i.fogCoord, color);
#ifdef _AAS4_TRANSPARENT//半透明処理
    half alpha = tex.a;
    color = color * alpha + AddColor;
    alpha = saturate(alpha + MaxValue(AddColor));
#ifdef IS_BEATSABER
    return half4(color, 0);
#endif 
    return half4(color, alpha);
#else
#ifdef IS_BEATSABER
    return half4(color, 0);
#endif 
    return half4(color,1);
#endif
}