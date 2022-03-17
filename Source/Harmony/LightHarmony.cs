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

    //[HarmonyPatch(typeof(SetSaberGlowColor), "SetColors", MethodType.Normal)]
    //public static class SetSaberGlowColorHarmony
    //{
    //    public static void Postfix(SetSaberGlowColor __instance, SaberType ____saberType, ColorManager ____colorManager)
    //    {
    //        if (____colorManager is null) return;
    //        if (__instance.transform is null) return;
    //        if (__instance.transform.name != "SaberGlowingEdges") return;
    //        Plugin.instance.OptionLight.AddSaberLight(____saberType, __instance.gameObject, ____colorManager.ColorForSaberType(____saberType));


    //        //Logger.log?.Warn($"SaberLight Setup Parent: {__instance.transform.name}");
    //        //Logger.log?.Warn($"SaberLight Setup Parent: { Plugin.instance.OptionLight.SaberLights[____saberType] is null}");
    //        //Logger.log?.Warn($"SaberLight Setup Parent: { Plugin.instance.OptionLight.SaberLights[____saberType].gameObject is null}");
    //        //Logger.log?.Warn($"SaberLight Setup Parent: { Plugin.instance.OptionLight.SaberLights[____saberType].transform.name}");
    //        //Plugin.instance.OptionLight.SaberLights[____saberType].transform.SetParent(__instance.transform);
    //        //Plugin.instance.OptionLight.SaberLights[____saberType].color = ____colorManager.ColorForSaberType(____saberType);

    //        //if (____saberType == SaberType.SaberA)
    //        //{


    //        //    //Logger.log?.Warn($"RightSaberLight Setup Parent: {__instance.transform} {Plugin.instance.OptionLight.RightSaberLight.transform.parent.name}");
    //        //    //Logger.log?.Warn($"RightSaberLight Setup Color: {____colorManager is null} {Plugin.instance.OptionLight.RightSaberLight.transform.parent.name}");
    //        //}
    //        //else if (____saberType == SaberType.SaberB)
    //        //{
    //        //    //Logger.log?.Warn($"LeftSaberLight Setup: {Plugin.instance.OptionLight.LeftSaberLight is null} {Plugin.instance.OptionLight.LeftSaberLight.transform.parent.name}");
    //        //    //Plugin.instance.OptionLight.LeftSaberLight.transform.parent = __instance.transform;
    //        //    //Logger.log?.Warn($"LeftSaberLight Setup Parent: {__instance.transform} {Plugin.instance.OptionLight.LeftSaberLight.transform.parent.name}");
    //        //    //Logger.log?.Warn($"LeftSaberLight Setup Color: {____colorManager is null} {Plugin.instance.OptionLight.LeftSaberLight.transform.parent.name}");
    //        //    //Plugin.instance.OptionLight.LeftSaberLight.color = ____colorManager.ColorForSaberType(____saberType);
    //        //}
    //    }

    //}
}
