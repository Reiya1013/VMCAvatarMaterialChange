//----Gameing
	uniform bool      _GameingEnable;
	uniform float     _GameingSpeed;

//----Teleport
	uniform bool      _TeleportEnable;

//----Disolve
	uniform bool      _DisolveEnable;
	uniform sampler2D _DisolveTex;
	uniform sampler2D _DisolveEmissionMap;
	uniform float4    _DisolveEmissionColor;
	uniform float     _DisolveEmission;
	uniform float     _DisolveThreshold;
	uniform sampler2D _DisolveTimeTex;
	uniform float     _DisolveStartTime;
	uniform float     _DisolveEndTime;
	

//----Hidden
	uniform uint      _Hidden;
	UNITY_DECLARE_TEX2D(_HiddenMainTex);
	uniform sampler2D _HiddenEmissionMap;
	uniform sampler2D _HiddenEmissionMap2;
	int HiddenTexMode;
    uniform float	  _HiddenDistance;
	
//----HiddenTexMode
void HiddemMode()
{
	//-------------------------------------VRC�J�����ɉf��Ȃ��悤�ɂ���(Reiya)
	HiddenTexMode = 0;
	if (_Hidden == 1 && _ScreenParams.x == 1280 && _ScreenParams.y == 720)
        clip(-1);
	else if (_Hidden == 4 && _ScreenParams.x != 1280 && _ScreenParams.y != 720)
        clip(-1);
	else if (_Hidden == 2 && _ScreenParams.x == 1280 && _ScreenParams.y == 720)
		HiddenTexMode = 1;
	else if (_Hidden == 3 && _ScreenParams.x != 1280 && _ScreenParams.y != 720)
		HiddenTexMode = 1;
}

void HiddenDistance(VOUT IN)
{
	// �J�����ƃI�u�W�F�N�g�̋���(����)���擾
	float dist = length(_WorldSpaceCameraPos - IN.posWorld);
    if (dist <= _HiddenDistance)
        clip(-1);
}

//----SetMainTex
float4 MainTexSampleTex2D(float2 UV)
{
	if(HiddenTexMode == 1)
	{
		return UNITY_SAMPLE_TEX2D(_HiddenMainTex,UV);
	}
	else
	{
		return UNITY_SAMPLE_TEX2D(_MainTex,UV);
	}
}

float4 MainTexSampleTex2D(UNITY_DECLARE_TEX2D_NOSAMPLER(Map) ,float2 UV)
{
	if(HiddenTexMode == 1)
	{
		return UNITY_SAMPLE_TEX2D_SAMPLER(Map,_HiddenMainTex,UV);
	}
	else
	{
		return UNITY_SAMPLE_TEX2D_SAMPLER(Map,_MainTex,UV);
	}
}




//----�����_���֐�
float rand(float2 co)
{
    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

//----�f�B�]���u
void Disolve(VOUT IN){
	if(_DisolveEnable){
		fixed4 m = tex2D (_DisolveTex, IN.uv);
		half g = m.r * 0.2 + m.g * 0.7 + m.b * 0.1;
		if( g < _DisolveThreshold ){
			clip(-1);
		} 

		float4 dtime = tex2D(_DisolveTimeTex  , IN.uv);
		if (dtime.y <= 0.2f)
			clip(-1);
	}
}

//----�f�B�]���u����
float3 DisolveAdd(float3 ds){
	return _DisolveEnable * ds;
}

//----�Q�[�~���O�J���[�ǉ�
fixed3 Gameing(fixed3 OUT)
{
	OUT.x += _GameingEnable * clamp(OUT.x + (_SinTime.w ) ,0,1);
	OUT.y += _GameingEnable * clamp(OUT.y + (_SinTime.z ) ,0,1);
	OUT.z += _GameingEnable * clamp(OUT.z + (_SinTime.y ) ,0,1);

	return OUT;
}

//----vrtx�e���|�[�g
float VrtxTelepo(VIN v,VOUT o)
{	
	if (_TeleportEnable & _DisolveEnable)
	{
        float3 n = UnityObjectToWorldNormal(v.normal);

		n =  float4(n * _DisolveThreshold * 100, 0);

		if (n.y < 0)
		{
			n.y = 0;
		}

		return UnityObjectToClipPos (v.vertex).y - n.y;    
	}

	return o.pos.y;
}

//----frgm�e���|�[�g
void FrgmTelepo(VOUT IN)
{	
	if (_DisolveEnable & _TeleportEnable)
	{
		float dt = (_DisolveThreshold +1) / (1);
		if (clamp(rand(IN.uv) - dt ,0,1) <= _DisolveThreshold*_DisolveThreshold & _DisolveThreshold != 0)
		{
			clip(-1);
		}
	}
}

//----UV���[�e�[�V����
fixed3 rotate(fixed3 p, fixed3 rotation)
{
    fixed3 a = normalize(rotation);
    fixed angle = length(rotation);
    if (abs(angle) < 0.001) return p;
    fixed s = sin(angle);
    fixed c = cos(angle);
    fixed r = 1.0 - c;
    fixed3x3 m = fixed3x3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
    return mul(m, p);
}


// �W�I���g���V�F�[�_�[
[maxvertexcount(3)]
void geom (triangle VOUT input[3], inout TriangleStream<VOUT> stream)
{
	if (_EnableGeometry)
	{
		// �|���S���̒��S���v�Z�B
		// �|���S���P�ʂŌv�Z���s���邽�߁A�u�|���S���̒��S�ʒu�v���v�Z�\�ł��B
		float3 center = (input[0].vertex + input[1].vertex + input[2].vertex) / 3;

		// �|���S���̕Ӄx�N�g�����v�Z���A�|���S���̖@�����v�Z����B
		// �����āA�O�̃T���v���ł��������u�|���S���@���v�̌v�Z�ł��B
		float3 vec1 = input[1].vertex - input[0].vertex;
		float3 vec2 = input[2].vertex - input[0].vertex;
		float3 normal = normalize(cross(vec1, vec2));

		fixed destruction = _Destruction;

		// �ȗ����Ă��܂����A�Ǝ��Œ�`�����urand�v�֐����g���ė����𐶐����Ă��܂��B
		// �����ł̓|���S���ʒu�Ȃǂ�seed�ɂ��ė����𐶐����Ă��܂��B
		fixed r = 2.0 * (rand(center.xy) - 0.5);
		fixed3 r3 = r.xxx;
		float3 up = float3(0, _PositionAdd, 0);

		[unroll]
		for(int i = 0; i < 3; i++)
		{

			VOUT v = input[i];
			VOUT o = v;

			// �ȉ��ł́A�e�v�f�i�ʒu�A��]�A�X�P�[���j�ɑ΂��ČW���ɉ����ĕω���^���܂��B

			// center�ʒu���N�_�ɃX�P�[����ω������܂��B
			v.vertex.xyz = (v.vertex.xyz - center) * (1.0 - destruction * _ScaleFactor) + center + (up * destruction);

			// center�ʒu���N�_�ɁA������p���ĉ�]��ω������܂��B
			v.vertex.xyz = rotate(v.vertex.xyz , r3 * destruction * _RotationFactor) ;

			// �@�������Ɉʒu��ω������܂�
			v.vertex.xyz += normal * destruction * _PositionFactor * r3;

			// �Ō�ɁA�C���������_�ʒu���ˉe�ϊ��������_�����O�p�ɕϊ����܂��B
			o.vertex = v.vertex;
			o.pos = UnityObjectToClipPos(o.vertex);


			stream.Append(o);
		}
		stream.RestartStrip();
	}
	else
	{

		[unroll]
		for(int i = 0; i < 3; i++)
		{
			stream.Append(input[i]);
		}

		stream.RestartStrip();
	}
}