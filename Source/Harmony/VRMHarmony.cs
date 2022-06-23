using System;
using HarmonyLib;
using UniGLTF;
using UnityEngine;
using VRM;
using VMCAvatar;
using OscJack;
using System.Collections.Generic;

namespace VMCAvatarMaterialChange
{
    [HarmonyPatch(typeof(RuntimeGltfInstance), "ShowMeshes", MethodType.Normal)]
    public static class VRMHarmony
    {
        /// <summary>
        /// ロード済のアバターを表示するUniVRMのメソッドをHarmonyで割り込んでマテリアルチェンジする
        /// </summary>
        /// <param name="__instance"></param>
        public static void Prefix(RuntimeGltfInstance __instance)
        {
            try
            {
                Logger.log.Debug($"Harmony ShowMeshes");

                //マテリアルチェンジOFF時は処理を飛ばす
                //if (Settings.instance.MaterialChange_value == MaterialChange.OFF) return;
                Logger.log.Debug($"Harmony ChangeMaterial Start");

                //マテリアル変更
                SharedCoroutineStarter.instance.StartCoroutine(VMCMaterialChange.instance.ChangeMaterial(__instance));

                //表情変更イベントオブジェクト追加
                __instance.gameObject.AddComponent<BlendShapeChanger>();

                Plugin.instance.DisposeVRMOff = false;

                Logger.log.Debug($"Harmony ChangeMaterial End");
            }
            catch (System.Exception e)
            {
                Logger.log.Debug($"Harmony ShowMeshes Err {e.Message}");
            }
        }
    }

    [HarmonyPatch(typeof(RuntimeGltfInstance), "Dispose", MethodType.Normal)]
    public static class VRMDisposeHarmony
    {
        /// <summary>
        /// アバター情報開放処理を中断して、情報保持する
        /// </summary>
        /// <param name="__instance"></param>
        public static bool Prefix(RuntimeGltfInstance __instance)
        {
            if (Plugin.instance.DisposeVRMOff == false) return true;
            Logger.log.Debug($"VRMDisposeHarmony Stop");

            return false;
        }
    }

    //[HarmonyPatch(typeof(VMCProtocol.Marionette), "OscOnBlendShapProxyValue", MethodType.Normal)]
    //public static class MarionetteOscOnBlendShapProxyValueHarmony
    //{
    //    public static bool StopAutoBlendShape = false;
    //    public static bool StopAutoBlink = false;
    //    public static bool StopLipSync = false;

    //    public static bool Prefix(VMCProtocol.Marionette __instance, OscDataHandle data,ref Dictionary<string, float> ____constructingBlendShapes)
    //    {
    //        string keyName = data.GetElementAsString(0);

    //        Logger.log.Debug($"MarionetteOscOnBlendShapProxyValueHarmony Key{keyName}");

    //        //表情停止中はすべて拒否
    //        if (StopAutoBlendShape == true) return false;

    //        //瞬き許可にまばたきがきたら許可
    //        bool ret = false;
    //        if (StopAutoBlink == false && keyName == "Blink")
    //        {
    //            ret = true;
    //        }
    //        else
    //        {
    //            if (____constructingBlendShapes.ContainsKey("Blink"))
    //                ____constructingBlendShapes.Remove("Blink");
    //        }
    //        //リップシンク許可時にAIUEOが来たら許可
    //        if (StopLipSync == false)
    //        {
    //            if (keyName == "A" ||
    //                keyName == "I" ||
    //                keyName == "U" ||
    //                keyName == "E" ||
    //                keyName == "O")
    //                ret = true;
    //        }
    //        else
    //        {
    //            if (____constructingBlendShapes.ContainsKey("A"))
    //                ____constructingBlendShapes.Remove("A");
    //            if (____constructingBlendShapes.ContainsKey("I"))
    //                ____constructingBlendShapes.Remove("I");
    //            if (____constructingBlendShapes.ContainsKey("U"))
    //                ____constructingBlendShapes.Remove("U");
    //            if (____constructingBlendShapes.ContainsKey("E"))
    //                ____constructingBlendShapes.Remove("E");
    //            if (____constructingBlendShapes.ContainsKey("O"))
    //                ____constructingBlendShapes.Remove("O");

    //        }

    //        return ret;

    //    }
    //}


    [HarmonyPatch(typeof(VMCProtocol.Marionette), "OscOnBlendShapProxyValue", MethodType.Normal)]
    public static class MarionetteOscOnBlendShapProxyApplyHarmony
    {
        public static bool StopAutoBlendShape = false;
        public static bool StopAutoBlink = false;
        public static bool StopLipSync = false;

        public static bool Prefix(VMCProtocol.Marionette __instance, OscDataHandle data, ref Dictionary<string, float> ____constructingBlendShapes)
        {
            //表情停止中はすべて拒否
            if (StopAutoBlendShape == true)
            {
                ____constructingBlendShapes.Clear();
                return false;
            }

            if (____constructingBlendShapes is null || ____constructingBlendShapes.Count == 0)
                return true;

            //Prefix結果判定
            string keyName = data.GetElementAsString(0);

            Logger.log.Debug($"MarionetteOscOnBlendShapProxyValueHarmony Key{keyName}");

            //表情停止中はすべて拒否
            if (StopAutoBlendShape == true) return false;

            //瞬き許可にまばたきがきたら許可
            bool ret = false;
            if (StopAutoBlink == false && keyName == "Blink")
            {
                ret = true;
            }
            //リップシンク許可時にAIUEOが来たら許可
            if (StopLipSync == false)
            {
                if (keyName == "A" ||
                    keyName == "I" ||
                    keyName == "U" ||
                    keyName == "E" ||
                    keyName == "O")
                    ret = true;
            }

            //設定済みKey削除
            List<string> delList = new List<string>();
            foreach (var blendShape in ____constructingBlendShapes)
            {
                bool addflg = true;
                if (StopAutoBlink == false && blendShape.Key == "Blink")
                {
                    addflg = false;
                }
                if (StopLipSync == false)
                {
                    if (blendShape.Key == "A" ||
                        blendShape.Key == "I" ||
                        blendShape.Key == "U" ||
                        blendShape.Key == "E" ||
                        blendShape.Key == "O")
                    {
                        addflg = false;
                    }
                }
                
                if (addflg == true)
                    delList.Add(blendShape.Key);
            }



            if (delList.Count > 0)
                foreach (var delname in delList)
                {
                    ____constructingBlendShapes.Remove(delname);
                }

            return ret;
        }
    }

    //[HarmonyPatch(typeof(VRMBlendShapeProxy), "AccumulateValue", MethodType.Normal)]
    //public static class VRMBlendShapeProxyDisable
    //{
    //    public static bool StopAutoBlendShape = false;
    //    public static bool StopAutoBlink = false;
    //    public static bool StopLipSync = false;


    //    /// <summary>
    //    /// 表情制御OFF
    //    /// </summary>
    //    /// <param name="__instance"></param>
    //    public static bool Prefix(VRMBlendShapeProxy __instance, BlendShapeKey key)
    //    {
    //        var keyName = key.Name.ToUpper();

    //        //表情停止中はすべて拒否
    //        if (StopAutoBlendShape == true) return false;

    //        //瞬き許可にまばたきがきたら許可
    //        bool ret = false;
    //        if (StopAutoBlink == false && keyName.Contains("BLINK")) ret = true;

    //        //リップシンク許可時にAIUEOが来たら許可
    //        if (StopLipSync == false)
    //        {
    //            if (keyName.Contains("A") ||
    //                keyName.Contains("I") ||
    //                keyName.Contains("U") ||
    //                keyName.Contains("E") ||
    //                keyName.Contains("O"))
    //                ret = true;
    //        }
    //        return ret;
    //    }
    //}

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
