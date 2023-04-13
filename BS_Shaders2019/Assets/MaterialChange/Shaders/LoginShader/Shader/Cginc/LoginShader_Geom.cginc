
//----�����_���֐�
float rand(float2 co)
{
	return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
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
void geom(triangle VOUT input[3], inout TriangleStream<VOUT> stream)
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
		float3 up = float3(0, _PositionAdd*2, 0);

		[unroll]
		for (int i = 0; i < 3; i++)
		{

			VOUT v = input[i];
			VOUT o = v;

			// �ȉ��ł́A�e�v�f�i�ʒu�A��]�A�X�P�[���j�ɑ΂��ČW���ɉ����ĕω���^���܂��B
			// center�ʒu���N�_�ɃX�P�[����ω������܂��B
			v.vertex.xyz = (v.vertex.xyz - center) * (1.0 - destruction * _ScaleFactor) + center + (up * destruction);

			// center�ʒu���N�_�ɁA������p���ĉ�]��ω������܂��B
			v.vertex.xyz = rotate(v.vertex.xyz, r3 * destruction * _RotationFactor);

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
		for (int i = 0; i < 3; i++)
		{
			stream.Append(input[i]);
		}

		stream.RestartStrip();
	}
}