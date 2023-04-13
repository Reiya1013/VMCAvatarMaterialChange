//2018/11/28/hhotatea
//This Shader is released under the MIT License, see LICENSE.txt.
Shader "HOTATE/Teleport/TeleportCutout"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color",COLOR) = (1.0,1.0,1.0,1.0)
		[Toggle(Sign)] _sign ("方向逆転",float) = 0
		[Enum(X,0,Y,1,Z,2)] _dir ("方向", float) = 1
		_Slider ("スライダー",Range(-10,10)) = 0
		_tess ("テッセレーション",float) = 2
		_Size ("ビルボードサイズ",float) = 0.001
		_particle ("パーティクルサイズ",float) = 0.0001
		_fvec ("固定拡散",VECTOR) = (0,1,0,0)
		_svec ("拡大拡散",VECTOR) = (3,0,3,0)
		_noisepower ("ノイズの強さ",float) = 0
		_width ("パーティクル範囲",float) = 1
		_color("スキャン線色",COLOR) = (0,1,1,1)
		[HideInInspector] _sv1 ("調節用数値1",float) = 0.01
		[HideInInspector] _sv2 ("調節用数値2",float) = 0.5
		[HideInInspector] _sv3 ("調節用数値3",float) = 5
		[HideInInspector] _clipvol ("カットアウトしきい値",float) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull off

		Pass
		{
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
    		#pragma hull HS
			#pragma domain DS
			#pragma geometry geom
			#pragma fragment frag

			#pragma shader_feature Sign

			#define INPUT_PATCH_SIZE 3
			#define OUTPUT_PATCH_SIZE 3
			#define SQRT3 1.7320508075688772935274463415059
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

            struct v2h {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

			struct h2d_main
			{
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
			};

			struct h2d_const
			{
				float tess_factor[3] : SV_TessFactor;
				float InsideTessFactor : SV_InsideTessFactor;
			};

			struct d2g
			{
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
			};

			struct g2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float4 wPos : TEXCOORD1;
				float noiseefect : TEXCOORD2;
			};

			sampler2D _MainTex;	float4 _MainTex_ST;
			uniform float4 _Color;
			uniform float _sign;
			uniform float _dir;
			uniform float _Slider;
			uniform float _tess;
			uniform float _Size;
			uniform float _particle;
			uniform float4 _fvec;
			uniform float4 _svec;
			uniform float _noisepower;
			uniform float _width;
			uniform float4 _color;
			uniform float _sv1;
			uniform float _sv2;
			uniform float _sv3;
			uniform float _clipvol;

			// Noise Shader Library for Unity - https://github.com/keijiro/NoiseShader
			//78-
			// Original work (webgl-noise) Copyright (C) 2011 Stefan Gustavson
			// Translation and modification was made by Keijiro Takahashi.
			float3 mod(float3 x, float3 y)
			{
			return x - y * floor(x / y);
			}

			float3 mod289(float3 x)
			{
			return x - floor(x / 289.0) * 289.0;
			}

			float4 mod289(float4 x)
			{
			return x - floor(x / 289.0) * 289.0;
			}

			float4 permute(float4 x)
			{
			return mod289(((x*34.0)+1.0)*x);
			}

			float4 taylorInvSqrt(float4 r)
			{
			return (float4)1.79284291400159 - r * 0.85373472095314;
			}

			float3 fade(float3 t) {
			return t*t*t*(t*(t*6.0-15.0)+10.0);
			}

			// Classic Perlin noise
			float PerlinNoise(float3 P)
			{
			float3 Pi0 = floor(P); // Integer part for indexing
			float3 Pi1 = Pi0 + (float3)1.0; // Integer part + 1
			Pi0 = mod289(Pi0);
			Pi1 = mod289(Pi1);
			float3 Pf0 = frac(P); // Fractional part for interpolation
			float3 Pf1 = Pf0 - (float3)1.0; // Fractional part - 1.0
			float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
			float4 iy = float4(Pi0.y, Pi0.y, Pi1.y, Pi1.y);
			float4 iz0 = (float4)Pi0.z;
			float4 iz1 = (float4)Pi1.z;

			float4 ixy = permute(permute(ix) + iy);
			float4 ixy0 = permute(ixy + iz0);
			float4 ixy1 = permute(ixy + iz1);

			float4 gx0 = ixy0 / 7.0;
			float4 gy0 = frac(floor(gx0) / 7.0) - 0.5;
			gx0 = frac(gx0);
			float4 gz0 = (float4)0.5 - abs(gx0) - abs(gy0);
			float4 sz0 = step(gz0, (float4)0.0);
			gx0 -= sz0 * (step((float4)0.0, gx0) - 0.5);
			gy0 -= sz0 * (step((float4)0.0, gy0) - 0.5);

			float4 gx1 = ixy1 / 7.0;
			float4 gy1 = frac(floor(gx1) / 7.0) - 0.5;
			gx1 = frac(gx1);
			float4 gz1 = (float4)0.5 - abs(gx1) - abs(gy1);
			float4 sz1 = step(gz1, (float4)0.0);
			gx1 -= sz1 * (step((float4)0.0, gx1) - 0.5);
			gy1 -= sz1 * (step((float4)0.0, gy1) - 0.5);

			float3 g000 = float3(gx0.x,gy0.x,gz0.x);
			float3 g100 = float3(gx0.y,gy0.y,gz0.y);
			float3 g010 = float3(gx0.z,gy0.z,gz0.z);
			float3 g110 = float3(gx0.w,gy0.w,gz0.w);
			float3 g001 = float3(gx1.x,gy1.x,gz1.x);
			float3 g101 = float3(gx1.y,gy1.y,gz1.y);
			float3 g011 = float3(gx1.z,gy1.z,gz1.z);
			float3 g111 = float3(gx1.w,gy1.w,gz1.w);

			float4 norm0 = taylorInvSqrt(float4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
			g000 *= norm0.x;
			g010 *= norm0.y;
			g100 *= norm0.z;
			g110 *= norm0.w;

			float4 norm1 = taylorInvSqrt(float4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
			g001 *= norm1.x;
			g011 *= norm1.y;
			g101 *= norm1.z;
			g111 *= norm1.w;

			float n000 = dot(g000, Pf0);
			float n100 = dot(g100, float3(Pf1.x, Pf0.y, Pf0.z));
			float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
			float n110 = dot(g110, float3(Pf1.x, Pf1.y, Pf0.z));
			float n001 = dot(g001, float3(Pf0.x, Pf0.y, Pf1.z));
			float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
			float n011 = dot(g011, float3(Pf0.x, Pf1.y, Pf1.z));
			float n111 = dot(g111, Pf1);

			float3 fade_xyz = fade(Pf0);
			float4 n_z = lerp(float4(n000, n100, n010, n110), float4(n001, n101, n011, n111), fade_xyz.z);
			float2 n_yz = lerp(n_z.xy, n_z.zw, fade_xyz.y);
			float n_xyz = lerp(n_yz.x, n_yz.y, fade_xyz.x);
			return 2.2 * n_xyz;
			}

			float noise(half2 uv)
            {
                return frac(sin(dot(uv, float2(134.5, 256.1))) * 86.97);
            }

			v2h vert (appdata v)
			{
				v2h o;
				o.pos = v.vertex;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			h2d_const HSConst(InputPatch<v2h,INPUT_PATCH_SIZE> i)
			{
				h2d_const o;
				float tessfactor;
				#ifdef Sign
				float minp = min(min( i[0].pos[_dir], i[1].pos[_dir]), i[2].pos[_dir]);
				tessfactor = lerp(1,_tess,step(minp,_Slider));
				#else
				float maxp = max(max( i[0].pos[_dir], i[1].pos[_dir]), i[2].pos[_dir]);
				tessfactor = lerp(1,_tess,step(_Slider,maxp));
				#endif
				o.tess_factor[0] = tessfactor;
				o.tess_factor[1] = tessfactor;
				o.tess_factor[2] = tessfactor;
				o.InsideTessFactor = tessfactor;
				return o;
			}

			[domain("tri")]
			[partitioning("integer")]
			[outputtopology("triangle_cw")]
			[outputcontrolpoints(OUTPUT_PATCH_SIZE)]
			[patchconstantfunc("HSConst")]
			h2d_main HS(InputPatch<v2h, INPUT_PATCH_SIZE> i, uint id:SV_OutputControlPointID)
			{
				h2d_main o = (h2d_main)0;
				o.pos = i[id].pos;
				o.uv = i[id].uv;
				return o;
			}

			[domain("tri")]
			d2g DS(h2d_const hs_const_data, const OutputPatch<h2d_main, OUTPUT_PATCH_SIZE> i, float3 bary:SV_DomainLocation)
			{
				d2g o;
				float3 PosDomain = i[0].pos * bary.x + i[1].pos * bary.y + i[2].pos * bary.z; o.pos = float4( PosDomain, 1);
				o.uv = i[0].uv * bary.x + i[1].uv * bary.y + i[2].uv * bary.z;
				return o;
			}

			#ifdef Sign
            [maxvertexcount(3)]
			void geom(triangle d2g input[3],inout TriangleStream<g2f> outStream)
            {
				g2f output[3] = (g2f[3])0;
				float4 cp = (input[0].pos + input[1].pos + input[2].pos)/3;
				float4 bp = cp;
				bp.x += -_fvec.x * saturate(-cp[_dir]+_Slider+_sv1) + cp.x * _svec.x * saturate(-cp[_dir]+_Slider+_sv1) + PerlinNoise(mul(UNITY_MATRIX_M,cp)).x * saturate(-cp[_dir]+_Slider+_sv1) * _noisepower;
				bp.y += -_fvec.y * saturate(-cp[_dir]+_Slider+_sv1) + cp.y * _svec.y * saturate(-cp[_dir]+_Slider+_sv1) + PerlinNoise(mul(UNITY_MATRIX_M,cp)).x * saturate(-cp[_dir]+_Slider+_sv1) * _noisepower;
				bp.z += -_fvec.z * saturate(-cp[_dir]+_Slider+_sv1) + cp.z * _svec.z * saturate(-cp[_dir]+_Slider+_sv1) + PerlinNoise(mul(UNITY_MATRIX_M,cp)).x * saturate(-cp[_dir]+_Slider+_sv1) * _noisepower;
				float efect = step(cp[_dir],_Slider);
				output[0].wPos = float4(float2(-SQRT3, -1.0)*_Size, 0.0, 0.0);
				output[1].wPos = float4(float2(0.0, 2.0)*_Size, 0.0, 0.0);
				output[2].wPos = float4(float2(SQRT3, -1.0)*_Size, 0.0, 0.0);
				for(int i; i < 3; i++){
					float4 clippos = UnityObjectToClipPos(input[i].pos);
					float4 billbord = mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_MV, bp) + output[i].wPos);
					output[i].pos = lerp(clippos,billbord,efect);
					//output[i].pos = billbord;
					output[i].uv = input[i].uv;
					output[i].noiseefect = -cp[_dir]+_Slider;
					outStream.Append(output[i]);
				}
				outStream.RestartStrip();
			}
			#else
            [maxvertexcount(3)]
			void geom(triangle d2g input[3],inout TriangleStream<g2f> outStream)
            {
				g2f output[3] = (g2f[3])0;
				float4 cp = (input[0].pos + input[1].pos + input[2].pos)/3;
				float4 bp = cp;
				bp.x += _fvec.x * saturate(cp[_dir]-_Slider-_sv1) + cp.x * _svec.x * saturate(cp[_dir]-_Slider-_sv1) + PerlinNoise(mul(UNITY_MATRIX_M,cp)).x * saturate(cp[_dir]-_Slider-_sv1) * _noisepower;
				bp.y += _fvec.y * saturate(cp[_dir]-_Slider-_sv1) + cp.y * _svec.y * saturate(cp[_dir]-_Slider-_sv1) + PerlinNoise(mul(UNITY_MATRIX_M,cp)).x * saturate(cp[_dir]-_Slider-_sv1) * _noisepower;
				bp.z += _fvec.z * saturate(cp[_dir]-_Slider-_sv1) + cp.z * _svec.z * saturate(cp[_dir]-_Slider-_sv1) + PerlinNoise(mul(UNITY_MATRIX_M,cp)).x * saturate(cp[_dir]-_Slider-_sv1) * _noisepower;
				float efect = step(_Slider,cp[_dir]);
				output[0].wPos = float4(float2(-SQRT3, -1.0)*_Size, 0.0, 0.0);
				output[1].wPos = float4(float2(0.0, 2.0)*_Size, 0.0, 0.0);
				output[2].wPos = float4(float2(SQRT3, -1.0)*_Size, 0.0, 0.0);
				for(int i; i < 3; i++){
					float4 clippos = UnityObjectToClipPos(input[i].pos);
					float4 billbord = mul(UNITY_MATRIX_P, mul(UNITY_MATRIX_MV, bp) + output[i].wPos);
					output[i].pos = lerp(clippos,billbord,efect);
					//output[i].pos = billbord;
					output[i].uv = input[i].uv;
					output[i].noiseefect = cp[_dir]-_Slider;
					outStream.Append(output[i]);
				}
				outStream.RestartStrip();
			}
			#endif

			fixed4 frag (g2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				clip(col.a-_clipvol);
				col = lerp(col*_color,col,clamp(pow(i.noiseefect,_sv2),0,1));
				if(i.noiseefect > _sv1*0.1){ 
					float d = length(i.wPos.xy)/_particle;
					clip(0.5 - d*d - i.noiseefect*_width);
					clip(noise(i.uv) - i.noiseefect*_sv3);
				}
				return col*_Color;
			}
			ENDCG
		}
	}
	FallBack "Standard"
}
