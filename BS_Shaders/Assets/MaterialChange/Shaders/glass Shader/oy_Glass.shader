// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Particles/Additive,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:3,spmd:0,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:False,rprd:True,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:-1,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:2865,x:32719,y:32712,varname:node_2865,prsc:2|diff-5475-OUT,spec-8226-OUT,gloss-1756-OUT,normal-714-OUT,emission-8907-OUT;n:type:ShaderForge.SFN_NormalVector,id:5997,x:30458,y:32336,prsc:2,pt:False;n:type:ShaderForge.SFN_Transform,id:413,x:30881,y:32312,varname:node_413,prsc:2,tffrom:3,tfto:0|IN-7709-OUT;n:type:ShaderForge.SFN_ComponentMask,id:5133,x:31103,y:32309,varname:node_5133,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-413-XYZ;n:type:ShaderForge.SFN_Multiply,id:4214,x:31324,y:32309,varname:node_4214,prsc:2|A-5133-OUT,B-2605-OUT;n:type:ShaderForge.SFN_Add,id:3487,x:31577,y:32351,varname:node_3487,prsc:2|A-4214-OUT,B-9574-UVOUT;n:type:ShaderForge.SFN_ScreenPos,id:9574,x:31334,y:32138,varname:node_9574,prsc:2,sctp:2;n:type:ShaderForge.SFN_Fresnel,id:2605,x:30913,y:32500,varname:node_2605,prsc:2|NRM-714-OUT,EXP-4684-OUT;n:type:ShaderForge.SFN_Slider,id:4684,x:30562,y:32519,ptovrint:False,ptlb:Distortion,ptin:_Distortion,varname:node_4684,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:6.4,max:20;n:type:ShaderForge.SFN_SceneColor,id:2268,x:31903,y:32306,varname:node_2268,prsc:2|UVIN-331-OUT;n:type:ShaderForge.SFN_Slider,id:1315,x:32109,y:32638,ptovrint:False,ptlb:Specular,ptin:_Specular,varname:node_1315,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.202,max:1;n:type:ShaderForge.SFN_Slider,id:1756,x:32149,y:32949,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:node_1756,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.976,max:1;n:type:ShaderForge.SFN_ViewReflectionVector,id:9890,x:30432,y:32067,varname:node_9890,prsc:2;n:type:ShaderForge.SFN_Reflect,id:7709,x:30676,y:32312,varname:node_7709,prsc:2|A-9890-OUT,B-5997-OUT;n:type:ShaderForge.SFN_Color,id:3720,x:31557,y:33143,ptovrint:False,ptlb:Reflection_Color,ptin:_Reflection_Color,varname:node_3720,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:9195,x:32096,y:32435,varname:node_9195,prsc:2|A-2268-RGB,B-89-RGB;n:type:ShaderForge.SFN_ComponentMask,id:7163,x:31316,y:33395,varname:node_7163,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-2289-OUT;n:type:ShaderForge.SFN_Slider,id:9572,x:31185,y:33647,ptovrint:False,ptlb:Matcap_Scale,ptin:_Matcap_Scale,varname:node_9572,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:5;n:type:ShaderForge.SFN_Multiply,id:3645,x:31548,y:33449,varname:node_3645,prsc:2|A-7163-OUT,B-9572-OUT;n:type:ShaderForge.SFN_Add,id:693,x:31819,y:33519,varname:node_693,prsc:2|A-3645-OUT,B-9572-OUT;n:type:ShaderForge.SFN_Tex2d,id:9424,x:31974,y:33519,ptovrint:False,ptlb:Matcap,ptin:_Matcap,varname:node_9424,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:4e0891da66c0cc24aacaab413b8f471b,ntxv:2,isnm:False|UVIN-693-OUT;n:type:ShaderForge.SFN_Multiply,id:8907,x:32263,y:33617,varname:node_8907,prsc:2|A-9424-RGB,B-2198-OUT,C-7885-OUT;n:type:ShaderForge.SFN_ScreenPos,id:2265,x:30942,y:33794,varname:node_2265,prsc:2,sctp:2;n:type:ShaderForge.SFN_HsvToRgb,id:7452,x:31469,y:34060,varname:node_7452,prsc:2|H-9310-OUT,S-891-OUT,V-6594-OUT;n:type:ShaderForge.SFN_Multiply,id:9310,x:31205,y:33913,varname:node_9310,prsc:2|A-2265-U,B-2265-V,C-3618-XYZ;n:type:ShaderForge.SFN_Multiply,id:2198,x:31953,y:33831,varname:node_2198,prsc:2|A-8996-OUT,B-7452-OUT;n:type:ShaderForge.SFN_Vector1,id:6594,x:31299,y:34256,varname:node_6594,prsc:2,v1:1;n:type:ShaderForge.SFN_Multiply,id:8996,x:31785,y:33706,varname:node_8996,prsc:2|A-3720-RGB,B-9492-OUT;n:type:ShaderForge.SFN_Slider,id:9492,x:31433,y:33777,ptovrint:False,ptlb:Matcap_Strength,ptin:_Matcap_Strength,varname:node_9492,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.4,max:1;n:type:ShaderForge.SFN_Slider,id:891,x:31098,y:34127,ptovrint:False,ptlb:Matcap_Hue_Range,ptin:_Matcap_Hue_Range,varname:node_891,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_NormalVector,id:8425,x:30719,y:33932,prsc:2,pt:False;n:type:ShaderForge.SFN_Transform,id:3618,x:30942,y:33932,varname:node_3618,prsc:2,tffrom:0,tfto:3|IN-8425-OUT;n:type:ShaderForge.SFN_Color,id:4636,x:31558,y:34352,ptovrint:False,ptlb:Emission_Base_Color,ptin:_Emission_Base_Color,varname:node_4636,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Color,id:1409,x:32096,y:32236,ptovrint:False,ptlb:Albedo_Base_Color,ptin:_Albedo_Base_Color,varname:node_1409,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Add,id:5475,x:32340,y:32287,varname:node_5475,prsc:2|A-1409-RGB,B-9195-OUT;n:type:ShaderForge.SFN_RemapRangeAdvanced,id:8328,x:31371,y:34560,varname:node_8328,prsc:2|IN-2646-OUT,IMIN-8494-OUT,IMAX-2469-OUT,OMIN-6737-OUT,OMAX-233-OUT;n:type:ShaderForge.SFN_Vector1,id:8494,x:31114,y:34575,varname:node_8494,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:2469,x:31114,y:34628,varname:node_2469,prsc:2,v1:1;n:type:ShaderForge.SFN_Vector1,id:233,x:31175,y:34780,varname:node_233,prsc:2,v1:1;n:type:ShaderForge.SFN_Power,id:5292,x:31563,y:34619,varname:node_5292,prsc:2|VAL-8328-OUT,EXP-7681-OUT;n:type:ShaderForge.SFN_Vector1,id:7681,x:31369,y:34810,varname:node_7681,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Slider,id:6737,x:30892,y:34755,ptovrint:False,ptlb:Matcap_Emission_Bottom,ptin:_Matcap_Emission_Bottom,varname:node_6737,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.08,max:1;n:type:ShaderForge.SFN_Multiply,id:1383,x:31728,y:34459,varname:node_1383,prsc:2|A-4636-RGB,B-5292-OUT;n:type:ShaderForge.SFN_Color,id:8900,x:31878,y:33247,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_8900,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:0.03921569;n:type:ShaderForge.SFN_Color,id:89,x:31794,y:32448,ptovrint:False,ptlb:Incident_Color,ptin:_Incident_Color,varname:node_89,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.7529413,c2:0.7411765,c3:0.8313726,c4:1;n:type:ShaderForge.SFN_Multiply,id:8226,x:32438,y:32680,varname:node_8226,prsc:2|A-1315-OUT,B-3720-RGB;n:type:ShaderForge.SFN_Tex2d,id:4005,x:30377,y:32685,ptovrint:False,ptlb:Normal Map,ptin:_NormalMap,varname:node_4005,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_TexCoord,id:3173,x:29399,y:32852,varname:node_3173,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Code,id:5991,x:29706,y:32877,varname:node_5991,prsc:2,code:ZgBsAG8AYQB0ADMAIABPAHUAdAA7AAoAZgBsAG8AYQB0ACAAUgBhAGQAaQB1AHMAMgA7AAoAZgBsAG8AYQB0ACAAWAA7AAoAZgBsAG8AYQB0ACAAWQA7AAoAZgBsAG8AYQB0ACAAWgA7AAoAZgBsAG8AYQB0ACAAbgBvAHIAbQA7AAoACgBSAGEAZABpAHUAcwAyACAAPQAgAFIAYQBkAGkAdQBzACAAKgAgADIAOwAKAFgAIAA9ACAAKABSACAALQAgACgATwBmAGYAcwBlAHQAWAAgACsAIAAwAC4ANQApACkAIAAqACAAMgAgACoAIABDAHUAcgB2AGUAOwAKAFkAIAA9ACAAKABHACAALQAgACgATwBmAGYAcwBlAHQAWQAgACsAIAAwAC4ANQApACkAIAAqACAAMgAgACoAIABDAHUAcgB2AGUAOwAKAFoAIAA9ACAAcwBxAHIAdAAoAGMAbABhAG0AcAAoACgAUgBhAGQAaQB1AHMAMgAgACoAIABSAGEAZABpAHUAcwAyACAALQAgACgAWAAgACoAIABYACAAKwAgAFkAIAAqACAAWQApACkALAAgADAALAAgADEAKQApACAAKgAgAEMAdQByAHYAZQAgACsAIAAoADEAIAAtACAAQwB1AHIAdgBlACkAOwAKAG4AbwByAG0AIAA9ACAAcwBxAHIAdAAoAFgAIAAqACAAWAAgACsAIABZACAAKgAgAFkAIAArACAAWgAgACoAIABaACkAOwAKAAoATwB1AHQALgB4ACAAPQAgAFgAIAAvACAAbgBvAHIAbQAgAC8AIAAyADsACgBPAHUAdAAuAHkAIAA9ACAAWQAgAC8AIABuAG8AcgBtACAALwAgADIAOwAKAE8AdQB0AC4AegAgAD0AIABaACAALwAgAG4AbwByAG0AOwAKAAoAcgBlAHQAdQByAG4AIABPAHUAdAA7AA==,output:2,fname:Colormapping_1,width:777,height:379,input:0,input:0,input:0,input:0,input:0,input:0,input_1_label:R,input_2_label:G,input_3_label:Curve,input_4_label:Radius,input_5_label:OffsetX,input_6_label:OffsetY|A-3173-U,B-3173-V,C-3456-OUT,D-301-OUT,E-432-OUT,F-9791-OUT;n:type:ShaderForge.SFN_Slider,id:3456,x:29254,y:33016,ptovrint:False,ptlb:Lens Curve,ptin:_LensCurve,varname:node_3456,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.7,max:1;n:type:ShaderForge.SFN_ValueProperty,id:301,x:29411,y:33108,ptovrint:False,ptlb:Lens Radius,ptin:_LensRadius,varname:node_301,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_ValueProperty,id:432,x:29411,y:33193,ptovrint:False,ptlb:Lens Offset X,ptin:_LensOffsetX,varname:node_432,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:9791,x:29411,y:33276,ptovrint:False,ptlb:Lens Offset Y,ptin:_LensOffsetY,varname:node_9791,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Code,id:1120,x:29743,y:33363,varname:node_1120,prsc:2,code:LwAvAHgAeQB6AC4AeAAgAD0AIAAoAHgAeQB6AC4AeAAgAC0AIAAwAC4ANQApACAAKgAgADIAOwAKAC8ALwB4AHkAegAuAHkAIAA9ACAAKAB4AHkAegAuAHkAIAAtACAAMAAuADUAKQAgACoAIAAyADsACgB4AHkAegAuAHoAIAA9ACAAeAB5AHoALgB6ACAALQAgADEAOwAKAHIAZQB0AHUAcgBuACAAeAB5AHoAOwA=,output:2,fname:Inv_Z,width:249,height:132,input:2,input_1_label:xyz;n:type:ShaderForge.SFN_ViewReflectionVector,id:1276,x:30814,y:33329,varname:node_1276,prsc:2;n:type:ShaderForge.SFN_AmbientLight,id:1047,x:30477,y:34640,varname:node_1047,prsc:2;n:type:ShaderForge.SFN_LightColor,id:9777,x:30641,y:34660,varname:node_9777,prsc:2;n:type:ShaderForge.SFN_Add,id:5435,x:30683,y:34431,varname:node_5435,prsc:2|A-4395-OUT,B-2896-RGB,C-1047-RGB;n:type:ShaderForge.SFN_Multiply,id:2646,x:30912,y:34493,varname:node_2646,prsc:2|A-5435-OUT,B-9777-RGB;n:type:ShaderForge.SFN_Add,id:7885,x:31900,y:34543,varname:node_7885,prsc:2|A-1383-OUT,B-5292-OUT;n:type:ShaderForge.SFN_SceneColor,id:2896,x:30477,y:34510,varname:node_2896,prsc:2;n:type:ShaderForge.SFN_Dot,id:7370,x:29773,y:34230,varname:node_7370,prsc:2,dt:1|A-3996-OUT,B-1853-OUT;n:type:ShaderForge.SFN_NormalVector,id:3996,x:29604,y:34182,prsc:2,pt:False;n:type:ShaderForge.SFN_LightVector,id:1853,x:29604,y:34324,varname:node_1853,prsc:2;n:type:ShaderForge.SFN_ViewReflectionVector,id:3154,x:29604,y:34444,varname:node_3154,prsc:2;n:type:ShaderForge.SFN_Dot,id:4601,x:29773,y:34380,varname:node_4601,prsc:2,dt:1|A-1853-OUT,B-3154-OUT;n:type:ShaderForge.SFN_Add,id:4395,x:30149,y:34282,varname:node_4395,prsc:2|A-7370-OUT,B-599-OUT;n:type:ShaderForge.SFN_Exp,id:8134,x:29773,y:34580,varname:node_8134,prsc:2,et:1|IN-45-OUT;n:type:ShaderForge.SFN_Power,id:599,x:29972,y:34418,varname:node_599,prsc:2|VAL-4601-OUT,EXP-8134-OUT;n:type:ShaderForge.SFN_Vector1,id:45,x:29604,y:34624,varname:node_45,prsc:2,v1:2;n:type:ShaderForge.SFN_SwitchProperty,id:714,x:30649,y:32800,ptovrint:False,ptlb:Use LensEffect,ptin:_UseLensEffect,varname:node_714,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-4005-RGB,B-5991-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:331,x:31737,y:32274,ptovrint:False,ptlb:Use Distortion,ptin:_UseDistortion,varname:node_331,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-9574-UVOUT,B-3487-OUT;n:type:ShaderForge.SFN_Transform,id:6408,x:30968,y:33405,varname:node_6408,prsc:2,tffrom:3,tfto:0|IN-1276-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:2289,x:31151,y:33306,ptovrint:False,ptlb:Matcap Style,ptin:_MatcapStyle,varname:node_2289,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-1276-OUT,B-6408-XYZ;proporder:331-4684-1315-1756-1409-89-3720-4636-9424-2289-9572-9492-891-6737-8900-714-4005-3456-301-432-9791;pass:END;sub:END;*/

Shader "BeatSaber/Shader Forge/oy_Glass(VRCSafety:Particle)" {
    Properties {
        [MaterialToggle] _UseDistortion ("Use Distortion", Float ) = 0
        _Distortion ("Distortion", Range(0, 20)) = 6.4
        _Specular ("Specular", Range(0, 1)) = 0.202
        _Gloss ("Gloss", Range(0, 1)) = 0.976
        _Albedo_Base_Color ("Albedo_Base_Color", Color) = (0,0,0,1)
        _Incident_Color ("Incident_Color", Color) = (0.7529413,0.7411765,0.8313726,1)
        _Reflection_Color ("Reflection_Color", Color) = (1,1,1,1)
        _Emission_Base_Color ("Emission_Base_Color", Color) = (0,0,0,1)
        _Matcap ("Matcap", 2D) = "black" {}
        [MaterialToggle] _MatcapStyle ("Matcap Style", Float ) = 0
        _Matcap_Scale ("Matcap_Scale", Range(0, 5)) = 0.5
        _Matcap_Strength ("Matcap_Strength", Range(0, 1)) = 0.4
        _Matcap_Hue_Range ("Matcap_Hue_Range", Range(0, 1)) = 0.5
        _Matcap_Emission_Bottom ("Matcap_Emission_Bottom", Range(0, 1)) = 0.08
        _Color ("Color", Color) = (0.5,0.5,0.5,0.03921569)
        [MaterialToggle] _UseLensEffect ("Use LensEffect", Float ) = 0
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _LensCurve ("Lens Curve", Range(0, 1)) = 0.7
        _LensRadius ("Lens Radius", Float ) = 0.5
        _LensOffsetX ("Lens Offset X", Float ) = 0
        _LensOffsetY ("Lens Offset Y", Float ) = 0
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
            Blend One One
            ZWrite Off
            Offset -1, 0
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
            uniform float _Distortion;
            uniform float _Specular;
            uniform float _Gloss;
            uniform float4 _Reflection_Color;
            uniform float _Matcap_Scale;
            uniform sampler2D _Matcap; uniform float4 _Matcap_ST;
            uniform float _Matcap_Strength;
            uniform float _Matcap_Hue_Range;
            uniform float4 _Emission_Base_Color;
            uniform float4 _Albedo_Base_Color;
            uniform float _Matcap_Emission_Bottom;
            uniform float4 _Incident_Color;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            float3 Colormapping_1( float R , float G , float Curve , float Radius , float OffsetX , float OffsetY ){
            float3 Out;
            float Radius2;
            float X;
            float Y;
            float Z;
            float norm;
            
            Radius2 = Radius * 2;
            X = (R - (OffsetX + 0.5)) * 2 * Curve;
            Y = (G - (OffsetY + 0.5)) * 2 * Curve;
            Z = sqrt(clamp((Radius2 * Radius2 - (X * X + Y * Y)), 0, 1)) * Curve + (1 - Curve);
            norm = sqrt(X * X + Y * Y + Z * Z);
            
            Out.x = X / norm / 2;
            Out.y = Y / norm / 2;
            Out.z = Z / norm;
            
            return Out;
            }
            
            uniform float _LensCurve;
            uniform float _LensRadius;
            uniform float _LensOffsetX;
            uniform float _LensOffsetY;
            uniform fixed _UseLensEffect;
            uniform fixed _UseDistortion;
            uniform fixed _MatcapStyle;
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
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 _UseLensEffect_var = lerp( _NormalMap_var.rgb, Colormapping_1( i.uv0.r , i.uv0.g , _LensCurve , _LensRadius , _LensOffsetX , _LensOffsetY ), _UseLensEffect );
                float3 normalLocal = _UseLensEffect_var;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
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
                float3 specularColor = (_Specular*_Reflection_Color.rgb);
                float specularMonochrome;
                float3 diffuseColor = (_Albedo_Base_Color.rgb+(tex2D( _GrabTexture, lerp( sceneUVs.rg, ((mul( float4(reflect(viewReflectDirection,i.normalDir),0), UNITY_MATRIX_V ).xyz.rgb.rg*pow(1.0-max(0,dot(_UseLensEffect_var, viewDirection)),_Distortion))+sceneUVs.rg), _UseDistortion )).rgb*_Incident_Color.rgb)); // Need this for specular when using metallic
                diffuseColor = EnergyConservationBetweenDiffuseAndSpecular(diffuseColor, specularColor, specularMonochrome);
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
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float2 node_693 = ((lerp( viewReflectDirection, mul( float4(viewReflectDirection,0), UNITY_MATRIX_V ).xyz.rgb, _MatcapStyle ).rg*_Matcap_Scale)+_Matcap_Scale);
                float4 _Matcap_var = tex2D(_Matcap,TRANSFORM_TEX(node_693, _Matcap));
                float node_8494 = 0.0;
                float3 node_5292 = pow((_Matcap_Emission_Bottom + ( ((((max(0,dot(i.normalDir,lightDirection))+pow(max(0,dot(lightDirection,viewReflectDirection)),exp2(2.0)))+sceneColor.rgb+UNITY_LIGHTMODEL_AMBIENT.rgb)*_LightColor0.rgb) - node_8494) * (1.0 - _Matcap_Emission_Bottom) ) / (1.0 - node_8494)),0.5);
                float3 emissive = (_Matcap_var.rgb*((_Reflection_Color.rgb*_Matcap_Strength)*(lerp(float3(1,1,1),saturate(3.0*abs(1.0-2.0*frac((sceneUVs.r*sceneUVs.g*mul( UNITY_MATRIX_V, float4(i.normalDir,0) ).xyz.rgb)+float3(0.0,-1.0/3.0,1.0/3.0)))-1),_Matcap_Hue_Range)*1.0))*((_Emission_Base_Color.rgb*node_5292)+node_5292));
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
            ZWrite Off
            Offset -1, 0
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
            uniform float _Distortion;
            uniform float _Specular;
            uniform float _Gloss;
            uniform float4 _Reflection_Color;
            uniform float _Matcap_Scale;
            uniform sampler2D _Matcap; uniform float4 _Matcap_ST;
            uniform float _Matcap_Strength;
            uniform float _Matcap_Hue_Range;
            uniform float4 _Emission_Base_Color;
            uniform float4 _Albedo_Base_Color;
            uniform float _Matcap_Emission_Bottom;
            uniform float4 _Incident_Color;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            float3 Colormapping_1( float R , float G , float Curve , float Radius , float OffsetX , float OffsetY ){
            float3 Out;
            float Radius2;
            float X;
            float Y;
            float Z;
            float norm;
            
            Radius2 = Radius * 2;
            X = (R - (OffsetX + 0.5)) * 2 * Curve;
            Y = (G - (OffsetY + 0.5)) * 2 * Curve;
            Z = sqrt(clamp((Radius2 * Radius2 - (X * X + Y * Y)), 0, 1)) * Curve + (1 - Curve);
            norm = sqrt(X * X + Y * Y + Z * Z);
            
            Out.x = X / norm / 2;
            Out.y = Y / norm / 2;
            Out.z = Z / norm;
            
            return Out;
            }
            
            uniform float _LensCurve;
            uniform float _LensRadius;
            uniform float _LensOffsetX;
            uniform float _LensOffsetY;
            uniform fixed _UseLensEffect;
            uniform fixed _UseDistortion;
            uniform fixed _MatcapStyle;
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
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 _UseLensEffect_var = lerp( _NormalMap_var.rgb, Colormapping_1( i.uv0.r , i.uv0.g , _LensCurve , _LensRadius , _LensOffsetX , _LensOffsetY ), _UseLensEffect );
                float3 normalLocal = _UseLensEffect_var;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
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
                float3 specularColor = (_Specular*_Reflection_Color.rgb);
                float specularMonochrome;
                float3 diffuseColor = (_Albedo_Base_Color.rgb+(tex2D( _GrabTexture, lerp( sceneUVs.rg, ((mul( float4(reflect(viewReflectDirection,i.normalDir),0), UNITY_MATRIX_V ).xyz.rgb.rg*pow(1.0-max(0,dot(_UseLensEffect_var, viewDirection)),_Distortion))+sceneUVs.rg), _UseDistortion )).rgb*_Incident_Color.rgb)); // Need this for specular when using metallic
                diffuseColor = EnergyConservationBetweenDiffuseAndSpecular(diffuseColor, specularColor, specularMonochrome);
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
                diffuseColor *= 1-specularMonochrome;
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
            Name "Meta"
            Tags {
                "LightMode"="Meta"
            }
            Cull Off
            Offset -1, 0
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
            uniform float _Distortion;
            uniform float _Specular;
            uniform float _Gloss;
            uniform float4 _Reflection_Color;
            uniform float _Matcap_Scale;
            uniform sampler2D _Matcap; uniform float4 _Matcap_ST;
            uniform float _Matcap_Strength;
            uniform float _Matcap_Hue_Range;
            uniform float4 _Emission_Base_Color;
            uniform float4 _Albedo_Base_Color;
            uniform float _Matcap_Emission_Bottom;
            uniform float4 _Incident_Color;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            float3 Colormapping_1( float R , float G , float Curve , float Radius , float OffsetX , float OffsetY ){
            float3 Out;
            float Radius2;
            float X;
            float Y;
            float Z;
            float norm;
            
            Radius2 = Radius * 2;
            X = (R - (OffsetX + 0.5)) * 2 * Curve;
            Y = (G - (OffsetY + 0.5)) * 2 * Curve;
            Z = sqrt(clamp((Radius2 * Radius2 - (X * X + Y * Y)), 0, 1)) * Curve + (1 - Curve);
            norm = sqrt(X * X + Y * Y + Z * Z);
            
            Out.x = X / norm / 2;
            Out.y = Y / norm / 2;
            Out.z = Z / norm;
            
            return Out;
            }
            
            uniform float _LensCurve;
            uniform float _LensRadius;
            uniform float _LensOffsetX;
            uniform float _LensOffsetY;
            uniform fixed _UseLensEffect;
            uniform fixed _UseDistortion;
            uniform fixed _MatcapStyle;
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
            float4 frag(VertexOutput i) : SV_Target {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float2 sceneUVs = (i.projPos.xy / i.projPos.w);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT( UnityMetaInput, o );
                
                float2 node_693 = ((lerp( viewReflectDirection, mul( float4(viewReflectDirection,0), UNITY_MATRIX_V ).xyz.rgb, _MatcapStyle ).rg*_Matcap_Scale)+_Matcap_Scale);
                float4 _Matcap_var = tex2D(_Matcap,TRANSFORM_TEX(node_693, _Matcap));
                float node_8494 = 0.0;
                float3 node_5292 = pow((_Matcap_Emission_Bottom + ( ((((max(0,dot(i.normalDir,lightDirection))+pow(max(0,dot(lightDirection,viewReflectDirection)),exp2(2.0)))+sceneColor.rgb+UNITY_LIGHTMODEL_AMBIENT.rgb)*_LightColor0.rgb) - node_8494) * (1.0 - _Matcap_Emission_Bottom) ) / (1.0 - node_8494)),0.5);
                o.Emission = (_Matcap_var.rgb*((_Reflection_Color.rgb*_Matcap_Strength)*(lerp(float3(1,1,1),saturate(3.0*abs(1.0-2.0*frac((sceneUVs.r*sceneUVs.g*mul( UNITY_MATRIX_V, float4(i.normalDir,0) ).xyz.rgb)+float3(0.0,-1.0/3.0,1.0/3.0)))-1),_Matcap_Hue_Range)*1.0))*((_Emission_Base_Color.rgb*node_5292)+node_5292));
                
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 _UseLensEffect_var = lerp( _NormalMap_var.rgb, Colormapping_1( i.uv0.r , i.uv0.g , _LensCurve , _LensRadius , _LensOffsetX , _LensOffsetY ), _UseLensEffect );
                float3 diffColor = (_Albedo_Base_Color.rgb+(tex2D( _GrabTexture, lerp( sceneUVs.rg, ((mul( float4(reflect(viewReflectDirection,i.normalDir),0), UNITY_MATRIX_V ).xyz.rgb.rg*pow(1.0-max(0,dot(_UseLensEffect_var, viewDirection)),_Distortion))+sceneUVs.rg), _UseDistortion )).rgb*_Incident_Color.rgb));
                float3 specColor = (_Specular*_Reflection_Color.rgb);
                float specularMonochrome = max(max(specColor.r, specColor.g),specColor.b);
                diffColor *= (1.0-specularMonochrome);
                float roughness = 1.0 - _Gloss;
                o.Albedo = diffColor + specColor * roughness * roughness * 0.5;
                
                return UnityMetaFragment( o );
            }
            ENDCG
        }
    }
    FallBack "Particles/Additive"
    CustomEditor "ShaderForgeMaterialInspector"
}
