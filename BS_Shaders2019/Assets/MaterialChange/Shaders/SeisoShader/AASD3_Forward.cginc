//AASD_Forward.cginc
//AAShader3DENSHOW 3.1


struct appdata
{
	float4 pos : POSITION;
	float3 normal : NORMAL;
	float2 uv : TEXCOORD0; //テクスチャのUVも受け取る
	half4 color : COLOR; //頂点カラーを得る 
#ifdef _AAS_BEKKAKU
	float4 tangent:TANGENT0;//接線 BEKKAKUで使う
#endif
};


struct v2f
{
	half2 uv	: TEXCOORD0; //TEXCOORDとかは頂点シェーダからフラグメントシェーダに渡される際にポリゴンにおけるピクセルの位置をいい感じに変換してくれる的なやつ
	half3 L	: TEXCOORD1; //光源の方向
	half3 V	: TEXCOORD2; //視点の方向
	float4 pos : SV_POSITION;
	half3 normal : NORMAL;
	half4 lightcolor : COLOR0;//ライトが当たっている個所の色
#ifdef _AAS_FWDBASE
	half3 ambient : COLOR1;//環境色
	half3 rim : COLOR3;//リムライトの色
	half lightPower : TEXCOORD5; //lightcolorに含まれるディレクショナルライトの強さ
#endif
#ifdef _AAS_FWDADD
	float3 worldPos: TEXCOORD4; //ポイントライト用にワールド座標を追加
#endif

#ifdef _AAS_BEKKAKU
	half2 bekkaku : TEXCOORD3;//BEKKAKU
#endif

#if defined(_AAS_SEISO) || defined(_AAS_SHINSEISO)
	float4 projPos : TEXCOORD3;
#endif
#ifdef _AAS_GAMING
	float3 wPos : TEXCOORD3;
#endif
};

//インスペクタから各種値を持ってくる
sampler2D _MainTex;//メインテクスチャ
float4 _MainTex_ST;
#ifndef _AAS_NUM

sampler2D _MaterialTex;//マテリアルテクスチャ
float4 _MaterialTex_ST;
#else
half _NumR;
half _NumG;
half _NumBB;
half _NumBT;
half _NumA;
#endif

half _ShadowPos;

half _SpecularSharp;//スペキュラーのシャープさ

half _BackLightCorrection;//逆光補正
half _BackLightCorrectionPos;//逆光補正を行いう位置

half4 _LightColor0;//どこからともなくライトの光を得るおまじない

half _ShadowSaturationCorrection;//影の彩度補正

half _DefaultLightDirection;

half _EmissionPower;//エミッションの強度


#ifdef _AAS_TIGHTS 
sampler2D _TightsTex;
half _TSharp;
#endif

#ifdef _AAS_GAMING

half _LightCycle;
half _LightPower;
half _LightWidth;
half _LightHeight;
#endif

#ifdef _AAS_SEISO
half _BackLightSeiso;
half _NormalLightSeiso;
half _BackLightAddition;
UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
#endif 
#ifdef _AAS_SHINSEISO
half _BackLightSeiso;
half _BackLightAddition;
UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
sampler2D _TightsTex;
#endif

v2f vert(appdata v)
{
	v2f o;

	o.pos = UnityObjectToClipPos(v.pos);//頂点をカメラ座標に変換し出力



	float3 V = normalize(WorldSpaceViewDir(v.pos)); //視線のベクトルを取得する
	o.V = V;//▼視線ベクトルを出力

	o.normal = UnityObjectToWorldNormal(v.normal);//法線をワールド座標に変換
	o.uv = TRANSFORM_TEX(v.uv, _MainTex); //使わない気がするけどテクスチャのオフセットとか処理するやつ


	//★アレな光源に対しての処理★
#ifdef _AAS_FWDBASE //フォワードベース時処理

	float3 C = normalize(UNITY_MATRIX_V._m20_m21_m22);

	//●まずディレクショナルライトがない場合は環境光から作る　FWDBASE時のみ● 
	half LightPower = saturate(max(max(_LightColor0.r, _LightColor0.b), _LightColor0.g) * 5);//ディレクショナルライトがあるかどうかの判定
	half IsLight = step(0.05, LightPower);

	//環境光の計算
	half3 groundColor = saturate(ShadeSH9(half4(0.0, -1.0, 0.0, 1.0)));//天頂方向よりの環境光
	half3 skyColor = saturate(ShadeSH9(half4(0.0, 1.0, 0.0, 1.0)));//地面方向よりの環境光

	half groundColorPow = max(max(groundColor.r, groundColor.g), groundColor.b);//天頂光の強度
	half skyColorPow = max(max(skyColor.r, skyColor.g), skyColor.b);//地面よりの光の強度

	half ambientDifference = saturate(abs(groundColorPow - skyColorPow));//光度差
	half is_Sky = step(groundColorPow, skyColorPow);//天頂と地面方向どちらが明るいかの判定

	half3 tmpAmbient = (skyColor + groundColor * 2) * 0.33;//信用できない光源の場合の環境光
	half3 maxAmbient = max(skyColor, groundColor);//より強い環境光のを取る
	half3 defaultAmbientColor = min(maxAmbient * 0.66, tmpAmbient) + _LightColor0 * 0.1;//一度求めた環境光が天頂光と変わらなすぎる場合の補完と環境光がなさすぎる場合の補填
	half3 defaultLightColor = maxAmbient - defaultAmbientColor;//信用できない場合のライト　

	half3 lightColor = lerp(defaultLightColor, _LightColor0, IsLight);//ライトがない場合ディフォルト値を入れる

	//ディレクショナルライトがない場合の光源の方向

	half3 defaultLightDirection = normalize(lerp(half3(0.0, -1.0, 0.0), half3(0.0, 1.0, 0.0), is_Sky) + half3(C.x, 0.0, C.z) * _DefaultLightDirection);

	half3 WorldlightDirection = WorldSpaceLightDir(v.pos);
	o.L = normalize(lerp(defaultLightDirection, WorldlightDirection, IsLight));



	//●逆光判定と処理　FWDBASE時のみ●
	//3.0変更
	half VtoL = -dot(V, o.L);
	half LightCorrection = saturate(((VtoL - 0.2 + _BackLightCorrectionPos) * 3) * _BackLightCorrection);
	half3 lightColorB = lightColor * (1 - LightCorrection );//逆光時にライトを消す
	half Backlight = 1 + saturate(VtoL) * _BackLightCorrection  * 3 + _BackLightCorrectionPos;


	//●リムライト光の計算　FWDBASE時のみ●
#if defined(_AAS_SEISO) || defined(_AAS_SHINSEISO) //SEISO時はライトの傾きを考慮しない
	half BackLightCorrection = _BackLightAddition;
#else
	half BackLightCorrection = saturate((dot(o.L, o.normal) + 0.5) * 2.0);//逆光時にリムライトに足す光
#endif
	half3 rim = ShadeSH9(half4(UnityObjectToWorldNormal(-V), 1));//視点の裏側からの環境光をリムライトとする
	o.rim = rim + lightColor * LightCorrection * 2 * BackLightCorrection;//▼リムライトの出力

	//●普通に取得する環境光 FWDBASE時のみ●
	half3 ambientsh = ShadeSH9(half4(o.normal, 1));//ごく普通に取得する通常の環境光
	half3 ambient = saturate(lerp(defaultAmbientColor, ambientsh, LightPower * (1 - LightCorrection)));// *NtoL));//信用できない光源の場合は上で作った環境光を入れる


	//●ForwardAddから漏れた分の光源の計算 FWDBASE時のみ●
#ifdef VERTEXLIGHT_ON
	float3 worldPos = mul(unity_ObjectToWorld, v.pos).xyz;

	half3 PointLights = Shade4PointLights(
		unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
		unity_LightColor[0].rgb, unity_LightColor[1].rgb,
		unity_LightColor[2].rgb, unity_LightColor[3].rgb,
		unity_4LightAtten0, worldPos, V);
	ambient += PointLights;
	defaultAmbientColor += PointLights;

#endif 


	//●アンビエントとライトが1を超えた場合の処理 FWDBASE時のみ●
	half3 protrudeRGB = lightColorB + ambient;
	half maxprotrudeRGB = max(protrudeRGB.r, max(protrudeRGB.g, protrudeRGB.b));
	float protrude = 1 / max(maxprotrudeRGB, 1.0);

	ambient = ambient * protrude;
	//●SEISO時の処理●
#if defined(_AAS_SEISO) || defined(_AAS_SHINSEISO)
	// ワールド空間座標を元に、スクリーンスペースでの位置を求める
	o.projPos = ComputeScreenPos(o.pos);

	// 求めたスクリーンスペースでの位置のz値からビュー座標系での深度値を求める
	o.projPos.z = -UnityObjectToViewPos(v.pos).z;
	//VtoL = VtoL * maxprotrudeRGB;
#endif
	lightColorB = lightColorB * protrude * v.color.g;//頂点カラーに応じてライトが当たらなくするやつ
	o.lightPower = max(max(lightColorB.r, lightColorB.b), lightColorB.b);
	o.lightcolor = half4(lightColorB + defaultAmbientColor, VtoL);//▼ライトの出力

	o.ambient = ambient;//▼環境光の出力


#else //FWDADD時の処理
	o.L = normalize(WorldSpaceLightDir(v.pos));

	half VtoL = -dot(V, o.L);
	half LightCorrection = saturate(((VtoL - 0.2 + _BackLightCorrectionPos) * 3) * _BackLightCorrection);
	half3 lightColorB = _LightColor0 * (1 - LightCorrection );//逆光時にライトを消す
	half Backlight = saturate(VtoL) * _BackLightCorrection * 2 + _BackLightCorrectionPos;
	o.lightcolor = half4(lightColorB, Backlight);//▼ライトの出力
	o.worldPos = mul(unity_ObjectToWorld, v.pos); //ピクセルが光源とどれだけ離れてるかの計算に使う
#endif

	//●別格 UV方向のベクトルから光源への角度を得てBEKKAKUで使う　Tights時には計算しない●
#ifdef _AAS_BEKKAKU

	float3 tangent = normalize(UnityObjectToWorldNormal(v.tangent));
	float3 binormal = cross(tangent, o.normal);

	o.bekkaku.x = dot(binormal, normalize(o.L + o.V));//▼BEKKAKUの出力
	o.bekkaku.y = dot(tangent, normalize(o.L + o.V));
#endif

	//TRANSFER_SHADOW(o)//シャドゥのレシーブ

#ifdef _AAS_FWDBASE
	o.rim = o.rim* v.color.g;
	o.ambient = o.ambient * (0.5 + v.color.g * 0.5);
#endif

#ifdef _AAS_GAMING
	o.wPos = mul(unity_ObjectToWorld, v.pos).xyz;
#endif
	return o;
}

half3 Gaming(float GamingFactor) {
	half m = fmod(GamingFactor, 3.0);
	half r = saturate(1 - abs(1 - m));
	half g = saturate(1 - abs(2 - m));
	half b = 1 - r - g;
	return half3(r, g, b);
}

half4 frag(v2f i) : SV_Target
{
	half3 L = i.L;
	half3 N = normalize(i.normal);
	half3 V = i.V;
	half3 H = normalize(L + V);

	half3 lightcolor = i.lightcolor.rgb;

	half4 TexC = tex2D(_MainTex, i.uv);//テクスチャからピクセルに当たる色を取得
#ifndef _AAS_NUM
	half4 TexM = tex2D(_MaterialTex, i.uv);//テクスチャから質感を取得


	half shadowadd = TexM.r * 2 - 1;//陰の位置
	half gloss = (TexM.g - 0.5) * 2;//光沢

#ifdef _AAS_TIGHTS
	half denier = TexM.b; //タイツを使う場合
#endif
#ifdef _AAS_BEKKAKU
	half bekkaku = (TexM.b - 0.5) * 2;//タイツ機能を使わない場合
#endif
#if defined(_AAS_SEISO) || defined(_AAS_SHINSEISO)
	half seiso = TexM.b;
#endif
	half Emission = (1 - TexM.a) * _EmissionPower;//透明な場合エミッションする
#else //質感テクスチャ使用しない場合の直接数値設定
	half shadowadd = (_NumR - 0.5) * 2;//陰の位置
	half gloss = (_NumG - 0.5) * 2;//光沢
	half denier = _NumBT;
	half bekkaku = (_NumBB - 0.5) * 2;
	half Emission = (1 - _NumA) * _EmissionPower;//透明な場合エミッションする
#endif

	//ライトの光を計算する
	half nl = dot(N, L) + _ShadowPos;
	half ddnl = abs(ddx(nl)) + abs(ddy(nl));
	half Nnl = nl + ddnl;
	half2 AAd = normalize(half2(abs(nl), abs(Nnl)));
	half lt = saturate(saturate(step(0, nl) + step(0, Nnl) * AAd.y) + max(shadowadd, -saturate(i.lightcolor.a + 1) - 0.2));


	half lgloss = saturate(gloss);
	half matte = saturate(-gloss);

	//リムライトの計算　
	half rnl = dot(V, N);

#ifdef _AAS_TIGHTS //Tightsの計算　リムライトの計算したついでに透け度の計算を行う

	half tights = saturate((rnl - denier) * _TSharp * (1 - denier * 0.5));//質感テクスチャのB値に応じて透けないテクスチャと透けてるテクスチャのブレンド値を計算する
	TexC = lerp(TexC,tex2D(_TightsTex, i.uv), tights);//透け側テクスチャを拾ってきてブレンドする
#endif


#ifdef _AAS_FWDBASE
	half3 rim = i.rim * saturate((0.3 - rnl) * 10) * lgloss;//リムライトの計算
#endif


	//清楚の処理
#if defined(_AAS_SEISO) || defined(_AAS_SHINSEISO)
	
	/* 保留　ミラーわかんね…
	float3 projPos = UNITY_PROJ_COORD(i.projPos);
	float PreComputeLinearEyeDepthFactor = max(0,mad(projPos.x * UNITY_MATRIX_VP._m20 + projPos.y * UNITY_MATRIX_VP._m21, rcp(projPos.z), abs(UNITY_MATRIX_VP._m22)));
	float zBuffer = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos));
	float sceneZ = UNITY_MATRIX_VP._m23 / (PreComputeLinearEyeDepthFactor + zBuffer);
	*/
	
	float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));	// 深度バッファからフェッチした値を使って、リニアな深度値に変換する

	float partZ = i.projPos.z;//ピクセルのデプス

	// フェード処理
	float backspace = saturate(sceneZ - i.projPos.z); //描写ピクセルの裏がどの程度開いているかの計算 
	half backlight = 1 + i.lightcolor.a;//順光逆光判定はすでに頂点シェーダでやってある　フフフ
	half seisorim = saturate(rnl * 1.3 - 0.3);
	half3 seisoadd = (i.rim * saturate(saturate(backspace) * _BackLightSeiso) * seisorim) * seiso * saturate(4 * backlight + 0.5); //逆光処理

	i.ambient += seisoadd;
	lightcolor += seisoadd;
#ifdef _AAS_SEISO
	half alpha = 1 - saturate(1 - abs(backspace) *_NormalLightSeiso)* seisorim* saturate(-2 * backlight + 1.5)* seiso; //順光処理
#endif
#ifdef _AAS_SHINSEISO
	TexC = lerp(TexC, tex2D(_TightsTex, i.uv), saturate(seisorim * saturate(-4 * backlight + 4)));//透け側テクスチャを拾ってきてブレンドする
	half alpha = 1;
#endif

#else
	half alpha = 1;
#endif


	//ハイライトの光を計算する
	half NtoH = saturate(dot(N, H));

#ifdef _AAS_BEKKAKU //BEKKAKU時
	half bekkakuX = i.bekkaku.x;
	half bekkakuY = i.bekkaku.y;
	half NtoHb = 1 - abs(lerp(bekkakuY, bekkakuX, step(0, bekkaku)));//BEKKAKUの計算
	NtoH = lerp(NtoH, NtoHb, abs(bekkaku));//通常のと混ぜることにより光沢をUVいずれかの方向に伸ばす
#endif

	//スペキュラーの計算
	half a = lgloss * lgloss * _SpecularSharp + 1;
	half b = lgloss * 4;
	half NtoH_t = saturate(NtoH * a - a + 1 + b) * lgloss;

	//マットな場合環境光にライトを足して平均化する
#ifdef _AAS_FWDBASE
	half3 specular = NtoH_t * lightcolor * i.lightPower;//ライトの光と掛けてハイライトの光を導き出す
	half3 halfLight = (i.lightcolor + i.ambient) * 0.5;
	half3 TotalLight = lerp(lerp(i.ambient, lightcolor, lt),halfLight, matte) + specular * (1 - lgloss); //ライトの合計値

	half3 tmpColor = TexC * TotalLight + specular * lgloss * lt + rim;//いったんピクセルの色を作るテクスチャの色と光の色を乗算してピクセルの色を出力する　ハイライトは加算する

	//彩度補正
	half LightPow = max(max(TotalLight.r, TotalLight.g), TotalLight.b);
	half Correction = saturate(1.0 - LightPow);//光が弱いほど彩度を調整する
	half Brightness = (tmpColor.r + tmpColor.g + tmpColor.b) * 0.333;//RGBの明るさ平均値を求める
	half3 CorrectionColor = (tmpColor - half3(Brightness, Brightness, Brightness)) * Correction * _ShadowSaturationCorrection;//平均値と比較し色ウェイ分を取り出す


	tmpColor = tmpColor + CorrectionColor;

	//エミッション
#ifndef _AAS_GAMING
	half3 outColor = tmpColor * (1 - saturate(Emission)) + TexC * Emission;
#else

	half3 outColor = tmpColor * (1 - saturate(Emission)) + TexC * Emission *  Gaming(_LightCycle * _Time.y + (i.wPos.x + i.wPos.y) * _LightWidth + i.wPos.z * _LightHeight) * _LightPower;
#endif
#endif

#ifdef _AAS_FWDADD
	half3 Light = lightcolor * (1 - matte) * lt;//ライトの計算　マットな場合ライトの影響を下げる
	half3 specular = NtoH_t * lightcolor;//ライトの光と掛けてハイライトの光を導き出す
	UNITY_LIGHT_ATTENUATION(attenuation, i, i.worldPos); //追加　光源との距離から光の減衰量をattenuationに入れる
	half3 TotalLight = (Light + specular * lgloss * lt + _LightColor0 * 0.1)* attenuation;
	half3 outColor = TexC * TotalLight + specular * lgloss * attenuation;
#endif



	return half4(outColor, alpha);
}