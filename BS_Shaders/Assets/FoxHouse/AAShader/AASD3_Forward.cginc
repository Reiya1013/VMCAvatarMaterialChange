//AASD_Forward.cginc
//AAShader3DENSHOW 3.0


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
	half4 light : COLOR0;//ライトの色
#ifdef _AAS_FWDBASE
	half3 ambient : COLOR1;//環境色
	half3 rim : COLOR3;//リムライトの色
#endif
#ifdef _AAS_FWDADD
	float3 worldPos: TEXCOORD4; //ポイントライト用にワールド座標を追加
#endif

#ifdef _AAS_BEKKAKU
	half2 bekkaku : TEXCOORD3;//BEKKAKU
#endif

#ifdef _AAS_SEISO
	float4 projPos : TEXCOORD3;
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

half _SpecularSharp;//スペキュラーのシャープさ
half _BackLightCorrection;
half4 _LightColor0;//どこからともなくライトの光を得るおまじない

half _ShadowSaturationCorrection;//影の彩度補正

half _EmissionPower;//エミッションの強度


#ifdef _AAS_TIGHTS 
sampler2D _TightsTex;
half _TSharp;
#endif

#ifdef _AAS_SEISO
UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
#endif 


v2f vert(appdata v)
{
	v2f o;

	o.pos = UnityObjectToClipPos(v.pos);//頂点をカメラ座標に変換し出力
#ifdef _AAS_SEISO
	o.projPos = ComputeScreenPos(o.pos);
#endif
	float3 V = normalize(WorldSpaceViewDir(v.pos)); //視線のベクトルを取得する
	o.V = V;//▼視線ベクトルを出力

	o.normal = UnityObjectToWorldNormal(v.normal);//法線をワールド座標に変換
	o.uv = TRANSFORM_TEX(v.uv, _MainTex); //使わない気がするけどテクスチャのオフセットとか処理するやつ


	//★アレな光源に対しての処理★
#ifdef _AAS_FWDBASE //フォワードベース時処理

	float3 C = normalize(UNITY_MATRIX_V._m20_m21_m22);

	//●まずディレクショナルライトがない場合は環境光から作る● 
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

	//3.0変更
	half3 defaultLightDirection = normalize(lerp(half3(0.0, -1.0, 0.0), half3(0.0, 1.0, 0.0), is_Sky) + half3(C.x, 0.0, C.z));

	half3 WorldlightDirection = WorldSpaceLightDir(v.pos);
	o.L = normalize(lerp(defaultLightDirection, WorldlightDirection, IsLight));



	//●逆光判定と処理●
	//3.0変更
	half Backlight = -dot(V, o.L);
	half LightCorrection = saturate(((Backlight-0.2) * 3) * _BackLightCorrection);
	lightColor = lightColor * (1 - LightCorrection );//逆光時にライトを消す
	Backlight = 1 + saturate(Backlight) * _BackLightCorrection * 3;


	//●リムライト光の計算●
	half BackLightCorrection = saturate((dot(o.L, o.normal) + 0.5) * 2.0);//逆光時にリムライトに足す光
	half3 rim = ShadeSH9(half4(UnityObjectToWorldNormal(-V), 1));//視点の裏側からの環境光をリムライトとする
	o.rim = rim +_LightColor0 * LightCorrection * 2 * BackLightCorrection;//▼リムライトの出力

	//●普通に取得する環境光●
	half3 ambientsh = ShadeSH9(half4(o.normal, 1));//ごく普通に取得する通常の環境光


	half3 ambient = saturate(lerp(defaultAmbientColor, ambientsh, LightPower * (1 - LightCorrection)));//信用できない光源の場合は上で作った環境光を入れる


	//●ForwardAddから漏れた分の光源の計算●
#ifdef VERTEXLIGHT_ON
	float3 worldPos = mul(unity_ObjectToWorld, v.pos).xyz;

	ambient += Shade4PointLights(
		unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
		unity_LightColor[0].rgb, unity_LightColor[1].rgb,
		unity_LightColor[2].rgb, unity_LightColor[3].rgb,
		unity_4LightAtten0, worldPos, o.normal);
#endif 


	//●アンビエントとライトが1を超えた場合の処理 割り算使いにくいのでめんどくさい●
	half3 protrudeRGB = lightColor + ambient;
	float protrude = 1 - saturate(max(protrudeRGB.r, max(protrudeRGB.g, protrudeRGB.b)) - 1) * 0.5;

	ambient = ambient * protrude;
	o.light = half4(lightColor * protrude, Backlight );//▼ライトの出力
	//o.light = lightColor * protrude;
	o.ambient = ambient;//▼環境光の出力
#else //FWDADD時の処理
	o.L = normalize(WorldSpaceLightDir(v.pos));

	half Backlight = -dot(V, o.L);
	half LightCorrection = saturate(((Backlight - 0.2) * 3) * _BackLightCorrection);
	half3 lightColor = _LightColor0 * (1 - LightCorrection );//逆光時にライトを消す
	Backlight = 1 + saturate(Backlight) * _BackLightCorrection * 2;
	o.light = half4(lightColor, Backlight);//▼ライトの出力
	//o.light = lightColor;
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
	o.light = o.light * v.color.g;
#ifdef _AAS_FWDBASE
	o.rim = o.rim* v.color.g;
	o.ambient = o.ambient * (0.5 + v.color.g * 0.5);
#endif


	return o;
}

half4 frag(v2f i) : SV_Target
{
#ifdef _AAS_SEISO
	float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
	float depth = abs(i.pos.z);
	return half4(depth, depth, depth, 1);
#endif
	half3 L = i.L;
	half3 N = normalize(i.normal);
	half3 V = i.V;
	half3 H = normalize(L + V);

	half3 lightcolor = i.light.rgb;



	half4 TexC = tex2D(_MainTex, i.uv);//テクスチャからピクセルに当たる色を取得
#ifndef _AAS_NUM
	half4 TexM = tex2D(_MaterialTex, i.uv);//テクスチャから質感を取得


	half shadowadd = TexM.r *2 -1;//陰の位置
	half gloss = (TexM.g - 0.5) * 2;//光沢

#ifdef _AAS_TIGHTS
	half denier = TexM.b; //タイツを使う場合
#endif
#ifdef _AAS_BEKKAKU
	half bekkaku = (TexM.b - 0.5) * 2;//タイツ機能を使わない場合
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
	half nl = dot(N, L);
	half ddnl = abs(ddx(nl)) + abs(ddy(nl));
	half Nnl = nl + ddnl;
	half2 AAd = normalize(half2(abs(nl), abs(Nnl)));
	half lt = saturate(saturate(step(0, nl) + step(0, Nnl) * AAd.y) + shadowadd);


	half lgloss = saturate(gloss);
	half matte = saturate(-gloss);

	half3 Light = lightcolor * (1 - matte) * lt;//ライトの計算　マットな場合ライトの影響を下げる


	//リムライトの計算　
	half rnl = dot(V, N);

#ifdef _AAS_TIGHTS //Tightsの計算　リムライトの計算したついでに透け度の計算を行う

	half tights = saturate((rnl - denier) * _TSharp * (1 - denier * 0.5));//質感テクスチャのB値に応じて透けないテクスチャと透けてるテクスチャのブレンド値を計算する
	TexC = lerp(TexC,tex2D(_TightsTex, i.uv), tights);//透け側テクスチャを拾ってきてブレンドする
#endif


#ifdef _AAS_FWDBASE
	half3 rim = i.rim * saturate((0.3 - rnl)*10 ) * lgloss;//リムライトの計算
#endif

	//ハイライトの光を計算する
	half snl = saturate(dot(N, H));

#ifdef _AAS_BEKKAKU //BEKKAKU時
	half bekkakuX = i.bekkaku.x;
	half bekkakuY = i.bekkaku.y;
	half snlb = 1 - abs(lerp(bekkakuY, bekkakuX, step(0, bekkaku)));//BEKKAKUの計算
	snl = lerp(snl, snlb, abs(bekkaku));//通常のと混ぜることにより光沢をUVいずれかの方向に伸ばす
#endif

	//スペキュラーの計算
	half a = lgloss * lgloss * _SpecularSharp + 1;
	half b = lgloss * 4;
	half snl_t = saturate(snl * a - a + 1 + b) * lgloss;



	half3 specular = snl_t * lightcolor;//ライトの光と掛けてハイライトの光を導き出す

	//マットな場合環境光にライトを足して平均化する
#ifdef _AAS_FWDBASE
	half halfLight = (i.light + i.ambient) * 0.5;
	half3 TotalLight = lerp(i.ambient, halfLight, matte) + Light + specular * (1 - lgloss); //ライトの合計値
	half3 tmpColor = TexC * TotalLight + specular * lgloss * lt + rim;//いったんピクセルの色を作るテクスチャの色と光の色を乗算してピクセルの色を出力する　ハイライトは加算する

	//彩度補正
	half LightPow = max(max(TotalLight.r, TotalLight.g), TotalLight.b);
	half Correction = saturate(1.0 - LightPow);//光が弱いほど彩度を調整する
	half Brightness = (tmpColor.r + tmpColor.g + tmpColor.b) * 0.333;//RGBの明るさ平均値を求める
	half3 CorrectionColor = (tmpColor - half3(Brightness, Brightness, Brightness)) * Correction * _ShadowSaturationCorrection;//平均値と比較し色ウェイ分を取り出す


	tmpColor = tmpColor + CorrectionColor;

	//エミッション
	half3 outColor = tmpColor * (1 - saturate(Emission)) + TexC * Emission;
#endif

#ifdef _AAS_FWDADD
	UNITY_LIGHT_ATTENUATION(attenuation, i, i.worldPos); //追加　光源との距離から光の減衰量をattenuationに入れる
	half3 TotalLight = (Light + specular * lgloss * lt + _LightColor0 * 0.1)* attenuation;
	half3 outColor = TexC * TotalLight + specular * lgloss * attenuation;
#endif



	return half4(outColor,1);
}