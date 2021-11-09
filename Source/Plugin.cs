using BeatSaberMarkupLanguage.Settings;
using IPA;
using IPA.Config;
using IPA.Config.Stores;
using UnityEngine;
using IPALogger = IPA.Logging.Logger;

namespace VMCAvatarMaterialChange
{

    [Plugin(RuntimeOptions.SingleStartInit)]
    internal class Plugin
    {
        internal static Plugin instance { get; private set; }
        internal static string Name => "VMCAvatarMaterialChange";

        //マテリアルチェンジクラス
        internal static VMCMaterialChange VMCMC = new VMCMaterialChange();

        [Init]
        /// <summary>
        /// Called when the plugin is first loaded by IPA (either when the game starts or when the plugin is enabled if it starts disabled).
        /// [Init] methods that use a Constructor or called before regular methods like InitWithConfig.
        /// Only use [Init] with one Constructor.
        /// </summary>
        public void Init(IPALogger logger, IPA.Config.Config conf)
        {
            instance = this;
            Logger.log = logger;
            Logger.log.Debug("Logger initialized.");

            PluginConfig.Instance = conf.Generated<PluginConfig>();
            Logger.log.Debug($"LoadConfig");
        }

        #region BSIPA Config
        //Uncomment to use BSIPA's config
        /*
        [Init]
        public void InitWithConfig(Config conf)
        {
            Configuration.PluginConfig.Instance = conf.Generated<Configuration.PluginConfig>();
            Logger.log.Debug("Config loaded");
        }
        */
        #endregion

        [OnStart]
        public void OnApplicationStart()
        {
            Logger.log.Debug("OnApplicationStart");
            new GameObject("VMCAvatarMaterialChangeController").AddComponent<VMCAvatarMaterialChangeController>();
            BSMLSettings.instance.AddSettingsMenu("VMC Avatar MC", "VMCAvatarMaterialChange.Views.VMCAvatarMCSetting.settings.bsml", Settings.instance);

            //JSON Load
            OtherMaterialChangeSetting.Instance.LoadConfiguration();

            ////コントローラーInstance
            //PersistentSingleton<BehaviorCatalog>.TouchInstance();
            //BehaviorCatalog.instance.LoadStartBehaviors();
        }

        [OnExit]
        public void OnApplicationQuit()
        {
            Logger.log.Debug("OnApplicationQuit");

        }
    }
}
