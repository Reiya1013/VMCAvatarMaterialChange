//AASD_ShadowCast.cginc
//AAShader4 ShadowCast

float _BiginShadow;

struct appdata
{

	
	float4 vertex : POSITION;
	float3 normal : NORMAL;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};
struct v2f {
	V2F_SHADOW_CASTER;
	UNITY_VERTEX_OUTPUT_STEREO
};

v2f vert(appdata v)
{
	v2f o;
	UNITY_SETUP_INSTANCE_ID(v); //挿入
	UNITY_INITIALIZE_OUTPUT(v2f, o); //挿入
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o); //挿入
#ifdef _AAS_SHADOWRECEIVE
	o.discardcolor = v.color.b;
#endif
	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
		return o;
}

float4 frag(v2f i) : SV_Target
{

	
	SHADOW_CASTER_FRAGMENT(i)

}