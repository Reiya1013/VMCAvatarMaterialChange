//AAShader4 From the New World
Shader "AAShader4/SEISO"
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

        [NoScaleOffset]_SeisoMap("SeisoMap", 2D) = "black" {}        //清楚マッピング
        _SeisoLight1("SeisoLight1",Range(0,1)) = 0.8
        _SeisoLight2("SeisoLight2",Range(0,1)) = 0.5

        _LineColor("LineColor",Color) = (0,0,0,1) // アウトラインの色
        _LineWidth("LineWidth", Range(0,10)) = 1 // アウトラインの幅
        [NoScaleOffset]_Line_MaskTex("Line Mask Texture", 2D) = "white" {}

        _UseUV3Configuration("UseUV3Configuration",Range(0,1)) = 0.0 
        _EyebrowsForwardWidth("EyebrowsForwardWidth",Range(0,1)) = 0.0

    }
        SubShader
    {
        Tags {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "DisableBatching" = "True"
            "VRCFallback" = "Unlit"
        }
        LOD 100

         Pass
        {
            Name "OUTLINE"
            Tags{ "LightMode" = "ForwardBase" }
            Cull FRONT

            CGPROGRAM
            #pragma target 4.5
            #pragma require geometry
            #pragma vertex vert
            #pragma geometry Geometry
            #pragma fragment frag 
            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing

            #include "UnityCG.cginc" 


            //アウトライン処理はAAS4_Outline.cgincへ
            #include "AAS4_Outline.cginc"
            ENDCG
        }

        Pass
        {
            Stencil/////////////////////////////////////////////////SEISO_SHIELDING
            {
                Ref 1
                Comp GEqual
            }
             Name "FORWARD"
            Tags{ "LightMode" = "ForwardBase" }	
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            #define _AAS4_SEISO
            #define _AAS4_SEISO_SHIELDING

            //フォアード処理はAAS4_FORWARD.cgincへ
            #include "AAS4_FORWARD.cginc"


            ENDCG
        }
        Pass
        {
            Stencil/////////////////////////////////////////////////SEISO_NOT_SHIELDING
            {
                Ref 0
                Comp Equal
            }
             Name "FORWARD"
            Tags{ "LightMode" = "ForwardBase" }	
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #pragma multi_compile_fwdbase
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            #define _AAS4_SEISO
            #define _AAS4_SEISO_NOT_SHIELDING

            //フォアード処理はAAS4_FORWARD.cgincへ
            #include "AAS4_FORWARD.cginc"


            ENDCG
        }

                    Pass//シャドゥマップの処理　ほぼ丸投げ
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }

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

    }
}