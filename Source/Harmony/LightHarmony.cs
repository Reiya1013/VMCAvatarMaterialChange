using System;
using HarmonyLib;
using UnityEngine;
using VMCAvatar;
using System.Collections.Generic;

namespace VMCAvatarMaterialChange
{
    //標準のライト
    [HarmonyPatch(typeof(LightWithIdManager), "SetColorForId", MethodType.Normal)]
    public static class LightHarmony
    {
        public static void Postfix(LightWithIdManager __instance,int lightId, Color color,Color[] ____colors)
        {
            if (!OtherMaterialChangeSetting.Instance.OtherParameter.IsAmbientLight) return;
            
            if (!Plugin.instance.OptionLight.Lights.ContainsKey(lightId))
                Plugin.instance.OptionLight.AddLight(lightId);

            if (____colors[lightId] != null)
            {
                Plugin.instance.OptionLight.Lights[lightId].color = color;
                Plugin.instance.OptionLight.Lights[lightId].enabled = color.a == 0f ? false : true;
                Plugin.instance.OptionLight.Lights[lightId].intensity = OtherMaterialChangeSetting.Instance.OtherParameter.AmbientLightBoost;
            }
        }
    }

    [HarmonyPatch(typeof(Chroma.Lighting.ChromaIDColorTween), "SetColor", MethodType.Normal)]
    public static class ChromaLightColorSetHarmony
    {
        public static void Postfix(Chroma.Lighting.ChromaIDColorTween __instance, ILightWithId ____lightWithId, Color color)
        {
            if (!OtherMaterialChangeSetting.Instance.OtherParameter.IsAmbientLight) return;
            if (!Plugin.instance.IsChroma) return;

            if (!Plugin.instance.OptionLight.Lights.ContainsKey(____lightWithId.lightId))
            Plugin.instance.OptionLight.AddLight(____lightWithId.lightId);

            Plugin.instance.OptionLight.Lights[____lightWithId.lightId].color = color;
            Plugin.instance.OptionLight.Lights[____lightWithId.lightId].enabled = color.a <= 0.1f ? false : true;
            Plugin.instance.OptionLight.Lights[____lightWithId.lightId].intensity = OtherMaterialChangeSetting.Instance.OtherParameter.AmbientLightBoost;
        }
    }

    ////本当はOnEnableで取りたいけど、こっちのほうが起動が遅いと取れないため仕方なく・・・
    //[HarmonyPatch(typeof(LightController), "OnDirectionalLightTransformAndColor", MethodType.Normal)]
    //public static class LightControllerHarmony
    //{
    //    public static void Postfix(LightController __instance)
    //    {
    //        if (!Plugin.instance.OptionLight.VMCLight)
    //        {
    //            Plugin.instance.OptionLight.VMCLight = __instance.VMCLight;
    //        }
    //        //if (Plugin.instance.OptionLight.IsVMCLightBoost)
    //        //{
    //        //    Color color = __instance.VMCLight.color;
    //        //    color.a *= Plugin.instance.OptionLight.VMCLightBoost;
    //        //    __instance.VMCLight.color = color;
    //        //}
    //    }
    //}

}
