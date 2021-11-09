﻿using UnityEngine;
using BeatSaberMarkupLanguage.Attributes;
using BeatSaberMarkupLanguage.ViewControllers;
using HMUI;

namespace VMCAvatarMaterialChange.Views.AvatarCopy
{
    class AvatarCopyUI : BSMLAutomaticViewController
    {
        public ModMainFlowCoordinator mainFlowCoordinator { get; set; }
        public void SetMainFlowCoordinator(ModMainFlowCoordinator mainFlowCoordinator)
        {
            this.mainFlowCoordinator = mainFlowCoordinator;
        }
        protected override void DidActivate(bool firstActivation, bool addedToHierarchy, bool screenSystemEnabling)
        {
            base.DidActivate(firstActivation, addedToHierarchy, screenSystemEnabling);
        }
        protected override void DidDeactivate(bool removedFromHierarchy, bool screenSystemDisabling)
        {
            Plugin.VMCMC.VRMCopyDestroy();
            base.DidDeactivate(removedFromHierarchy, screenSystemDisabling);
        }


        [UIAction("copy-avatarWPos")]
        private void AvatarCopyWPos()
        {
            Plugin.VMCMC.VRMCopy(true);
        }
        [UIAction("copy-avatarWPosTimer")]
        private void AvatarCopyWPosTime()
        {
            VMCAvatarMaterialChangeController.CopyMode = true;
            VMCAvatarMaterialChangeController.CopyStart = true;
        }
        [UIAction("copy-avatarAPos")]
        private void AvatarCopyAPos()
        {
            Plugin.VMCMC.VRMCopy(false);
        }
        [UIAction("copy-avatarAPosTimer")]
        private void AvatarCopyAPoTime()
        {
            VMCAvatarMaterialChangeController.CopyMode = false;
            VMCAvatarMaterialChangeController.CopyStart = true;
        }


        [UIValue("DestroyState")]
        private bool DestroyState = VMCAvatarMaterialChangeController.AutoDestroy;
        [UIAction("auto-AvatarDestroyStateChange")]
        private void AvatarDestroyStateChange(bool value)
        {
            VMCAvatarMaterialChangeController.AutoDestroy = DestroyState = value;
        }

        [UIAction("copy-avatarDestroy")]
        private void AvatarDestroy()
        {
            Plugin.VMCMC.VRMCopyDestroy();
        }

    }
}
