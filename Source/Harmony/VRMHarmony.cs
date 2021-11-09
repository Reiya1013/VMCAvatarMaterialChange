using System;
using HarmonyLib;
using UnityEngine;
using VRM;

namespace VMCAvatarMaterialChange
{
    [HarmonyPatch(typeof(UniGLTF.ImporterContext), "ShowMeshes", MethodType.Normal)]
    class VRMHarmony
    {

        /// <summary>
        /// ロード済のアバターを表示するUniVRMのメソッドをHarmonyで割り込んでマテリアルチェンジする
        /// </summary>
        /// <param name="__instance"></param>
        static void Prefix(UniGLTF.ImporterContext __instance)
        {
            try
            {
                Logger.log.Debug($"Harmony ShowMeshes");

                //マテリアルチェンジOFF時は処理を飛ばす
                //if (Settings.instance.MaterialChange_value == MaterialChange.OFF) return;
                Logger.log.Debug($"Harmony ChangeMaterial Start");

                //マテリアル変更
                SharedCoroutineStarter.instance.StartCoroutine(Plugin.VMCMC.ChangeMaterial(__instance));

                Logger.log.Debug($"Harmony ChangeMaterial End");
            }
            catch (System.Exception e)
            {
                Logger.log.Debug($"Harmony ShowMeshes Err {e.Message}");
            }
        }
    }

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
    //            //Plugin.VMCMC.ChangeMaterial(__instance);

    //            Logger.log.Debug($"Harmony AddMaterial End");
    //        }
    //        catch (System.Exception e)
    //        {
    //            Logger.log.Debug($"Harmony ShowMeshes Err {e.Message}");
    //        }
    //    }
    //}
}
