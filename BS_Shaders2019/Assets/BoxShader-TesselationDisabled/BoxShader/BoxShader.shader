//MIT License
//2019/01/27 by,hhotatea

Shader "HOTATE/BoxShader/BoxShader"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", int) = 2
		_MainTex ("Texture", 2D) = "white" {}
		_color ("Color",color) = (1.0,1.0,1.0,1.0)
		_texmode ("TextureMode", Range(0,1)) = 1.0
		_dif ("StanderdBOXSize", float) = 0.1
		_difpow ("BOXSizeChange", float) = 1
		_boxscale ("BoxScale",vector) = (1.0,1.0,1.0,0.0)
		[Space(40)]
		_RimEffect ("Rim Effect", Range(-1, 10)) = 0.5
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		[Space(40)]
		_MainPoly ("LegasyPoly", Range(0, 1)) = 0
		[Space(80)] 
		[Toggle(Unlit)] _Unlit ("Unlit", float) = 1.
		[Space(20)] 
        [Header(Ambient)]
        _Ambient ("Intensity", Range(0., 1.)) = 0.1
        _AmbColor ("Color", color) = (1., 1., 1., 1.)
		[Space(20)] 
        [Header(Diffuse)]
        _Diffuse ("Val", Range(0., 1.)) = 1.
        _DifColor ("Color", color) = (1., 1., 1., 1.)
		[Space(20)] 
        [Header(Specular)]
        [Toggle] _Spec("Enabled", float) = 0.
        _Shininess ("Shininess", Range(0.1, 100)) = 1.
        _SpecColor ("Specular color", color) = (1., 1., 1., 1.)
		[Space(20)] 
		_metallic ("Merallic",Range(0.0,1.0)) = 0.0
		[Space(80)]
		_NormalEx ("Normal Extrusion", Range(0, 5)) = 0
		_Grabity("Gravity(X,Y,Z)",Vector) = (0,1,0,0)
		_FloorHight("FloorHight(X,Y,Z)",Vector) = (-10000000000,-10000000000,-10000000000,0)
		_CeilingHight("CeilingHight(X,Y,Z)",Vector) = (10000000000,10000000000,10000000000,0)
		[Space(80)]
		_RotateMap ("RotatewMap", 2D) = "white" {}
			_Rotateuv ("RotateUVSpeed(X,Y)",Vector) = (1,0,0,0)
			_RotationAxis ("RotationAxis(X,Y,Z)", Vector) = (1,0.5,0,0)
			_RotatePower ("RotateSpeed", Range(0,100)) = 0
		[Space(80)]
		_VoxelSizeMap ("VoxelSizeMap", 2D) = "black" {}
			_sizeuv ("VoxelSizeUV(X,Y)", Vector) = (1,1,0)
			_sizepower ("VoxSize Power", Range(0,1)) = 0.1
		[Space(80)]
    	_PolygonMap ("Polygon Extrusion", 2D) = "black" {}
    		_poluvspeed ("PolyUVSpeed(X,Y)",Vector) = (1,0,0,0)
    		_PolygonEx ("Extrusion Power", Range(0,1)) = 0
		[Space(80)]
		_EmissionMap ("EmissionMap", 2D) = "black" {}
			_Emissionuvspeed ("EmissionUVSpeed",Vector) = (1,0,0,0)
			_EmissionColor ("Emission Color", Color) = (1,1,1,1)
			_EmissionPower ("Emission Power", Range(-10.0,10.0)) = 0.5
		[Space(80)]
		_SubTex ("SubTexture", 2D) = "black" {}
		_SubTexP("SubTexturePower", Range(0,1)) = 0
		[Toggle(Cutout)] _Cutout ("Cutout", float) = 0.
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
		Cull [_CullMode]
		LOD 100

		Pass
		{
			CGPROGRAM

			#pragma shader_feature Tesselation
			#pragma shader_feature Unlit
			#pragma shader_feature Cutout

			#pragma target 5.0

			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag

			#define INPUT_PATCH_SIZE 3
			#define OUTPUT_PATCH_SIZE 3

			uniform sampler2D _MainTex;	float4 _MainTex_ST;
			uniform sampler2D _SubTex;	float4 _SubTex_ST;
			uniform float4 _color;
			uniform float _dif;
			uniform float _difpow;
			uniform float4 _boxscale;
			uniform float _texmode;
			uniform half _BOXSize;
			uniform half _SubTexP;
			uniform half _MainPoly;
			uniform float _RimEffect;
			uniform float4 _RimColor;
			uniform sampler2D _EmissionMap;
			uniform float4 _EmissionColor;
			uniform half _EmissionPower;
			uniform float4 _Emissionuvspeed;
			uniform float _metallic;
            uniform fixed4 _LightColor0;
            uniform fixed _Diffuse;
            uniform fixed4 _DifColor;
            uniform fixed _Shininess;
            uniform fixed4 _SpecColor;
            uniform fixed _Ambient;
            uniform fixed4 _AmbColor;
			uniform half _PolygonEx;
			uniform float4 _poluvspeed;
			uniform float4 _RotationAxis;
			uniform float _RotatePower;
			uniform float4 _Rotateuv;
			uniform float4 _sizeuv;
			uniform fixed _sizepower;
			uniform float _NormalEx;
			uniform float4 _TessFactor;
			uniform float4 _Grabity;
			uniform float4 _FloorHight;
			uniform float4 _CeilingHight;
			uniform float _autoTess;
			uniform float _autoTessPow;
			uniform float _Tesselationmode;
			uniform sampler2D _PolygonMap;
			uniform sampler2D _RotateMap;
			uniform sampler2D _VoxelSizeMap;

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2h
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct h2d_main
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct h2d_const
			{
				float tess_factor[3] : SV_TessFactor;
				float InsideTessFactor : SV_InsideTessFactor;
			};

			struct d2g
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct g2f
			{
				float4 vertex : SV_Position;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
				float3 normal : NORMAL;
                float3 worldNormal : TEXCOORD3;
				float3 viewDir : TEXCOORD4;
			};

			float3 translation(float4 input, float3 vect)
			{
				float4x4 motion = float4x4(
					1, 0, 0, vect.x,
					0, 1, 0, vect.y,
					0, 0, 1, vect.z,
					0, 0, 0, 1
				);
				float4 output = mul(motion,input);
				output /= output.w;
				return float3(output.x,output.y,output.z);
			}

			float3 rotate(float3 input, float angle, float3 axis){
				axis = normalize(axis);
				float3x3 rotation = float3x3(
					cos(angle)+axis.x*axis.x*(1-cos(angle)),
					axis.x*axis.y*(1-cos(angle))+axis.z*sin(angle),
					axis.z*axis.x*(1-cos(angle))-axis.y*sin(angle),

					axis.x*axis.y*(1-cos(angle))-axis.z*sin(angle),
					cos(angle)+axis.y*axis.y*(1-cos(angle)),
					axis.y*axis.z*(1-cos(angle))+axis.x*sin(angle),

					axis.z*axis.x*(1-cos(angle))+axis.y*sin(angle),
					axis.y*axis.z*(1-cos(angle))-axis.x*sin(angle),
					cos(angle)+axis.z*axis.z*(1-cos(angle))
				);
				float3 output = mul(rotation,input);
				return output;
			}

			float3 rotation(float3 input,float3 zero,float4 axis){
				float angle = _Time.x*length(axis)*_RotatePower;
				float3 output = translation(float4(input,1),-zero);
				output = rotate(output,angle,axis);
				output = translation(float4(output,1),zero);
				normalize(output);
				return output;
			}

			g2f calctriangle(d2g input,float3 pos,float2 wuv,float2 uv,float3 onormal){
				g2f o;
				o.vertex = UnityObjectToClipPos(pos);
				o.uv = lerp(wuv,input.uv,_texmode);
				o.uv2 = uv;
				o.worldPos = mul(unity_ObjectToWorld,float4(pos.xyz,1.0));
				o.normal = lerp(onormal,input.normal,_MainPoly);
				o.worldNormal = normalize(mul(o.normal, (float3x3)unity_WorldToObject));
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - o.worldPos.xyz);
				return o;
			}

			g2f g2flerp(g2f first,g2f second,float index){
				g2f o;
				o.vertex = lerp(first.vertex,second.vertex,index);
				o.uv = lerp(first.uv,second.uv,index);
				o.uv2 = lerp(first.uv2,second.uv2,index);
				o.worldPos = lerp(first.worldPos,second.worldPos,index);
				o.normal = lerp(first.normal,second.normal,index);
				o.worldNormal = lerp(first.worldNormal,second.worldNormal,index);
				o.viewDir = lerp(first.viewDir,second.viewDir,index);
				return o;
			}

			v2h vert (appdata v) {
				v2h o;
				o.vertex = v.vertex;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;
				return o;
			}

			[maxvertexcount(50)]
			void geom(triangle d2g input[3], inout TriangleStream<g2f> outStream)
			{
				g2f o;
				g2f o1;
				float3 wp = (input[0].vertex+input[1].vertex+input[2].vertex)/3; //重心を計算

				float4 rotatex = tex2Dlod(_RotateMap,float4(saturate(input[0].uv.x+_Time.y*_Rotateuv.x),saturate(input[0].uv.y+_Time.y*_Rotateuv.y),0,0)); //回転軸取得
				rotatex.x *= _RotationAxis.x; rotatex.y *= _RotationAxis.y; rotatex.z *= _RotationAxis.z;
				float d = pow(distance(input[0].vertex,input[1].vertex)+distance(input[1].vertex,input[2].vertex)+distance(input[2].vertex,input[0].vertex),_difpow) *_dif; //BOXサイズ取得
				d += length(tex2Dlod(_VoxelSizeMap,float4(input[0].uv.x+_Time.y*_sizeuv.x,input[0].uv.y+_Time.y*_sizeuv.y,0,0))) *_dif*_sizepower; //BOXサイズマップ
				d = lerp(d,0.0,_MainPoly);
				float3 Emissionc = tex2Dlod(_EmissionMap,float4(input[0].uv.x+_Time.y*_Emissionuvspeed.x,input[0].uv.y+_Time.y*_Emissionuvspeed.y,0,0)) *_EmissionColor*_EmissionPower; //Emissionマップ
				float polyex = tex2Dlod(_PolygonMap,float4(input[0].uv.x+_Time.y*_poluvspeed.x,input[0].uv.y+_Time.y*_poluvspeed.y,0,0)) *_PolygonEx; //ポリゴンの爆発マップ

				float3 normal = (input[0].normal + input[1].normal + input[2].normal)/3;//normalize(cross(input[0].vertex-input[1].vertex,input[0].vertex-input[2].vertex)); //法線方向取得
				wp.x += normal.x * _NormalEx -_Grabity.x*_NormalEx*_NormalEx; wp.y += normal.y * _NormalEx -_Grabity.y*_NormalEx*_NormalEx; wp.z += normal.z * _NormalEx -_Grabity.z*_NormalEx*_NormalEx; //法線方向に重心を動かす
				wp.x = max(wp.x,_FloorHight.x); wp.y = max(wp.y,_FloorHight.y); wp.z = max(wp.z,_FloorHight.z); //床の適応
				wp.x = min(wp.x,_CeilingHight.x); wp.y = min(wp.y,_CeilingHight.y); wp.z = min(wp.z,_CeilingHight.z); //天井の適応
				float2 wuv = (input[0].uv+input[1].uv+input[2].uv)/3;
				float3 pos;	float3 onormal;

							//left
							onormal = normalize(mul((float3x3)unity_ObjectToWorld, rotation(float3(-1,0,0),wp,rotatex)));
							pos = rotation(float3(wp.x-d*_boxscale.x-polyex,wp.y-d*_boxscale.y,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[1],pos,wuv,float2(1,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x-d*_boxscale.x-polyex,wp.y-d*_boxscale.y,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(0,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x-d*_boxscale.x-polyex,wp.y+d*_boxscale.y,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(1,1),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x-d*_boxscale.x-polyex,wp.y+d*_boxscale.y,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[2],pos,wuv,float2(0,1),onormal); outStream.Append(o);
							outStream.RestartStrip();

							//right
							onormal = normalize(mul((float3x3)unity_ObjectToWorld, rotation(float3(1,0,0),wp,rotatex)));
							pos = rotation(float3(wp.x+d*_boxscale.x+polyex,wp.y-d*_boxscale.y,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(0,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x+polyex,wp.y+d*_boxscale.y,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[2],pos,wuv,float2(0,1),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x+polyex,wp.y-d*_boxscale.y,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[1],pos,wuv,float2(1,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x+polyex,wp.y+d*_boxscale.y,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(1,1),onormal); outStream.Append(o);
							outStream.RestartStrip();

							//bottom
							onormal = normalize(mul((float3x3)unity_ObjectToWorld, rotation(float3(0,1,0),wp,rotatex)));
							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y-d*_boxscale.y-polyex,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(0,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y-d*_boxscale.y-polyex,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[2],pos,wuv,float2(0,1),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y-d*_boxscale.y-polyex,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[1],pos,wuv,float2(1,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y-d*_boxscale.y-polyex,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(1,1),onormal); outStream.Append(o);
							outStream.RestartStrip();

							//top
							onormal = normalize(mul((float3x3)unity_ObjectToWorld, rotation(float3(0,1,0),wp,rotatex)));
							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y+d*_boxscale.y+polyex,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(0,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y+d*_boxscale.y+polyex,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[2],pos,wuv,float2(0,1),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y+d*_boxscale.y+polyex,wp.z-d*_boxscale.z),wp,rotatex); o = calctriangle(input[1],pos,wuv,float2(1,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y+d*_boxscale.y+polyex,wp.z+d*_boxscale.z),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(1,1),onormal); outStream.Append(o);
							outStream.RestartStrip();

							//back
							onormal = normalize(mul((float3x3)unity_ObjectToWorld, rotation(float3(0,0,1),wp,rotatex)));
							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y-d*_boxscale.y,wp.z-d*_boxscale.z-polyex),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(0,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y+d*_boxscale.y,wp.z-d*_boxscale.z-polyex),wp,rotatex); o = calctriangle(input[2],pos,wuv,float2(0,1),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y-d*_boxscale.y,wp.z-d*_boxscale.z-polyex),wp,rotatex); o = calctriangle(input[1],pos,wuv,float2(1,0),onormal); outStream.Append(o);
							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y+d*_boxscale.y,wp.z-d*_boxscale.z-polyex),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(1,1),onormal); outStream.Append(o);
							outStream.RestartStrip();

							//front
							onormal = normalize(mul((float3x3)unity_ObjectToWorld, rotation(float3(0,0,-1),wp,rotatex)));
							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y-d*_boxscale.y,wp.z+d*_boxscale.z+polyex),wp,rotatex); o = calctriangle(input[1],pos,wuv,float2(1,0),onormal);
							o1.normal = input[0].normal; o1 = calctriangle(input[0],input[0].vertex,wuv,float2(0,0),onormal); o1.normal = input[1].normal;
							outStream.Append(g2flerp(o,o1,_MainPoly));

							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y-d*_boxscale.y,wp.z+d*_boxscale.z+polyex),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(0,0),onormal);
							o1.normal = input[1].normal; o1 = calctriangle(input[1],input[1].vertex,wuv,float2(1,0),onormal); o1.normal = input[0].normal;
							outStream.Append(g2flerp(o,o1,_MainPoly));

							pos = rotation(float3(wp.x-d*_boxscale.x,wp.y+d*_boxscale.y,wp.z+d*_boxscale.z+polyex),wp,rotatex); o = calctriangle(input[0],pos,wuv,float2(1,1),onormal);
							o1.normal = input[0].normal; o1 = calctriangle(input[2],input[2].vertex,wuv,float2(0,1),onormal); o1.normal = input[2].normal;
							outStream.Append(g2flerp(o,o1,_MainPoly));
							
							pos = rotation(float3(wp.x+d*_boxscale.x,wp.y+d*_boxscale.y,wp.z+d*_boxscale.z+polyex),wp,rotatex); o = calctriangle(input[2],pos,wuv,float2(0,1),onormal);
							o1.normal = input[2].normal; o1 = calctriangle(input[2],input[2].vertex,wuv,float2(0,1),onormal); o1.normal = input[2].normal;
							outStream.Append(g2flerp(o,o1,_MainPoly));

							outStream.RestartStrip();
			}

			fixed4 frag (g2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv) * _color;
			 	col += tex2D(_EmissionMap,float2(i.uv.x+_Time.y*_Emissionuvspeed.x,i.uv.y+_Time.y*_Emissionuvspeed.y))*_EmissionColor*_EmissionPower;
				float val = 1 - abs(dot(normalize(i.viewDir),normalize(i.normal)));
				col += pow(val,2.5) * _RimColor * _RimEffect;
				i.uv2 = TRANSFORM_TEX(i.uv2, _SubTex);
				fixed4 sub = tex2D(_SubTex, i.uv2);
				#ifdef Cutout
					clip(sub.a-0.5);
				#endif
				col += sub * _SubTexP;
				#ifdef Unlit
				#else
					float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
					float3 worldNormal = normalize(i.worldNormal);
					fixed4 amb = _Ambient * _AmbColor;
					fixed4 NdotL;
					NdotL = max(0., dot(i.worldNormal, lightDir) * _LightColor0);
					fixed4 dif = NdotL * _Diffuse * _LightColor0 * _DifColor;
					fixed4 light = dif + amb;
					#if _SPEC_ON
					float3 HalfVector = normalize(lightDir + viewDir);
					float NdotH = max(0., dot(worldNormal, HalfVector));
					fixed4 spec = pow(NdotH, _Shininess) * _LightColor0 * _SpecColor;
					light += spec;
					#endif
					col.rgb *= light.rgb;
				#endif

                half3 reflDir = reflect(-i.viewDir, i.worldNormal);
                half4 refColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflDir, 0);
                refColor.rgb = DecodeHDR(refColor, unity_SpecCube0_HDR);

				return lerp(col,refColor,_metallic);
			}
			ENDCG
		}
	}
}
