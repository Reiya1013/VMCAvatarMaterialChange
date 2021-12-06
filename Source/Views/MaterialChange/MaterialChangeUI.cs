using UnityEngine;
using BeatSaberMarkupLanguage.Attributes;
using BeatSaberMarkupLanguage.ViewControllers;
using BeatSaberMarkupLanguage.Components;
using HMUI;
using System.IO;

namespace VMCAvatarMaterialChange.Views.MaterialChange
{
    class MaterialChangeUI : BSMLAutomaticViewController
    {
        //public override string ResourceName => "VMCAvatarMaterialChange.Views.MaterialChange.MaterialChangeUI.bsml";

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
            OtherMaterialChangeSetting.Instance.SaveConfiguration();
            VMCMaterialChange.instance.VRMCopyDestroy();
            base.DidDeactivate(removedFromHierarchy, screenSystemDisabling);
        }



        [UIComponent("MaterialChangeList")]
        private CustomListTableData materialNameList = new CustomListTableData();
        private int selectRow;
        [UIAction("materialSelect")]
        private void Select(TableView _, int row)
        {
            selectRow = row;
        }

        //[UIComponent("MaterialChangeList2")]
        //private CustomListTableData materialNameList2 = new CustomListTableData();
        //private int selectRow2;
        //[UIAction("materialSelect2")]
        //private void Select2(TableView _, int row)
        //{
        //    selectRow2 = row;
        //}

        //[UIComponent("MaterialChangeList3")]
        //private CustomListTableData materialNameList3 = new CustomListTableData();
        //private int selectRow3;
        //[UIAction("materialSelect3")]
        //private void Select3(TableView _, int row)
        //{
        //    selectRow3 = row;
        //}


        [UIValue("AutoChangeToggle")]
        private bool autoChange = OtherMaterialChangeSetting.Instance.OtherParameter.AutoMaterialChange;
        [UIAction("OnAutoChangeStateChange")]
        private void OnSaveStateChange(bool value)
        {
            OtherMaterialChangeSetting.Instance.OtherParameter.AutoMaterialChange = autoChange = value;
        }


        [UIAction("goMaterialChange")]
        private void GoMaterialChange()
        {
            Logger.log.Debug($"autoChange {autoChange}");
            OtherMaterialChangeSetting.Instance.OtherParameter.AutoMaterialChange = autoChange;
            SharedCoroutineStarter.instance.StartCoroutine(VMCMaterialChange.instance.OtherMaterialStartup(selectRow));
            //SharedCoroutineStarter.instance.StartCoroutine(VMCMaterialChange.instance.OtherMaterialStartup(selectRow, selectRow2, selectRow3));
        }
        [UIAction("Save")]
        private void Save()
        {
            Logger.log.Debug($"autoChange {autoChange}");
            OtherMaterialChangeSetting.Instance.OtherParameter.AutoMaterialChange = autoChange;
            VMCMaterialChange.instance.OtherSettingSet(selectRow, 0, 0);
            //VMCMaterialChange.instance.OtherSettingSet(selectRow, selectRow2, selectRow3);
        }


        [UIAction("#post-parse")]
        public void SetupList()
        {

            materialNameList.data.Clear();
            //materialNameList2.data.Clear();
            //materialNameList3.data.Clear();
            materialNameList.data.Add(new CustomListTableData.CustomCellInfo("None"));
            //materialNameList2.data.Add(new CustomListTableData.CustomCellInfo("None"));
            //materialNameList3.data.Add(new CustomListTableData.CustomCellInfo("None"));
            var names = VMCMaterialChange.instance.GetMaterialsName();
            if (names != null)
                foreach (var materialName in names)
                {
                    var customCellInfo = new CustomListTableData.CustomCellInfo(materialName);
                    materialNameList.data.Add(customCellInfo);
                    //materialNameList2.data.Add(customCellInfo);
                    //materialNameList3.data.Add(customCellInfo);
                }

            materialNameList.tableView.ReloadData();
            //materialNameList2.tableView.ReloadData();
            //materialNameList3.tableView.ReloadData();

            Logger.log.Debug($"Row Select {VMCMaterialChange.instance.VRMMetaKey}");
            if (OtherMaterialChangeSetting.Instance.OtherParameter.List.ContainsKey(VMCMaterialChange.instance.VRMMetaKey))
            {
                for (int i =0; i < materialNameList.data.Count; i++)
                    if (materialNameList.data[i].text == Path.GetFileName(OtherMaterialChangeSetting.Instance.OtherParameter.List[VMCMaterialChange.instance.VRMMetaKey].FileAddress1))
                    { selectRow = i; break; }

                //for (int i = 0; i < materialNameList2.data.Count; i++)
                //    if (materialNameList2.data[i].text == Path.GetFileName(OtherMaterialChangeSetting.Instance.OtherParameter.List[VMCMaterialChange.instance.VRMMetaKey].FileAddress2))
                //    { selectRow2 = i; break; }

                //for (int i = 0; i < materialNameList3.data.Count; i++)
                //    if (materialNameList3.data[i].text == Path.GetFileName(OtherMaterialChangeSetting.Instance.OtherParameter.List[VMCMaterialChange.instance.VRMMetaKey].FileAddress3))
                //    { selectRow3 = i; break; }
            }
            if (materialNameList.data.Count > 0)
            {
                materialNameList.tableView.SelectCellWithIdx(selectRow);
                //materialNameList2.tableView.SelectCellWithIdx(selectRow2);
                //materialNameList3.tableView.SelectCellWithIdx(selectRow3);
                materialNameList.tableView.ScrollToCellWithIdx(selectRow, TableView.ScrollPositionType.Beginning, false);
                //materialNameList2.tableView.ScrollToCellWithIdx(selectRow2, TableView.ScrollPositionType.Beginning, false);
                //materialNameList3.tableView.ScrollToCellWithIdx(selectRow3, TableView.ScrollPositionType.Beginning, false);
            }
        }

        #region AvatarCopy


        [UIAction("copy-avatarWPos")]
        private void AvatarCopyWPos()
        {
            VMCMaterialChange.instance.VRMCopy(true);
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
            VMCMaterialChange.instance.VRMCopy(false);
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
            VMCMaterialChange.instance.VRMCopyDestroy();
        }

        #endregion


        #region AvatarLight

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

        #endregion
    }
}
