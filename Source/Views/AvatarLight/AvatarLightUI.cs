using UnityEngine;
using BeatSaberMarkupLanguage.Attributes;
using BeatSaberMarkupLanguage.ViewControllers;
using HMUI;

namespace VMCAvatarMaterialChange.Views.AvatarLight
{
    class AvatarLightUI : BSMLAutomaticViewController
    {
        public ModMainFlowCoordinator_AvatarLight mainFlowCoordinator { get; set; }
        public void SetMainFlowCoordinator(ModMainFlowCoordinator_AvatarLight mainFlowCoordinator)
        {
            this.mainFlowCoordinator = mainFlowCoordinator;
        }
        protected override void DidActivate(bool firstActivation, bool addedToHierarchy, bool screenSystemEnabling)
        {
            base.DidActivate(firstActivation, addedToHierarchy, screenSystemEnabling);
        }
        protected override void DidDeactivate(bool removedFromHierarchy, bool screenSystemDisabling)
        {
            OtherMaterialChangeSetting.Instance.SaveConfiguration();
            base.DidDeactivate(removedFromHierarchy, screenSystemDisabling);
        }


        [UIValue("AmbientLight")]
        private bool IsAmbientLight = OtherMaterialChangeSetting.Instance.OtherParameter.IsAmbientLight;
        [UIAction("AmbientLightChange")]
        private void AmbientLightChange(bool value)
        {
            OtherMaterialChangeSetting.Instance.OtherParameter.IsAmbientLight = IsAmbientLight = value;
        }

        [UIValue("VMCLightBoost")]
        private float VMCLightBoost = OtherMaterialChangeSetting.Instance.OtherParameter.VMCLightBoost;
        [UIAction("VMCLightBoostChange")]
        private void VMCLightBoostChange(float value)
        {
            OtherMaterialChangeSetting.Instance.OtherParameter.VMCLightBoost = VMCLightBoost = value;
        }

        [UIValue("AmbientLightBoost")]
        private float AmbientLightBoost = OtherMaterialChangeSetting.Instance.OtherParameter.AmbientLightBoost;
        [UIAction("AmbientLightBoostChange")]
        private void AmbientLightBoostChange(float value)
        {
            OtherMaterialChangeSetting.Instance.OtherParameter.AmbientLightBoost = AmbientLightBoost = value;
        }

    }
}
