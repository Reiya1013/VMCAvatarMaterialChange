Shader "Hidden/ltspass_cutout/BeatSaber"
{
    HLSLINCLUDE
        #define LIL_RENDER 1
    ENDHLSL

//----------------------------------------------------------------------------------------------------------------------
// BRP Start
//
    SubShader
    {
        HLSLINCLUDE
            #pragma target 3.5
        ENDHLSL

        // Forward
        Pass
        {
            Name "FORWARD"
            Tags {"LightMode" = "ForwardBase"}

            Stencil
            {
                Ref [_StencilRef]
                ReadMask [_StencilReadMask]
                WriteMask [_StencilWriteMask]
                Comp [_StencilComp]
                Pass [_StencilPass]
                Fail [_StencilFail]
                ZFail [_StencilZFail]
            }
            Cull Off
            ZTest LEqual
            Offset [_OffsetFactor], [_OffsetUnits]

            Blend Zero One,One Zero //Alphaのみ書き換える
            ZWrite Off

            HLSLPROGRAM

            //----------------------------------------------------------------------------------------------------------------------
            // Build Option
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_vertex _ FOG_LINEAR FOG_EXP FOG_EXP2
            #pragma multi_compile_instancing
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma skip_variants DIRLIGHTMAP_COMBINED

            // Skip receiving shadow
            #pragma skip_variants SHADOWS_SCREEN

            //----------------------------------------------------------------------------------------------------------------------
            // Pass
            #define _BeatSaber_Alpha
            #include "Includes/lil_pass_forward.hlsl"

            ENDHLSL
        }

        // Forward Outline
        Pass
        {
            Name "FORWARD_OUTLINE"
            Tags {"LightMode" = "ForwardBase"}

            Stencil
            {
                Ref [_OutlineStencilRef]
                ReadMask [_OutlineStencilReadMask]
                WriteMask [_OutlineStencilWriteMask]
                Comp [_OutlineStencilComp]
                Pass [_OutlineStencilPass]
                Fail [_OutlineStencilFail]
                ZFail [_OutlineStencilZFail]
            }
            Cull Off
            ZTest LEqual
            Offset [_OutlineOffsetFactor], [_OutlineOffsetUnits]

            Blend Zero One,One Zero //Alphaのみ書き換える
            ZWrite Off

            HLSLPROGRAM

            //----------------------------------------------------------------------------------------------------------------------
            // Build Option
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_vertex _ FOG_LINEAR FOG_EXP FOG_EXP2
            #pragma multi_compile_instancing
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma skip_variants SHADOWS_SCREEN DIRLIGHTMAP_COMBINED

            //----------------------------------------------------------------------------------------------------------------------
            // Pass
            #define _BeatSaber_Alpha
            #define LIL_OUTLINE
            #include "Includes/lil_pass_forward.hlsl"

            ENDHLSL
        }

        // ForwardAdd
        Pass
        {
            Name "FORWARD_ADD"
            Tags {"LightMode" = "ForwardAdd"}

            Stencil
            {
                Ref [_StencilRef]
                ReadMask [_StencilReadMask]
                WriteMask [_StencilWriteMask]
                Comp [_StencilComp]
                Pass [_StencilPass]
                Fail [_StencilFail]
                ZFail [_StencilZFail]
            }
            Cull Off
            ZTest LEqual
            Offset [_OffsetFactor], [_OffsetUnits]
            Fog { Color(0,0,0,0) }

            Blend Zero One,One Zero //Alphaのみ書き換える
            ZWrite Off

            HLSLPROGRAM

            //----------------------------------------------------------------------------------------------------------------------
            // Build Option
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fragment POINT DIRECTIONAL SPOT POINT_COOKIE DIRECTIONAL_COOKIE
            #pragma multi_compile_vertex _ FOG_LINEAR FOG_EXP FOG_EXP2
            #pragma multi_compile_instancing
            #pragma fragmentoption ARB_precision_hint_fastest

            //----------------------------------------------------------------------------------------------------------------------
            // Pass
            #define _BeatSaber_Alpha
            #define LIL_PASS_FORWARDADD
            #include "Includes/lil_pass_forward.hlsl"

            ENDHLSL
        }

        // ShadowCaster
        Pass
        {
            Name "SHADOW_CASTER"
            Tags {"LightMode" = "ShadowCaster"}
            Offset 1, 1
            Cull Off

            Blend Zero One,One Zero //Alphaのみ書き換える
            ZWrite Off

            HLSLPROGRAM

            //----------------------------------------------------------------------------------------------------------------------
            // Build Option
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing

            //----------------------------------------------------------------------------------------------------------------------
            // Pass
            #define _BeatSaber_Alpha
            #include "Includes/lil_pass_shadowcaster.hlsl"

            ENDHLSL
        }

        // Meta
        Pass
        {
            Name "META"
            Tags {"LightMode" = "Meta"}
            Cull Off

            Blend Zero One,One Zero //Alphaのみ書き換える
            ZWrite Off

            HLSLPROGRAM

            //----------------------------------------------------------------------------------------------------------------------
            // Build Option
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature EDITOR_VISUALIZATION

            //----------------------------------------------------------------------------------------------------------------------
            // Pass
            #define _BeatSaber_Alpha
            #include "Includes/lil_pass_meta.hlsl"

            ENDHLSL
        }
    }
}
