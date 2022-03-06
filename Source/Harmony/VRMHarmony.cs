using System;
using HarmonyLib;
using UnityEngine;
using VRM;
using VMCAvatar;

namespace VMCAvatarMaterialChange
{
    [HarmonyPatch(typeof(UniGLTF.ImporterContext), "ShowMeshes", MethodType.Normal)]
    public static class VRMHarmony
    {
        /// <summary>
        /// ロード済のアバターを表示するUniVRMのメソッドをHarmonyで割り込んでマテリアルチェンジする
        /// </summary>
        /// <param name="__instance"></param>
        public static void Prefix(UniGLTF.ImporterContext __instance)
        {
            try
            {
                Logger.log.Debug($"Harmony ShowMeshes");

                //マテリアルチェンジOFF時は処理を飛ばす
                //if (Settings.instance.MaterialChange_value == MaterialChange.OFF) return;
                Logger.log.Debug($"Harmony ChangeMaterial Start");

                //マテリアル変更
                SharedCoroutineStarter.instance.StartCoroutine(VMCMaterialChange.instance.ChangeMaterial(__instance));

                Logger.log.Debug($"Harmony ChangeMaterial End");
            }
            catch (System.Exception e)
            {
                Logger.log.Debug($"Harmony ShowMeshes Err {e.Message}");
            }
        }
    }

    //[HarmonyPatch(typeof(VRMFirstPerson), "Setup", MethodType.Normal)]
    //public static class VRMFirstPerson_Setup
    //{
    //    public static void Prefix(VRMFirstPerson __instance)
    //    {
    //        VMCMaterialChange.instance.SetVRMFirstPerson(__instance);
    //    }
    //}

    //[HarmonyPatch(typeof(VRCenterAdjust), "Update", MethodType.Normal)]
    //class VMCAvatar_RoomAjust
    //{
    //    static void Prefix(VRCenterAdjust __instance)
    //    {
    //        if (!Plugin.instance.RoomAjust.CenterAdjust)
    //            Plugin.instance.RoomAjust.SetupVRCenterAdjust( __instance);
    //    }
    //}


    //[HarmonyPatch(typeof(UniGLTF.ImporterContext), "AddMaterial", MethodType.Normal)]
    //class VRMHarmony_AddMaterial
    //{

    //    /// <summary>
    //    /// ロード済のアバターを表示するUniVRMのメソッドをHarmonyで割り込んでマテリアルチェンジする
    //    /// </summary>
    //    /// <param name="__instance"></param>
    //    static void Postfix(Material material)
    //    {
    //        try
    //        {
    //            Logger.log.Debug($"Harmony AddMaterial");

    //            //マテリアルチェンジOFF時は処理を飛ばす
    //            //if (Settings.instance.MaterialChange_value == MaterialChange.OFF) return;
    //            Logger.log.Debug($"Harmony AddMaterial Start");

    //            Logger.log.Debug($"Harmony AddMaterial GetMaterialName {material.name} {material.shader.name}");

    //            //マテリアル変更
    //            //VMCMaterialChange.instance.ChangeMaterial(__instance);

    //            Logger.log.Debug($"Harmony AddMaterial End");
    //        }
    //        catch (System.Exception e)
    //        {
    //            Logger.log.Debug($"Harmony ShowMeshes Err {e.Message}");
    //        }
    //    }
    //}
}
