using HarmonyLib;
using System;

namespace VMCAvatarMaterialChange.HarmonyPatches
{
    public class Patcher
    {
        private string harmonyId;
        private Harmony harmony;

        public Patcher(string id)
        {
            harmonyId = id;
            harmony = new Harmony(id);
        }

        public void Enable()
        {
            try
            {
                Logger.log?.Warn("Applying Harmony patches.");
                harmony.PatchAll();
            }
            catch (Exception ex)
            {
                Logger.log?.Warn($"Error applying Harmony patches: {ex.Message}");
                Logger.log?.Warn(ex);
            }
        }

        public void Disable()
        {
            try
            {
                Logger.log?.Warn("Removing Harmony patches.");
                harmony.UnpatchAll(harmonyId);
            }
            catch (Exception ex)
            {
                Logger.log?.Warn($"Error removing Harmony patches: {ex.Message}");
                Logger.log?.Warn(ex);
            }
        }
    }
}
