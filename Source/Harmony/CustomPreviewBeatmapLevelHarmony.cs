using System;
using System.IO;
using HarmonyLib;
using UniGLTF;
using UnityEngine;
using VRM;
using VMCAvatar;
namespace VMCAvatarMaterialChange
{
    [HarmonyPatch(typeof(CustomPreviewBeatmapLevel), nameof(CustomPreviewBeatmapLevel.GetCoverImageAsync))]
    public static class CustomPreviewBeatmapLevelHarmony
    {
        private static string _latestSelectedSong = string.Empty;
        public static string customLevelPath = string.Empty;
        static void Postfix(CustomPreviewBeatmapLevel __instance)
        {

            if (__instance.customLevelPath != _latestSelectedSong && __instance.customLevelPath != string.Empty)
            {
                _latestSelectedSong = __instance.customLevelPath;

                Logger.log.Notice($"Selected CustomLevel Path :\n {__instance.customLevelPath}");

                if (File.Exists(Path.Combine(__instance.customLevelPath, "NalulunaAvatarsEvents.json")))
                    customLevelPath = Path.Combine(__instance.customLevelPath, "NalulunaAvatarsEvents.json");
                else
                    customLevelPath = string.Empty;
            }
        }
    }

}
