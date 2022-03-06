// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:3,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:34437,y:33631,varname:node_2865,prsc:2|diff-6720-OUT,spec-3402-OUT,gloss-7143-OUT,normal-6706-RGB,emission-1328-OUT,clip-8768-A;n:type:ShaderForge.SFN_Slider,id:3402,x:33373,y:33440,ptovrint:False,ptlb:Metallic,ptin:_Metallic,varname:_Metallic,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Slider,id:7143,x:33373,y:33525,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:_Gloss,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.9,max:1;n:type:ShaderForge.SFN_Dot,id:4262,x:31839,y:33715,varname:node_4262,prsc:2,dt:0|A-9459-OUT,B-2781-OUT;n:type:ShaderForge.SFN_Vector3,id:2781,x:31660,y:33772,varname:node_2781,prsc:2,v1:-0.5,v2:1,v3:0;n:type:ShaderForge.SFN_Multiply,id:7498,x:32027,y:33715,varname:node_7498,prsc:2|A-4262-OUT,B-1353-OUT;n:type:ShaderForge.SFN_Slider,id:1353,x:31631,y:33920,ptovrint:False,ptlb:Repetition,ptin:_Repetition,varname:_Repetition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:10,max:20;n:type:ShaderForge.SFN_Sin,id:1516,x:32180,y:33715,varname:node_1516,prsc:2|IN-7498-OUT;n:type:ShaderForge.SFN_Step,id:7509,x:32497,y:33715,varname:node_7509,prsc:2|A-9253-OUT,B-5698-OUT;n:type:ShaderForge.SFN_Slider,id:5698,x:32024,y:33923,ptovrint:False,ptlb:Width,ptin:_Width,varname:_Width,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Dot,id:1156,x:31839,y:33511,varname:node_1156,prsc:2,dt:0|A-9459-OUT,B-8432-OUT;n:type:ShaderForge.SFN_Vector3,id:8432,x:31660,y:33577,varname:node_8432,prsc:2,v1:0.5,v2:1,v3:0.5;n:type:ShaderForge.SFN_Multiply,id:3477,x:32027,y:33511,varname:node_3477,prsc:2|A-1156-OUT,B-1353-OUT;n:type:ShaderForge.SFN_Sin,id:9620,x:32180,y:33511,varname:node_9620,prsc:2|IN-3477-OUT;n:type:ShaderForge.SFN_Step,id:9474,x:32497,y:33511,varname:node_9474,prsc:2|A-9310-OUT,B-5698-OUT;n:type:ShaderForge.SFN_Multiply,id:8465,x:32793,y:33694,varname:node_8465,prsc:2|A-9474-OUT,B-7509-OUT,C-8122-OUT;n:type:ShaderForge.SFN_ViewReflectionVector,id:9459,x:31522,y:33512,varname:node_9459,prsc:2;n:type:ShaderForge.SFN_Hue,id:4709,x:32497,y:33361,varname:node_4709,prsc:2|IN-6451-OUT;n:type:ShaderForge.SFN_Dot,id:7214,x:31840,y:34249,varname:node_7214,prsc:2,dt:0|A-3092-OUT,B-38-OUT;n:type:ShaderForge.SFN_Vector3,id:38,x:31661,y:34306,varname:node_38,prsc:2,v1:0,v2:1,v3:1;n:type:ShaderForge.SFN_Multiply,id:6270,x:32028,y:34249,varname:node_6270,prsc:2|A-7214-OUT,B-1353-OUT;n:type:ShaderForge.SFN_Sin,id:733,x:32181,y:34249,varname:node_733,prsc:2|IN-6270-OUT;n:type:ShaderForge.SFN_Step,id:3714,x:32498,y:34249,varname:node_3714,prsc:2|A-2679-OUT,B-5698-OUT;n:type:ShaderForge.SFN_Dot,id:4060,x:31840,y:34045,varname:node_4060,prsc:2,dt:0|A-2697-OUT,B-2175-OUT;n:type:ShaderForge.SFN_Vector3,id:2175,x:31661,y:34125,varname:node_2175,prsc:2,v1:1,v2:0.5,v3:0.5;n:type:ShaderForge.SFN_Multiply,id:9405,x:32028,y:34045,varname:node_9405,prsc:2|A-4060-OUT,B-1353-OUT;n:type:ShaderForge.SFN_Sin,id:1982,x:32181,y:34045,varname:node_1982,prsc:2|IN-9405-OUT;n:type:ShaderForge.SFN_Step,id:8122,x:32498,y:34045,varname:node_8122,prsc:2|A-476-OUT,B-5698-OUT;n:type:ShaderForge.SFN_ViewReflectionVector,id:2697,x:31525,y:34045,varname:node_2697,prsc:2;n:type:ShaderForge.SFN_Multiply,id:5582,x:32799,y:34044,varname:node_5582,prsc:2|A-8122-OUT,B-3714-OUT,C-7509-OUT;n:type:ShaderForge.SFN_Hue,id:7521,x:32498,y:34400,varname:node_7521,prsc:2|IN-2252-OUT;n:type:ShaderForge.SFN_Add,id:5104,x:33332,y:33694,varname:node_5104,prsc:2|A-6182-OUT,B-2552-OUT;n:type:ShaderForge.SFN_NormalVector,id:3092,x:31525,y:34248,prsc:2,pt:False;n:type:ShaderForge.SFN_Tex2d,id:6706,x:33530,y:33608,ptovrint:False,ptlb:Normal,ptin:_Normal,varname:_Normal,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Color,id:1767,x:33316,y:33273,ptovrint:False,ptlb:Surface Clolr,ptin:_SurfaceClolr,varname:_SurfaceClole,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Clamp01,id:1328,x:34054,y:33969,varname:node_1328,prsc:2|IN-948-OUT;n:type:ShaderForge.SFN_Slider,id:7640,x:33175,y:34017,ptovrint:False,ptlb:Pasutel Color,ptin:_PasutelColor,varname:_PasutelColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.3,max:1;n:type:ShaderForge.SFN_Multiply,id:6182,x:32974,y:33694,varname:node_6182,prsc:2|A-4709-OUT,B-8465-OUT;n:type:ShaderForge.SFN_Multiply,id:2552,x:32976,y:34044,varname:node_2552,prsc:2|A-5582-OUT,B-7521-OUT;n:type:ShaderForge.SFN_Add,id:9106,x:32998,y:33863,varname:node_9106,prsc:2|A-8465-OUT,B-5582-OUT;n:type:ShaderForge.SFN_Multiply,id:1855,x:33728,y:33969,varname:node_1855,prsc:2|A-8190-OUT,B-1887-OUT,C-4172-OUT;n:type:ShaderForge.SFN_Add,id:6872,x:32180,y:33362,varname:node_6872,prsc:2|A-3100-OUT,B-1156-OUT;n:type:ShaderForge.SFN_Fresnel,id:638,x:32181,y:34713,varname:node_638,prsc:2|EXP-2769-OUT;n:type:ShaderForge.SFN_Slider,id:7604,x:31613,y:34858,ptovrint:False,ptlb:Distortion,ptin:_Distortion,varname:_Distortion,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:5,max:10;n:type:ShaderForge.SFN_Add,id:6582,x:32684,y:34674,varname:node_6582,prsc:2|A-5142-OUT,B-6643-UVOUT;n:type:ShaderForge.SFN_NormalVector,id:5018,x:31733,y:34546,prsc:2,pt:True;n:type:ShaderForge.SFN_Negate,id:1219,x:31882,y:34546,varname:node_1219,prsc:2|IN-5018-OUT;n:type:ShaderForge.SFN_Transform,id:9940,x:32031,y:34546,varname:node_9940,prsc:2,tffrom:0,tfto:3|IN-1219-OUT;n:type:ShaderForge.SFN_ComponentMask,id:4873,x:32181,y:34546,varname:node_4873,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-9940-XYZ;n:type:ShaderForge.SFN_Multiply,id:8116,x:32432,y:34546,varname:node_8116,prsc:2|A-4873-OUT,B-638-OUT;n:type:ShaderForge.SFN_SceneColor,id:8019,x:32876,y:34546,varname:node_8019,prsc:2|UVIN-728-OUT;n:type:ShaderForge.SFN_RemapRange,id:9310,x:32336,y:33511,varname:node_9310,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-9620-OUT;n:type:ShaderForge.SFN_RemapRange,id:9253,x:32336,y:33715,varname:node_9253,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-1516-OUT;n:type:ShaderForge.SFN_RemapRange,id:476,x:32338,y:34045,varname:node_476,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-1982-OUT;n:type:ShaderForge.SFN_RemapRange,id:2679,x:32338,y:34249,varname:node_2679,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-733-OUT;n:type:ShaderForge.SFN_Multiply,id:7252,x:33331,y:34546,varname:node_7252,prsc:2|A-1577-OUT,B-1723-RGB,C-5395-RGB;n:type:ShaderForge.SFN_Color,id:1723,x:33079,y:34692,ptovrint:False,ptlb:Basa Color,ptin:_BasaColor,varname:_BasaColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Sign,id:3656,x:33167,y:33863,varname:node_3656,prsc:2|IN-9106-OUT;n:type:ShaderForge.SFN_Clamp01,id:3443,x:33332,y:33863,varname:node_3443,prsc:2|IN-3656-OUT;n:type:ShaderForge.SFN_Lerp,id:8190,x:33530,y:33843,varname:node_8190,prsc:2|A-5104-OUT,B-3443-OUT,T-7640-OUT;n:type:ShaderForge.SFN_Slider,id:1887,x:33172,y:34105,ptovrint:False,ptlb:Coloe Level,ptin:_ColoeLevel,varname:_ColoeLevel,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Add,id:948,x:33896,y:33969,varname:node_948,prsc:2|A-1855-OUT,B-7252-OUT;n:type:ShaderForge.SFN_SceneColor,id:7796,x:32876,y:34673,varname:node_7796,prsc:2|UVIN-6582-OUT;n:type:ShaderForge.SFN_SceneColor,id:9358,x:32876,y:34805,varname:node_9358,prsc:2|UVIN-3981-OUT;n:type:ShaderForge.SFN_Append,id:1577,x:33079,y:34546,varname:node_1577,prsc:2|A-8019-R,B-7796-G,C-9358-B;n:type:ShaderForge.SFN_Add,id:3981,x:32684,y:34804,varname:node_3981,prsc:2|A-9149-OUT,B-6643-UVOUT;n:type:ShaderForge.SFN_Add,id:728,x:32684,y:34546,varname:node_728,prsc:2|A-8116-OUT,B-6643-UVOUT;n:type:ShaderForge.SFN_ScreenPos,id:6643,x:32432,y:34939,varname:node_6643,prsc:2,sctp:2;n:type:ShaderForge.SFN_Multiply,id:5142,x:32432,y:34674,varname:node_5142,prsc:2|A-4873-OUT,B-1520-OUT;n:type:ShaderForge.SFN_Multiply,id:9149,x:32432,y:34804,varname:node_9149,prsc:2|A-4873-OUT,B-2263-OUT;n:type:ShaderForge.SFN_Fresnel,id:1520,x:32181,y:34838,varname:node_1520,prsc:2|EXP-7604-OUT;n:type:ShaderForge.SFN_Slider,id:9515,x:31613,y:34947,ptovrint:False,ptlb:Chromatic Aberration,ptin:_ChromaticAberration,varname:_ChromaticAberration,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Fresnel,id:2263,x:32181,y:34967,varname:node_2263,prsc:2|EXP-3486-OUT;n:type:ShaderForge.SFN_LightColor,id:2995,x:33003,y:34233,varname:node_2995,prsc:2;n:type:ShaderForge.SFN_Lerp,id:7429,x:33332,y:34233,varname:node_7429,prsc:2|A-2995-RGB,B-4434-OUT,T-4799-OUT;n:type:ShaderForge.SFN_Vector1,id:4434,x:33172,y:34267,varname:node_4434,prsc:2,v1:1;n:type:ShaderForge.SFN_Step,id:4799,x:33172,y:34314,varname:node_4799,prsc:2|A-2995-R,B-731-OUT;n:type:ShaderForge.SFN_Subtract,id:2769,x:32000,y:34733,varname:node_2769,prsc:2|A-7604-OUT,B-9515-OUT;n:type:ShaderForge.SFN_Add,id:3486,x:32000,y:34986,varname:node_3486,prsc:2|A-7604-OUT,B-9515-OUT;n:type:ShaderForge.SFN_Vector1,id:3100,x:32009,y:33362,varname:node_3100,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Relay,id:6783,x:32090,y:34401,varname:node_6783,prsc:2|IN-7214-OUT;n:type:ShaderForge.SFN_Tex2d,id:5395,x:33079,y:34852,ptovrint:False,ptlb:Base Color tex,ptin:_BaseColortex,varname:_BaseColoe,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:667,x:33316,y:33107,ptovrint:False,ptlb:Surface Clolr tex,ptin:_SurfaceClolrtex,varname:_SurfaceClolr,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:6720,x:33530,y:33253,varname:node_6720,prsc:2|A-667-RGB,B-1767-RGB;n:type:ShaderForge.SFN_Tex2d,id:8768,x:34054,y:34103,ptovrint:False,ptlb:alpha,ptin:_alpha,varname:_alpha,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:6451,x:32336,y:33362,varname:node_6451,prsc:2|A-6872-OUT,B-6084-OUT;n:type:ShaderForge.SFN_Multiply,id:2252,x:32338,y:34400,varname:node_2252,prsc:2|A-6783-OUT,B-6084-OUT;n:type:ShaderForge.SFN_Slider,id:6084,x:31290,y:33918,ptovrint:False,ptlb:ColorLoop,ptin:_ColorLoop,varname:_ColorLoop,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:5;n:type:ShaderForge.SFN_Vector1,id:731,x:33003,y:34348,varname:node_731,prsc:2,v1:0;n:type:ShaderForge.SFN_SwitchProperty,id:4172,x:33502,y:34186,ptovrint:False,ptlb:Light Completion,ptin:_LightCompletion,varname:node_4172,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True|A-2995-RGB,B-7429-OUT;proporder:5395-1723-667-1767-6706-8768-3402-7143-1353-6084-5698-1887-7640-7604-9515-4172;pass:END;sub:END;*/

Shader "BeatSaber/Shader Forge/Crystal Shader" {
    Properties {
        _BaseColortex ("Base Color tex", 2D) = "white" {}
        _BasaColor ("Basa Color", Color) = (1,1,1,1)
        _SurfaceClolrtex ("Surface Clolr tex", 2D) = "white" {}
        _SurfaceClolr ("Surface Clolr", Color) = (0,0,0,1)
        _Normal ("Normal", 2D) = "bump" {}
        _alpha ("alpha", 2D) = "white" {}
        _Metallic ("Metallic", Range(0, 1)) = 0.5
        _Gloss ("Gloss", Range(0, 1)) = 0.9
        _Repetition ("Repetition", Range(1, 20)) = 10
        _ColorLoop ("ColorLoop", Range(1, 5)) = 1
        _Width ("Width", Range(0, 1)) = 0.5
        _ColoeLevel ("Coloe Level", Range(0, 1)) = 0.5
        _PasutelColor ("Pasutel Color", Range(0, 1)) = 0.3
        _Distortion ("Distortion", Range(0, 10)) = 5
        _ChromaticAberration ("Chromatic Aberration", Range(-1, 1)) = 0
        [MaterialToggle] _LightCompletion ("Light Completion", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float _Metallic;
            uniform float _Gloss;
            uniform float _Repetition;
            uniform float _Width;
            uniform sampler2D _Normal; uniform float4 _Normal_ST;
            uniform float4 _SurfaceClolr;
            uniform float _PasutelColor;
            uniform float _Distortion;
            uniform float4 _BasaColor;
            uniform float _ColoeLevel;
            uniform float _ChromaticAberration;
            uniform sampler2D _BaseColortex; uniform float4 _BaseColortex_ST;
            uniform sampler2D _SurfaceClolrtex; uniform float4 _SurfaceClolrtex_ST;
            uniform sampler2D _alpha; uniform float4 _alpha_ST;
            uniform float _ColorLoop;
            uniform fixed _LightCompletion;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                float4 projPos : TEXCOORD7;
                UNITY_FOG_COORDS(8)
                #if defined(LIGHTMAP_ON) || defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD9;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #elif UNITY_SHOULD_SAMPLE_SH
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _Normal_var = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(i.uv0, _Normal)));
                float3 normalLocal = _Normal_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float4 _alpha_var = tex2D(_alpha,TRANSFORM_TEX(i.uv0, _alpha));
                clip(_alpha_var.a - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = _Gloss;
                float perceptualRoughness = 1.0 - _Gloss;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = _Metallic;
                float specularMonochrome;
                float4 _SurfaceClolrtex_var = tex2D(_SurfaceClolrtex,TRANSFORM_TEX(i.uv0, _SurfaceClolrtex));
                float3 diffuseColor = (_SurfaceClolrtex_var.rgb*_SurfaceClolr.rgb); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;
                #else
                    surfaceReduction = 1.0/(roughness*roughness + 1.0);
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular);
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += gi.indirect.diffuse;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float node_1156 = dot(viewReflectDirection,float3(0.5,1,0.5));
                float node_7509 = step((sin((dot(viewReflectDirection,float3(-0.5,1,0))*_Repetition))*0.5+0.5),_Width);
                float node_8122 = step((sin((dot(viewReflectDirection,float3(1,0.5,0.5))*_Repetition))*0.5+0.5),_Width);
                float node_8465 = (step((sin((node_1156*_Repetition))*0.5+0.5),_Width)*node_7509*node_8122);
                float node_7214 = dot(i.normalDir,float3(0,1,1));
                float node_5582 = (node_8122*step((sin((node_7214*_Repetition))*0.5+0.5),_Width)*node_7509);
                float node_3443 = saturate(sign((node_8465+node_5582)));
                float node_4434 = 1.0;
                float2 node_4873 = mul( UNITY_MATRIX_V, float4((-1*normalDirection),0) ).xyz.rgb.rg;
                float4 _BaseColortex_var = tex2D(_BaseColortex,TRANSFORM_TEX(i.uv0, _BaseColortex));
                float3 emissive = saturate(((lerp(((saturate(3.0*abs(1.0-2.0*frac(((0.5+node_1156)*_ColorLoop)+float3(0.0,-1.0/3.0,1.0/3.0)))-1)*node_8465)+(node_5582*saturate(3.0*abs(1.0-2.0*frac((node_7214*_ColorLoop)+float3(0.0,-1.0/3.0,1.0/3.0)))-1))),float3(node_3443,node_3443,node_3443),_PasutelColor)*_ColoeLevel*lerp( _LightColor0.rgb, lerp(_LightColor0.rgb,float3(node_4434,node_4434,node_4434),step(_LightColor0.r,0.0)), _LightCompletion ))+(float3(tex2D( _GrabTexture, ((node_4873*pow(1.0-max(0,dot(normalDirection, viewDirection)),(_Distortion-_ChromaticAberration)))+sceneUVs.rg)).r,tex2D( _GrabTexture, ((node_4873*pow(1.0-max(0,dot(normalDirection, viewDirection)),_Distortion))+sceneUVs.rg)).g,tex2D( _GrabTexture, ((node_4873*pow(1.0-max(0,dot(normalDirection, viewDirection)),(_Distortion+_ChromaticAberration)))+sceneUVs.rg)).b)*_BasaColor.rgb*_BaseColortex_var.rgb)));
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            ColorMask RGB
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float _Metallic;
            uniform float _Gloss;
            uniform float _Repetition;
            uniform float _Width;
            uniform sampler2D _Normal; uniform float4 _Normal_ST;
            uniform float4 _SurfaceClolr;
            uniform float _PasutelColor;
            uniform float _Distortion;
            uniform float4 _BasaColor;
            uniform float _ColoeLevel;
            uniform float _ChromaticAberration;
            uniform sampler2D _BaseColortex; uniform float4 _BaseColortex_ST;
            uniform sampler2D _SurfaceClolrtex; uniform float4 _SurfaceClolrtex_ST;
            uniform sampler2D _alpha; uniform float4 _alpha_ST;
            uniform float _ColorLoop;
            uniform fixed _LightCompletion;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                float4 projPos : TEXCOORD7;
                LIGHTING_COORDS(8,9)
                UNITY_FOG_COORDS(10)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _Normal_var = UnpackNormal(tex2D(_Normal,TRANSFORM_TEX(i.uv0, _Normal)));
                float3 normalLocal = _Normal_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float4 _alpha_var = tex2D(_alpha,TRANSFORM_TEX(i.uv0, _alpha));
                clip(_alpha_var.a - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float gloss = _Gloss;
                float perceptualRoughness = 1.0 - _Gloss;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float3 specularColor = _Metallic;
                float specularMonochrome;
                float4 _SurfaceClolrtex_var = tex2D(_SurfaceClolrtex,TRANSFORM_TEX(i.uv0, _SurfaceClolrtex));
                float3 diffuseColor = (_SurfaceClolrtex_var.rgb*_SurfaceClolr.rgb); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _alpha; uniform float4 _alpha_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float2 uv1 : TEXCOORD2;
                float2 uv2 : TEXCOORD3;
                float4 posWorld : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _alpha_var = tex2D(_alpha,TRANSFORM_TEX(i.uv0, _alpha));
                clip(_alpha_var.a - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "Meta"
            Tags {
                "LightMode"="Meta"
            }
            Cull Off
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_META 1
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityMetaPass.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float _Metallic;
            uniform float _Gloss;
            uniform float _Repetition;
            uniform float _Width;
            uniform float4 _SurfaceClolr;
            uniform float _PasutelColor;
            uniform float _Distortion;
            uniform float4 _BasaColor;
            uniform float _ColoeLevel;
            uniform float _ChromaticAberration;
            uniform sampler2D _BaseColortex; uniform float4 _BaseColortex_ST;
            uniform sampler2D _SurfaceClolrtex; uniform float4 _SurfaceClolrtex_ST;
            uniform float _ColorLoop;
            uniform fixed _LightCompletion;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float4 projPos : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : SV_Target {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightColor = _LightColor0.rgb;
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT( UnityMetaInput, o );
                
                float node_1156 = dot(viewReflectDirection,float3(0.5,1,0.5));
                float node_7509 = step((sin((dot(viewReflectDirection,float3(-0.5,1,0))*_Repetition))*0.5+0.5),_Width);
                float node_8122 = step((sin((dot(viewReflectDirection,float3(1,0.5,0.5))*_Repetition))*0.5+0.5),_Width);
                float node_8465 = (step((sin((node_1156*_Repetition))*0.5+0.5),_Width)*node_7509*node_8122);
                float node_7214 = dot(i.normalDir,float3(0,1,1));
                float node_5582 = (node_8122*step((sin((node_7214*_Repetition))*0.5+0.5),_Width)*node_7509);
                float node_3443 = saturate(sign((node_8465+node_5582)));
                float node_4434 = 1.0;
                float2 node_4873 = mul( UNITY_MATRIX_V, float4((-1*normalDirection),0) ).xyz.rgb.rg;
                float4 _BaseColortex_var = tex2D(_BaseColortex,TRANSFORM_TEX(i.uv0, _BaseColortex));
                o.Emission = saturate(((lerp(((saturate(3.0*abs(1.0-2.0*frac(((0.5+node_1156)*_ColorLoop)+float3(0.0,-1.0/3.0,1.0/3.0)))-1)*node_8465)+(node_5582*saturate(3.0*abs(1.0-2.0*frac((node_7214*_ColorLoop)+float3(0.0,-1.0/3.0,1.0/3.0)))-1))),float3(node_3443,node_3443,node_3443),_PasutelColor)*_ColoeLevel*lerp( _LightColor0.rgb, lerp(_LightColor0.rgb,float3(node_4434,node_4434,node_4434),step(_LightColor0.r,0.0)), _LightCompletion ))+(float3(tex2D( _GrabTexture, ((node_4873*pow(1.0-max(0,dot(normalDirection, viewDirection)),(_Distortion-_ChromaticAberration)))+sceneUVs.rg)).r,tex2D( _GrabTexture, ((node_4873*pow(1.0-max(0,dot(normalDirection, viewDirection)),_Distortion))+sceneUVs.rg)).g,tex2D( _GrabTexture, ((node_4873*pow(1.0-max(0,dot(normalDirection, viewDirection)),(_Distortion+_ChromaticAberration)))+sceneUVs.rg)).b)*_BasaColor.rgb*_BaseColortex_var.rgb)));
                
                float4 _SurfaceClolrtex_var = tex2D(_SurfaceClolrtex,TRANSFORM_TEX(i.uv0, _SurfaceClolrtex));
                float3 diffColor = (_SurfaceClolrtex_var.rgb*_SurfaceClolr.rgb);
                float specularMonochrome;
                float3 specColor;
                diffColor = DiffuseAndSpecularFromMetallic( diffColor, _Metallic, specColor, specularMonochrome );
                float roughness = 1.0 - _Gloss;
                o.Albedo = diffColor + specColor * roughness * roughness * 0.5;
                
                return UnityMetaFragment( o );
            }
            ENDCG
        }

    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
