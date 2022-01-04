using System;
using System.Reflection;
using System.Collections.Generic;
using UnityEngine;
using UniGLTF;
using System.IO;
using VRM;
using System.Linq;
using System.Collections;
using VMCAvatar;

namespace VMCAvatarMaterialChange
{
    class VMCMaterialChange
    {
        internal static VMCMaterialChange instance { get; private set; } = new VMCMaterialChange();

        //Shader Asset
        UnityEngine.Object[] Assets;
        private Dictionary<string, Shader> Shaders = new Dictionary<string, Shader>();
        private ImporterContext VRMInstance;
        private Dictionary<Renderer, Material[]> DefaultMaterials = new Dictionary<Renderer, Material[]>();
        private GameObject CopyVRM;

        //外部Material
        UnityEngine.Object[] AssetsMaterial;
        private Dictionary<string, Material> otherMaterials1 = new Dictionary<string, Material>();
        private Dictionary<string, Material> otherMaterials2 = new Dictionary<string, Material>();
        private Dictionary<string, Material> otherMaterials3 = new Dictionary<string, Material>();
        private RuntimeAnimatorController otherAnimation1;
        private RuntimeAnimatorController otherAnimation2;
        private RuntimeAnimatorController otherAnimation3;
        private List<string> MaterialsName = new List<string>();

        //外部Material連動用キー
        public string VRMMetaKey = "";

        // Unity
        public const int Default = 0;

        // Avatar
        public const int OnlyInThirdPerson = 3;
        public const int LegacyOnlyInFirstPerson = 4;
        public const int OnlyInFirstPerson = 6;
        public const int AlwaysVisible = 10;

        Vector3 defaultPosition;
        bool isGetDefaultPosition;
        private void OnActivate(bool firstActivation, bool addedToHierarchy, bool screenSystemEnabling)
        {
            if (firstActivation || isGetDefaultPosition == false)
            {
                if (VRMInstance != null)
                {
                    defaultPosition = VRMInstance.Root.transform.parent.position;
                    isGetDefaultPosition = true;
                }
            }

            VRMInstance.Root.transform.position = defaultPosition;
            Logger.log?.Debug($"Reset Room Adjust{defaultPosition}");

        }

        /// <summary>
        /// 初期化でシェーダー読み込み
        /// </summary>
        public VMCMaterialChange()
        {
            ShaderLoad();
            AddEvents();
        }

        /// <summary>
        /// Eventsセット
        /// </summary>
        private void AddEvents()
        {
            RemoveEvents();
        }

        /// <summary>
        /// Eventsリムーブ
        /// </summary>
        private void RemoveEvents()
        {
        }

        /// <summary>
        /// AssetBundleからBS_Saderを読み込む
        /// </summary>
        private void ShaderLoad()
        {
            //assetシェーダーを読み込む
            AssetBundle assetBundle = AssetBundle.LoadFromStream(Assembly.GetExecutingAssembly().GetManifestResourceStream("VMCAvatarMaterialChange.bs_shaders"));
            Assets = assetBundle.LoadAllAssets();
            foreach (var asset in Assets)
            {
                if (asset is Shader shader)
                {
                    Shaders[shader.name] = shader;
                }
            }
            //assetBundle.Unload(false);
        }

        /// <summary>
        /// 変更MaterialChangeファイル一覧取得
        /// </summary>
        /// <returns></returns>
        public string[] GetMaterialsName()
        {
            MaterialsName.Clear();
            if (!Directory.Exists($"{System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location) + @"\..\MaterialChange"}"))
                return null;

            string[] names = Directory.GetFiles($"{System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location) + @"\..\MaterialChange"}", "*.mc");
            if (names == null) return null;
            string[] rtnNames = new string[names.Length];
            for (int i = 0 ; i < rtnNames.Length; i++)
            {
                rtnNames[i] = Path.GetFileName(names[i]);
                MaterialsName.Add(names[i]);
           }

            return rtnNames;
        }

        /// <summary>
        /// マテリアルチェンジを行う(.mcファイル読み込み後変更処理実行)
        /// </summary>
        public IEnumerator OtherMaterialStartup(int selectRow,int selectRow2 = 0, int selectRow3 = 0)
        {

            if (selectRow != 0) { 
                yield return OtherLoad(MaterialsName[selectRow - 1], otherMaterials1);
                otherAnimation1 = ReturnAnimatorController;
            }
            else
                otherMaterials1.Clear();

            if (selectRow2 != 0) { 
                yield return OtherLoad(MaterialsName[selectRow2 - 1], otherMaterials2);
                otherAnimation2 = ReturnAnimatorController;
            }
            else
                otherMaterials2.Clear();

            if (selectRow3 != 0) { 
                yield return OtherLoad(MaterialsName[selectRow3 - 1], otherMaterials3);
                otherAnimation3 = ReturnAnimatorController;
            }
            else
                otherMaterials3.Clear();

            SetOtherMaterial(otherMaterials1);
            SetAnimation(otherAnimation1);

            OtherSettingSet(selectRow, selectRow2, selectRow3);
        }

        /// <summary>
        /// パラメータ保存
        /// </summary>
        /// <param name="selectRow"></param>
        /// <param name="selectRow2"></param>
        /// <param name="selectRow3"></param>
        public void OtherSettingSet(int selectRow, int selectRow2 = 0, int selectRow3 = 0)
        {
            //パラメータセット
            if (OtherMaterialChangeSetting.Instance.OtherParameter.List.ContainsKey(VRMMetaKey))
            {
                OtherMaterialChangeSetting.Instance.OtherParameter.List[VRMMetaKey].FileAddress1 = selectRow != 0 ? MaterialsName[selectRow - 1] : "";
                OtherMaterialChangeSetting.Instance.OtherParameter.List[VRMMetaKey].FileAddress2 = selectRow2 != 0 ? MaterialsName[selectRow2 - 1] : "";
                OtherMaterialChangeSetting.Instance.OtherParameter.List[VRMMetaKey].FileAddress3 = selectRow3 != 0 ? MaterialsName[selectRow3 - 1] : "";
            }
            else
            {
                //新規だった場合は追記
                SettingOtherList otherList = new SettingOtherList();
                otherList.Meta = VRMMetaKey;
                otherList.FileAddress1 = selectRow != 0 ? MaterialsName[selectRow - 1] : "";
                otherList.FileAddress2 = selectRow2 != 0 ? MaterialsName[selectRow2 - 1] : "";
                otherList.FileAddress3 = selectRow3 != 0 ? MaterialsName[selectRow3 - 1] : "";
                OtherMaterialChangeSetting.Instance.OtherParameter.List[VRMMetaKey] = otherList;
            }
            //JSON Save
            OtherMaterialChangeSetting.Instance.SaveConfiguration();
        }

        /// <summary>
        /// MaterialChangeする専用ファイル選択
        /// </summary>
        /// <param name="select"></param>
        public void SetOtherMaterialSelecter(int select)
        {
            if (select == 0) { SetOtherMaterial(otherMaterials1); SetAnimation(otherAnimation1); }
            else if (select == 1) { SetOtherMaterial(otherMaterials2); SetAnimation(otherAnimation2); }
            else if (select == 2) { SetOtherMaterial(otherMaterials3); SetAnimation(otherAnimation3); }
        }


        RuntimeAnimatorController ReturnAnimatorController = null;
        /// <summary>
        /// アセットバンドルを読み込んで保持しておく
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="set"></param>
        private IEnumerator OtherLoad(string filename, Dictionary<string, Material> set)
        {
            set.Clear();
            if (filename == "") yield break;
            var asyncLoad = AssetBundle.LoadFromFileAsync(filename);
            yield return asyncLoad;
            AssetBundle assetBundle = asyncLoad.assetBundle;
            var assetLoadRequest = assetBundle.LoadAllAssetsAsync();
            yield return assetLoadRequest;
            AssetsMaterial = assetLoadRequest.allAssets;
            assetBundle.Unload(false);
            ReturnAnimatorController = null;
            foreach (var asset in AssetsMaterial)
            {
                if (asset is Material material)
                {
                    set[material.name] = material;
                }
                else //if (asset is RuntimeAnimatorController Anime)
                {
                    ReturnAnimatorController = (RuntimeAnimatorController)asset;
                    Logger.log?.Debug($"OtherMaterialLoad {ReturnAnimatorController.name}");
                }

            }

        }

        /// <summary>
        /// マテリアルチェンジ実行(.mcファイルパッチ処理)
        /// </summary>
        private bool SetOtherMaterial(Dictionary<string, Material> set)
        {
            // 設定するMaterialがない場合は標準に戻して終わる
            if (set == null && DefaultMaterials == null) return false;
            if (set == null)
            {
                SetDefaultMaterials();
                return true;
            }

            GameObject Avatar = VRMInstance.Root;

            var meta = Avatar.GetComponent<VRM.VRMMeta>();
            VRMMetaKey = $"{meta.Meta.Title}_{meta.Meta.Version}_{meta.Meta.Author}";

            if (Avatar == null) return false;
            foreach (Renderer renderer in Avatar.GetComponentsInChildren<Renderer>(true))
            {
                Material[] newMaterials = new Material[renderer.sharedMaterials.Length];
                for (int index = 0; index < renderer.sharedMaterials.Length; index++)
                {
                    Logger.log.Debug($"SetOtherMaterial MaterialName:{renderer.sharedMaterials[index].name}");
                    if (set.ContainsKey(renderer.sharedMaterials[index].name))
                    {
                        Logger.log.Debug($"SetOtherMaterial SetMaterialStatus Name:{set[renderer.sharedMaterials[index].name].name} Sader:{set[renderer.sharedMaterials[index].name].shader.name}");
                        newMaterials[index] = set[renderer.sharedMaterials[index].name];

                        if (Shaders.ContainsKey(newMaterials[index].shader.name))
                            newMaterials[index].shader = Shaders[newMaterials[index].shader.name];

                        //Beatsaber/MToon来た場合だけ、シェーダー設定行う
                        if (newMaterials[index].shader.name == "BeatSaber/MToon")
                            MToonChangeShader(newMaterials[index]);
                    }
                    else
                    {
                        Logger.log.Debug($"SetOtherMaterial NoAvatarObject Name:{renderer.sharedMaterials[index].name} Shader:{renderer.sharedMaterials[index].shader.name}");
                        newMaterials[index] = renderer.sharedMaterials[index];
                    }
                }
                renderer.sharedMaterials = newMaterials;
            }

            return true;
        }

        /// <summary>
        /// デフォルトのMaterial設定
        /// </summary>
        private void SetDefaultMaterials()
        {
            foreach (Renderer renderer in VRMInstance.Root.GetComponentsInChildren<Renderer>())
            {
                //デフォルトのマテリアルと一度セットする
                renderer.sharedMaterials = DefaultMaterials[renderer];
            }
        }


        /// <summary>
        /// UniVRMでのVRMセットを検知してのMaterial変更
        /// </summary>
        /// <param name="__instance"></param>
        public IEnumerator ChangeMaterial(ImporterContext __instance)
        {
            //VRM変更の場合は保持していたマテリアルを開放
            DefaultMaterials.Clear();
            //VRMを参照で保持
            VRMInstance = __instance;
            foreach (Renderer renderer in VRMInstance.Root.GetComponentsInChildren<Renderer>())
            {
                DefaultMaterials.Add(renderer, renderer.sharedMaterials);
            }

            var meta = VRMInstance.Root.GetComponent<VRM.VRMMeta>();
            VRMMetaKey = $"{meta.Meta.Title}_{meta.Meta.Version}_{meta.Meta.Author}";

            if (PluginConfig.Instance._MaterialChange == MaterialChange.OFF) yield break;

            //自動MaterialChangeONの場合ファイル読み込みを行って設定する
            bool setter = false;
            if (OtherMaterialChangeSetting.Instance.OtherParameter.AutoMaterialChange & VRMMetaKey != "")
            {
                if (OtherMaterialChangeSetting.Instance.OtherParameter.List != null) 
                    if (OtherMaterialChangeSetting.Instance.OtherParameter.List.ContainsKey(VRMMetaKey))
                    {
                        yield return OtherLoad(OtherMaterialChangeSetting.Instance.OtherParameter.List[VRMMetaKey].FileAddress1, otherMaterials1);
                        otherAnimation1 = ReturnAnimatorController;
                        yield return OtherLoad(OtherMaterialChangeSetting.Instance.OtherParameter.List[VRMMetaKey].FileAddress2, otherMaterials2);
                        otherAnimation2 = ReturnAnimatorController;
                        yield return OtherLoad(OtherMaterialChangeSetting.Instance.OtherParameter.List[VRMMetaKey].FileAddress3, otherMaterials3);
                        otherAnimation3 = ReturnAnimatorController;
                        if (otherMaterials1.Count != 0)
                        { 
                            SetOtherMaterial(otherMaterials1);
                            SetAnimation(otherAnimation1);
                            setter = true;
                        }
                    }
            }

            //設定していない場合はBloom対応Mtoonを設定する
            if (!setter)
            {
                //MToon→Bloom対応MToon
                //instaceからマテリアルを取得して変更する
                foreach (Renderer renderer in VRMInstance.Root.GetComponentsInChildren<Renderer>())
                {
                    MaterialsSearch(renderer);
                }
            }


        }

        /// <summary>
        /// リロード時の再度Material変更(VRM/MToon→Beatsaber/MToon処理)
        /// </summary>
        public void ChangeMaterial()
        {
            Logger.log.Debug($"ChangeMaterial[NoChangeVRM] {VRMInstance}");
            if (VRMInstance == null) return;

            //instaceからマテリアルを取得して変更する
            foreach (Renderer renderer in VRMInstance.Root.GetComponentsInChildren<Renderer>())
            {
                //デフォルトのマテリアルと一度セットする
                renderer.sharedMaterials = DefaultMaterials[renderer];

                if (PluginConfig.Instance._MaterialChange == MaterialChange.ON)
                {
                    MaterialsSearch(renderer);
                }
            }
        }


        /// <summary>
        /// Rendererのマテリアルのコピーを取って、ビートセイバー用シェーダーに置き換えたマテリアルを作成して反映する
        /// </summary>
        /// <param name="mates"></param>
        private void MaterialsSearch(Renderer renderer)
        {
            try
            {
                Material[] newMaterials = new Material[renderer.sharedMaterials.Length];
                for (int index = 0; index < DefaultMaterials[renderer].Length; index++)
                {
                    Material newMaterial = new Material(DefaultMaterials[renderer][index]);
                    Logger.log.Debug($"Old {newMaterial.name} {newMaterial.shader.name}");
                    if (newMaterial.shader.name == "VRM/MToon")
                    {
                        MToonChangeShader(newMaterial);
                    }
                    else if (Shaders.ContainsKey(newMaterial.shader.name))
                    {//変換対応シェーダーがある場合はそちらに変更する
                        StandardChangeShader(newMaterial);
                    }
                    Logger.log.Debug($"Changed {newMaterial.name} {newMaterial.shader.name}");

                    newMaterials[index] = newMaterial;
                }
                renderer.sharedMaterials = newMaterials;

            }
            catch (Exception e)
            {
                Logger.log.Debug($"{e.Message}");
            }


        }

        /// <summary>
        /// Material直取得した時用
        /// </summary>
        /// <param name="material"></param>
        public void UniVRM_AddMaterial(Material material)
        {
            MToonChangeShader(material);
        }


        /// <summary>
        /// マテリアルのシェーダーをBeatSaber/Unlit Glowに置き換える
        /// </summary>
        /// <param name="originMat"></param>
        private void MToonChangeShader(Material originMat)
        {
            //Materialを一時保存しておく
            Material met = new Material(originMat);
            //Logger.log.Debug($"{originMat.GetFloat("_BlendMode") } renderQueue:{originMat.renderQueue}");


            originMat.shader = Shaders["BeatSaber/MToon"];

            //シェーダー置き換えるとrenderQueueが2000になるので、元のやつをセットする
            originMat.renderQueue = met.renderQueue;

            Logger.log.Debug($"{originMat.GetFloat("_BlendMode") }  renderQueue:{originMat.renderQueue} ChangedRenderQueue:{originMat.renderQueue}");

            //影色強制白の場合は影色を白に変更する
            if (PluginConfig.Instance._ShadeColor == ShadeColor.White)
                    originMat.SetColor("_ShadeColor", Color.white);

            //保存しておいたマテリアルを破棄する
            Material.Destroy(met);
        }

        /// <summary>
        /// マテリアルのシェーダーをBeatSaber用にしたオリジナルシェーダーに置き換える
        /// </summary>
        /// <param name="originMat"></param>
        private void StandardChangeShader(Material originMat)
        {
            //Materialを一時保存しておく
            Material met = new Material(originMat);

            //シェーダー変更
            originMat.shader = Shaders[originMat.shader.name];

            //シェーダー置き換えるとデフォルトに戻るので、元のやつをセットする
            originMat.renderQueue = met.renderQueue;
            //保存しておいたマテリアルを破棄する
            Material.Destroy(met);

        }


        #region Animator設定
        Animator VRMAnimator;
        Int32 LayerNo;
        private void SetAnimation(RuntimeAnimatorController animation)
        {
            Logger.log?.Debug($"SetAnimation Start");
            if (animation == null) return;

            //Animatorがなければ作成
            Logger.log?.Debug($"SetAnimation Get");
            var animator = VRMInstance.Root.GetComponent<Animator>();
            if (animator == null)
                VRMInstance.Root.AddComponent<Animator>();

            VRMAnimator = animator;

            //Animationが登録済みの場合でレイヤーMaterialChangeがある場合は削除する
            Logger.log?.Debug($"SetAnimation Set");
            VRMAnimator.runtimeAnimatorController = animation;
            LayerNo = VRMAnimator.GetLayerIndex("MaterialChange");
            Logger.log ?.Debug ($"SetAnimation End");
        }

        /// <summary>
        /// 次のアニメーションへ遷移
        /// </summary>
        public void ToggleAnimation()
        {
            //アニメーターがなかったり、遷移中は実行しない
            if (VRMAnimator == null) return;
            if (VRMAnimator.IsInTransition(LayerNo)) return;

            var max = VRMAnimator.GetInteger("MaxCount");
            var now = VRMAnimator.GetInteger("SetPoint");
            var set = (int)((now + 1) % (max + 1));
            set = set == 0 ? 1 : set;
            VRMAnimator.SetInteger("SetPoint", set);
            Logger.log?.Debug($"ToggleAnimation SetPoint:{set}");
        }

        #endregion

        /// <summary>
        /// VRMゲームオブジェクトを探してコピーを作って、ワールド原点にセットする
        /// </summary>
        public void VRMCopy(bool WPosSet)
        {
            if (VRMInstance == null) return;
            GameObject Avatar = VRMInstance.Root;
            if (Avatar == null) return;
            VRMCopyDestroy();


            //SpringBoneを一旦OFF
            GameObject secondary = Avatar.transform.Find("secondary").gameObject;
            secondary.SetActive(false);

            GameObject setAvataraObj = GameObject.Find("VMCAvatarMaterialChange");
            //GameObject activeFalse1 = GameObject.Find("VMCAvatar/RoomAdjust");

            if (WPosSet)
                CopyVRM = GameObject.Instantiate(Avatar, new Vector3(0f, 0f, 0f), Quaternion.identity, setAvataraObj.GetComponent<Transform>()) as GameObject;
            else
                CopyVRM = GameObject.Instantiate(Avatar, setAvataraObj.GetComponent<Transform>()) as GameObject;


            foreach (var skinnedMeshRenderer in CopyVRM.GetComponentsInChildren<Renderer>(true))
            {
                if (skinnedMeshRenderer.gameObject.layer != AlwaysVisible)
                {
                    skinnedMeshRenderer.gameObject.layer = AlwaysVisible;
                }
            }

            SpringBoneCopy(Avatar, CopyVRM);

            GameObject copyAvatarsecondary = CopyVRM.transform.Find("secondary").gameObject;
            copyAvatarsecondary.SetActive(true);

            //OnAvatarDance();

            secondary.SetActive(true);


        }

        Transform[] transformList;

        void SpringBoneCopy(GameObject owner ,GameObject to)
        {
            transformList = to.GetComponentsInChildren<Transform>();

            var colliders = owner.GetComponentsInChildren<VRMSpringBoneColliderGroup>();
            foreach (var c in colliders)
            {
                var targetTransform = transformList.FirstOrDefault(x => x.name == c.transform.name);
                if (targetTransform != null)
                {
                    var col = targetTransform.GetComponentsInChildren<VRMSpringBoneColliderGroup>();
                    copyField(c, col, "m_gizmoColor");
                    for (int i = 0; i < col[0].Colliders.Length; i++)
                    {
                        col[0].Colliders[i] = new VRMSpringBoneColliderGroup.SphereCollider();
                        col[0].Colliders[i].Offset = c.Colliders[i].Offset;
                        col[0].Colliders[i].Radius = (float)(c.Colliders[i].Radius * 1);
                    }
                }
                else
                {
                    Debug.LogWarning("Not found VRMSpringBoneColliderGroup bone->" + c.gameObject.name);
                }
            }

        }

        // private変数のコピー
        void copyField(object src, object dst, string fieldName)
        {
            var srcField = src.GetType().GetField(fieldName, BindingFlags.Public | BindingFlags.NonPublic |
                                    BindingFlags.Instance | BindingFlags.Static |
                                    BindingFlags.DeclaredOnly);

            if (srcField == null)
            {
                Debug.LogWarning("srcField is null");
                return;
            }

            var dstField = dst.GetType().GetField(fieldName, BindingFlags.Public | BindingFlags.NonPublic |
                                    BindingFlags.Instance | BindingFlags.Static |
                                    BindingFlags.DeclaredOnly);

            if (dstField == null)
            {
                Debug.LogWarning("dstField is null");
                return;
            }

            dstField.SetValue(dst, srcField.GetValue(src));
        }


        /// <summary>
        /// コピーしたVRMをデストロイする
        /// </summary>
        public void VRMCopyDestroy()
        {
            if (CopyVRM != null) GameObject.Destroy(CopyVRM);
        }
    }


}
