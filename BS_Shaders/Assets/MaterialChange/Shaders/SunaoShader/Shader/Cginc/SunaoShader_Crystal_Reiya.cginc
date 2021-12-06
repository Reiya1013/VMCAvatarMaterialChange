//--------------------------------------------------------------
//              Sunao Shader Crystal
//                      Copyright (c) 2021 Reiya1013
//--------------------------------------------------------------



struct appdata
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float4 normal :NORMAL;
    float3 tangent :tangent;
};

struct v2h {
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float4 normal :NORMAL;
    float3 tangent :tangent;
};
struct h2d_main {
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float4 normal :NORMAL;
    float3 tangent :tangent;

};

struct h2d_const {
	float tess_factor[3] : SV_TessFactor;
	float InsideTessFactor : SV_InsideTessFactor;
};

struct d2g {
	float4 vertex : SV_POSITION;
	float2 uv : TEXCOORD0;
	float4 normal :NORMAL;
};

struct g2f
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal :NORMAL;
    float nCrystal: TEXCOORD1;
    float4 vertexW : TEXCOORD2;
    float h : TEXCOORD3;
    float maxh : TEXCOORD4;
};

			
			

sampler2D _MainTex;
float4 _MainTex_ST;

sampler2D _MaskTex;

sampler2D _HeightTex;
float _Height;
float _CrystalLength;
float _CrystalSize;
float _Sharpness;
float4 _Color;
float4 _TessFactor;
float _AlphaMin;
float _White;
float _Delta;
float _Crystal;

v2h vert (appdata v)
{
	v2h o = (v2h)0;
	o.vertex = v.vertex;
	o.uv = v.uv;
	o.normal = v.normal;
	return o;
}

h2d_const HSConst(InputPatch<v2h, INPUT_PATCH_SIZE> i) {
	h2d_const o = (h2d_const)0;
	o.tess_factor[0] = _TessFactor.x;
	o.tess_factor[1] = _TessFactor.y;
	o.tess_factor[2] = _TessFactor.z;
	o.InsideTessFactor = _TessFactor.w;
	return o;
}

[domain("tri")]
[partitioning("integer")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(OUTPUT_PATCH_SIZE)]
[patchconstantfunc("HSConst")]
h2d_main HS(InputPatch<v2h, INPUT_PATCH_SIZE> i, uint id:SV_OutputControlPointID) {
	h2d_main o = (h2d_main)0;
	o.vertex = i[id].vertex;
	o.uv = i[id].uv;
	o.normal = i[id].normal;
	return o;
}

[domain("tri")]
d2g DS(h2d_const hs_const_data, const OutputPatch<h2d_main, OUTPUT_PATCH_SIZE> i, float3 bary:SV_DomainLocation) {
	d2g o = (d2g)0;
	float3 pos = i[0].vertex * bary.x + i[1].vertex * bary.y + i[2].vertex * bary.z;
	float2 uv = i[0].uv * bary.x + i[1].uv * bary.y + i[2].uv * bary.z;
	float3 normal = i[0].normal * bary.x + i[1].normal * bary.y + i[2].normal * bary.z;
    float3 tangent = i[0].tangent * bary.x + i[1].tangent * bary.y + i[2].tangent * bary.z;

	o.vertex = float4(pos, 1);
	o.uv = uv;
	o.normal = float4(normal,1);
	return o;
}


float3 getNormal(float3 a,float3 b,float3 c)
{
	float3 a2b = (b - a);
	float3 a2c = (c - a);
	return normalize(cross(a2b, a2c));
}

float rand(float2 co){
	return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
}

float rand(float3 co){
	return frac(sin(dot(co.xyz ,float3(12.9898,78.233,46.544))) * 43758.5453);
}

float3 reflection(g2f i, float3 col, float3 SpecularCol, float Shiness)
{
		UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW.xyz)
		float3 view = normalize(_WorldSpaceCameraPos - i.vertexW.xyz);
		float3 normal = normalize(i.normal);
		float3 light = normalize((_WorldSpaceLightPos0.w == 0) ? _WorldSpaceLightPos0.xyz : _WorldSpaceLightPos0 - i.vertexW);
					
		float3 rflt = normalize(reflect(-light, normal));
		//反射光ベクトルを検出し正規化している
		float diffuse = saturate(dot(normal, light));
		float specular = pow(saturate(dot(view, rflt)), Shiness);
		float3 ambient = ShadeSH9(half4(normal, 1));
		fixed3 color = diffuse * col * _LightColor0
			+ specular * SpecularCol * _LightColor0;
		color += ambient * col;
		return color;
}

float perlinNoise(fixed2 st) 
{
    fixed2 p = floor(st);
    fixed2 f = frac(st);
    fixed2 u = f*f*(3.0-2.0*f);

    float v00 = rand(p+fixed2(0,0));
    float v10 = rand(p+fixed2(1,0));
    float v01 = rand(p+fixed2(0,1));
    float v11 = rand(p+fixed2(1,1));

    return lerp( lerp( dot( v00, f - fixed2(0,0) ), dot( v10, f - fixed2(1,0) ), u.x ),
                    lerp( dot( v01, f - fixed2(0,1) ), dot( v11, f - fixed2(1,1) ), u.x ), 
                    u.y)+0.5f;
}

[maxvertexcount(56) ]
void geom(triangle d2g ip[3], inout TriangleStream<g2f> OutputStream)
{

    g2f o = (g2f)0;

    o.uv = (ip[0].uv + ip[1].uv + ip[2].uv)/3.;

    float3 p0 = ip[0].vertex.xyz;
    float3 p1 = ip[1].vertex.xyz;
    float3 p2 = ip[2].vertex.xyz;

    float3 needle = float3(1./3.,1./3.,1./3.);
    float3 tri =  float3(2./4.,1./4.,1./4.);
    float3 itri = float3(2./5.,2./5.,1./5.);

                
    float3 seed = float3(o.uv,3421.5);;
                
    float3 dir = ( getNormal(p0,p1,p2));
                
    float3 random = max(rand(seed),0.5);
    float3 size1 = (random - 1/2)*_CrystalSize;
    float3 size2 = (rand(size1) - 1/2) * _CrystalSize;
                
    float len =_CrystalLength * max(length(random),0.01);
    o.maxh = len;

    //ちょっと沈める
    float delta = -1 * _Delta;

    float3 pp0 = (p0*needle.x  + p1*needle.y + p2*needle.z ) + dir * delta;
    float3 pp1 = (p0*tri.x   + p1*tri.y  + p2*tri.z) + dir * delta;
    float3 pp2 = (p0*itri.x  + p1*itri.y + p2*itri.z ) + dir * delta;
    float3 pp3 = (p0*tri.y   + p1*tri.x  + p2*tri.z ) + dir * delta;
    float3 pp4 = (p0*itri.z  + p1*itri.x + p2*itri.y ) + dir * delta;
    float3 pp5 = (p0*tri.z   + p1*tri.y  + p2*tri.x ) + dir * delta;
    float3 pp6 = (p0*itri.y  + p1*itri.z + p2*itri.x ) + dir * delta;

    float3 pv1 = normalize(pp1-pp0);
    float3 pv2 = normalize(pp2-pp0);
    float3 pv3 = normalize(pp3-pp0);
    float3 pv4 = normalize(pp4-pp0);
    float3 pv5 = normalize(pp5-pp0);
    float3 pv6 = normalize(pp6-pp0);

    pp1 += pv1 * size1;
    pp2 += pv2 * size1;
    pp3 += pv3 * size1;
    pp4 += pv4 * size2;
    pp5 += pv5 * size2;
    pp6 += pv6 * size2;

    pp0 = (pp1+pp2+pp3+pp4+pp5+pp6)/6.;

    float3 pp0d = pp0 + dir * (len + _Sharpness);
    float3 pp1d = pp1 + dir * len;
    float3 pp2d = pp2 + dir * len;
    float3 pp3d = pp3 + dir * len;
    float3 pp4d = pp4 + dir * len;
    float3 pp5d = pp5 + dir * len;
    float3 pp6d = pp6 + dir * len;

    float4 v4o = float4(0,0,0,0);
    float3 normal = float3(0,0,0);
                

    //1
    normal = getNormal(pp1,pp2,pp1d);
    v4o = float4(pp1,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp2,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp1d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    normal = getNormal(pp1d,pp2,pp2d);
    v4o = float4(pp2,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp1d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp2d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    o.nCrystal = 0;
    OutputStream.RestartStrip();

    //2
    normal = getNormal(pp2,pp3,pp2d);
    v4o = float4(pp2,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp3,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp2d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    normal = getNormal(pp2d,pp3,pp3d);
    v4o = float4(pp3,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp3d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp2d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    //3
    normal = getNormal(pp3,pp4,pp3d);
    v4o = float4(pp3,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp4,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp3d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    normal = getNormal(pp3d,pp4,pp4d);
    v4o = float4(pp4,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp4d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp3d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    //4
    normal = getNormal(pp4,pp5,pp4d);
    v4o = float4(pp4,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp5,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp4d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    normal = getNormal(pp4d,pp5,pp5d);
    v4o = float4(pp5,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp5d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp4d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    //5
    normal = getNormal(pp5,pp6,pp5d);
    v4o = float4(pp5,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp6,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp5d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    normal = getNormal(pp5d,pp6,pp6d);
    v4o = float4(pp6,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp6d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp5d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    //6
    normal = getNormal(pp6,pp1,pp6d);
    v4o = float4(pp6,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp1,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp6d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    normal = getNormal(pp6d,pp1,pp1d);
    v4o = float4(pp1,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = 0;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp1d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp6d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();


    //top1
    normal = getNormal(pp1d,pp2d,pp0d);
    v4o = float4(pp1d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp2d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp0d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len + _Sharpness;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    //top2
    normal = getNormal(pp2d,pp3d,pp0d);
    v4o = float4(pp2d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp3d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp0d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len + _Sharpness;
    o.vertexW = v4o;
    OutputStream.Append(o);

    OutputStream.RestartStrip();

    //top3
    normal = getNormal(pp3d,pp4d,pp0d);
    v4o = float4(pp3d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp4d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp0d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len + _Sharpness;
    o.vertexW = v4o;
    OutputStream.Append(o);

    //top4
    normal = getNormal(pp4d,pp5d,pp0d);
    v4o = float4(pp4d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp5d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp0d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len + _Sharpness;
    o.vertexW = v4o;
    OutputStream.Append(o);

    //top5
    normal = getNormal(pp5d,pp6d,pp0d);
    v4o = float4(pp5d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp6d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp0d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len + _Sharpness;
    o.vertexW = v4o;
    OutputStream.Append(o);

    //top6
    normal = getNormal(pp6d,pp1d,pp0d);
    v4o = float4(pp6d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp1d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len;
    o.vertexW = v4o;
    OutputStream.Append(o);
    v4o = float4(pp0d,1);
    o.normal = normal;
    o.vertex = UnityObjectToClipPos(v4o);
    o.nCrystal = 0;
    o.h = len + _Sharpness;
    o.vertexW = v4o;
    OutputStream.Append(o);
}
            
fixed4 frag (g2f i) : SV_Target
{
    clip(_Crystal-1);
    fixed4 mask = tex2D(_MaskTex,i.uv);
    float cl = (mask.g  < 0.5) + (i.nCrystal > 0.5);
    clip(cl * -1);
                
    float mh = (i.maxh+_Sharpness);
    float ihr = (i.h)/(i.maxh+_Sharpness);
                
    float3 ccolor = lerp(float3(1,1,1) , _Color , (i.h+_White)/(i.maxh+_Sharpness));
    fixed3 col = ccolor;
    float3 specularCol = 1;

    float3 CrystalCol = reflection(i,col,specularCol,5);
    col.rgb = CrystalCol;

    float alpha = 1-ihr;
    alpha = clamp( alpha,_AlphaMin,1);
    return float4(col,alpha);
}