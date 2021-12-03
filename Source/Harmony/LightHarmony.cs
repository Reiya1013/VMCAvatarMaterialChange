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
        public static void Postfix(LightWithIdManager __instance,int lightId, Color color)
        {
            if (!OtherMaterialChangeSetting.Instance.OtherParameter.IsAmbientLight) return;
            
            if (!Plugin.instance.OptionLight.Lights.ContainsKey(lightId))
                Plugin.instance.OptionLight.AddLight(lightId);

            if (__instance.colors[lightId] != null)
            {
                Plugin.instance.OptionLight.Lights[lightId].color = color;
                Plugin.instance.OptionLight.Lights[lightId].enabled = color.a == 0f ? false : true;
                Plugin.instance.OptionLight.Lights[lightId].intensity = OtherMaterialChangeSetting.Instance.OtherParameter.AmbientLightBoost;
            }
        }
    }

    //Chroma必須のMAPのライト(Chroma入ってるとこっちしか動かん)
    //[HarmonyPatch(typeof(ChromaLightSwitchEventEffect))]
    //static class ChromaLightColorSetHarmony
    //{
    //    [HarmonyPatch(typeof(ChromaLightSwitchEventEffect), "Refresh", MethodType.Normal)]
    //    static void Postfix(ChromaLightSwitchEventEffect __instance, ColorSO ____lightColor0Accessor, ILightWithId selectLights)
    //    {
    //        if (!Plugin.instance.OptionLight.ChromaLights.ContainsKey(__instance))
    //            Plugin.instance.OptionLight.AddLight(__instance);

    //        Plugin.instance.OptionLight.ChromaLights[__instance].color = __instance.ColorTweens[selectLights].toValue;
    //    }
    //}

    [HarmonyPatch(typeof(Chroma.Lighting.ChromaIDColorTween))]
    public static class ChromaLightColorSetHarmony
    {
        [HarmonyPatch(typeof(Chroma.Lighting.ChromaIDColorTween), "SetColor", MethodType.Normal)]
        public static void Postfix(Chroma.Lighting.ChromaIDColorTween __instance, ILightWithId ____lightWithId, Color color)
        {
            if (!OtherMaterialChangeSetting.Instance.OtherParameter.IsAmbientLight) return;
            if (!Plugin.instance.IsChroma) return;

            if (!Plugin.instance.OptionLight.Lights.ContainsKey(____lightWithId.lightId))
            Plugin.instance.OptionLight.AddLight(____lightWithId.lightId);

            Plugin.instance.OptionLight.Lights[____lightWithId.lightId].color = color;
            Plugin.instance.OptionLight.Lights[____lightWithId.lightId].enabled = color.a == 0f ? false : true;
            Plugin.instance.OptionLight.Lights[____lightWithId.lightId].intensity = OtherMaterialChangeSetting.Instance.OtherParameter.AmbientLightBoost;
        }
    }

    //本当はOnEnableで取りたいけど、こっちのほうが起動が遅いと取れないため仕方なく・・・
    [HarmonyPatch(typeof(LightController), "OnDirectionalLightTransformAndColor", MethodType.Normal)]
    public static class LightControllerHarmony
    {
        public static void Postfix(LightController __instance)
        {
            if (!Plugin.instance.OptionLight.VMCLight)
            {
                Plugin.instance.OptionLight.VMCLight = __instance.VMCLight;
            }
            //if (Plugin.instance.OptionLight.IsVMCLightBoost)
            //{
            //    Color color = __instance.VMCLight.color;
            //    color.a *= Plugin.instance.OptionLight.VMCLightBoost;
            //    __instance.VMCLight.color = color;
            //}
        }
    }


}
