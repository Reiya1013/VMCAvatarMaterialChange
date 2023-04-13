//AAShader4 From the New World
Shader "BeatSaber/AAShader4/transparent"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}        //メインテクスチャ

        [NoScaleOffset]_SpecularMap("SpecularMap", 2D) = "white" {}        //スペキュラーマッピング
        _Specular("Specular",Range(0,1)) = 0 //スペキュラー（テスト用）
        _RimPoint("RimPoint(test)",Range(0,1)) = 0.15 //リムライトの位置
        _BlueIsShadow("_BlueIsShadow",Range(0,1)) = 0
        _AlphaIsEmission("_AlphaIsEmission(EmissionPoiwe)",Range(0,5)) = 0

        [NoScaleOffset]_TightsTex("RimColorTexture", 2D) = "black" {}        //タイツテクスチャ
        [NoScaleOffset]_TightsMap("RimColorMap", 2D) = "white" {}        //タイツテクスチャ
        _Tights("RimColorPos",Range(0,2.0)) = 2.0 //入れ替えの位置

        _UseUV3Configuration("UseUV3Configuration",Range(0,1)) = 0.0
        _EyebrowsForwardWidth("EyebrowsForwardWidth",Range(0,1)) = 0.0
    }
        SubShader
    {
        Tags {
            "RenderType" = "transparent"
            "Queue" = "transparent"
            "DisableBatching" = "True"
            "VRCFallback" = "Unlit"
        }
        LOD 100

        Pass //Zバッファを先に描き出す
        {
            ZWrite ON
            ColorMask 0
        }


        Pass
        {
             Name "FORWARD"
            Tags{ "LightMode" = "ForwardBase" }	
            Blend ONE OneMinusSrcAlpha
            Cull Back
            ZWrite Off
            // カラーマスク（RGBのみ書き込む）
            ColorMask RGB

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            #define _AAS4_TRANSPARENT

            //フォアード処理はAAS4_FORWARD.cgincへ
            #include "AAS4_FORWARD.cginc"

            ENDCG
        }

        Pass//シャドゥマップの処理　ほぼ丸投げ
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }
            // カラーマスク（RGBのみ書き込む）
            ColorMask RGB

            CGPROGRAM
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"
            #include "AAS4_ShadowCast.cginc"

            ENDCG
        }



        Pass
        {
             Name "FORWARD"
            Tags{ "LightMode" = "ForwardBase" }
            Blend Zero One,One Zero //Alphaだけ上書き
            Cull Off
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #pragma multi_compile IS_BEATSABER
            #include "UnityCG.cginc"

            #define _AAS4_TRANSPARENT

            //フォアード処理はAAS4_FORWARD.cgincへ
            #include "AAS4_FORWARD.cginc"

            ENDCG
        }

        Pass//シャドゥマップの処理　ほぼ丸投げ
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }
            Blend Zero One,One Zero //Alphaだけ上書き
            Cull Off
            ZWrite Off

            CGPROGRAM
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            #pragma multi_compile IS_BEATSABER

            #include "UnityCG.cginc"
            #include "AAS4_ShadowCast.cginc"

            ENDCG
        }

    }
}