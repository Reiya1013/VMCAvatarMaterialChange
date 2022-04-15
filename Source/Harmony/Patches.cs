using HarmonyLib;
using System;
using System.Reflection;
//using VMCAvatar;
using VRM;
using static VRM.VRMFirstPerson;

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
            Logger.log?.Warn("Applying Harmony patches.");
            Patch(typeof(UniGLTF.ImporterContext).GetMethod("ShowMeshes"), new HarmonyMethod(typeof(VRMHarmony).GetMethod("Prefix")), null);
            //Patch(typeof(VRMFirstPerson).GetMethod("Setup", new Type[] { typeof(bool), typeof(SetVisiblityFunc) }), new HarmonyMethod(typeof(VRMFirstPerson_Setup).GetMethod("Prefix")), null);
            //Patch(typeof(SetSaberGlowColor).GetMethod("SetColors"), null, new HarmonyMethod(typeof(SetSaberGlowColorHarmony).GetMethod("Postfix")));
            if (Plugin.instance.IsChroma)
            {
                ChromaPatch();
            }
            else
            {
                Patch(typeof(LightWithIdManager).GetMethod("SetColorForId"), null, new HarmonyMethod(typeof(LightHarmony).GetMethod("Postfix")));
            }

        }

        private void ChromaPatch()
        {
            Patch(typeof(Chroma.Lighting.ChromaIDColorTween).GetMethod("SetColor"), null, new HarmonyMethod(typeof(ChromaLightColorSetHarmony).GetMethod("Postfix")));
        }

        private void Patch(MethodInfo original, HarmonyMethod prefix, HarmonyMethod postfix)
        {
            try
            {
                harmony.Patch(original, prefix, postfix);
                Logger.log?.Debug($"Setup Harmony patch: {original.Name}");
            }
            catch (Exception ex)
            {
                Logger.log?.Warn($"Error applying Harmony patch: {ex.Message}");
                Logger.log?.Warn(ex);
            }
        }

        public void Disable()
        {
            try
            {
                Logger.log?.Debug("Removing Harmony patches.");
                harmony.UnpatchSelf();
            }
            catch (Exception ex)
            {
                Logger.log?.Warn($"Error removing Harmony patches: {ex.Message}");
                Logger.log?.Warn(ex);
            }
        }
    }
}
