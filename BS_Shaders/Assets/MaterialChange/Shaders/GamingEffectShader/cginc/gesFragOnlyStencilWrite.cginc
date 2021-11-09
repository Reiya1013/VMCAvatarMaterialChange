// Copyright (c) 2020 thakyuu
//
// This code is under MIT licence, see LICENSE
//
// 本コード は MIT License を使用して公開しています。
// 詳細はLICENSEか、https://opensource.org/licenses/mit-license.php を参照してください。


// This Code Based on Arktoon-Shader
//
// Original code is under MIT license
//
// Original code Copyright (c) 2018 synqark
// Original code and repos（https://github.com/synqark/Arktoon-Shader) is under MIT licence, see LICENSE
//
// 本コード は Arktoon-Shaderをベースとしています
// Arktoon-Shader は MIT License を使用して公開されています。
//

uniform sampler2D _StencilMaskTex; uniform float4 _StencilMaskTex_ST;
uniform float _StencilMaskAdjust;
uniform float _StencilMaskAlphaDither;
uniform sampler2D _DitherMaskLOD2D;

float4 frag(VertexOutput i) : COLOR {
    // MainTex, Color, StencilMask情報をもとにClipするだけ
    float4 _MainTex_var = UNITY_SAMPLE_TEX2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
    float4 _StencilMaskTex_var = tex2D(_StencilMaskTex,TRANSFORM_TEX(i.uv0, _StencilMaskTex));

    clip(min((_MainTex_var.a *_Color.a) - _CutoutCutoutAdjust, _StencilMaskTex_var - _StencilMaskAdjust));

    // _DitherMaskLOD2Dを使って更にclipする
    float4 pos = i.pos;
    pos *= 0.25;
    pos.y = frac(pos.y) * 0.0625;
    pos.y += _StencilMaskAlphaDither * 0.9375;
    clip(tex2D(_DitherMaskLOD2D, pos).a - 0.5);

    float4 finalRGBA = float4(0,0,0,0);
    return finalRGBA;
}