using System;
using BeatSaberMarkupLanguage;
using BeatSaberMarkupLanguage.MenuButtons;
using UnityEngine;
using VMCAvatarMaterialChange.Views.AvatarCopy;
using VMCAvatarMaterialChange.Views.MaterialChange;
using VMCAvatarMaterialChange.Views.AvatarLight;
using IPALogger = IPA.Logging.Logger;
using VRUIControls;

namespace VMCAvatarMaterialChange
{
    /// <summary>
    /// Monobehaviours (scripts) are added to GameObjects.
    /// For a full list of Messages a Monobehaviour can receive from the game, see https://docs.unity3d.com/ScriptReference/MonoBehaviour.html.
    /// </summary>
    public class VMCAvatarMaterialChangeController : MonoBehaviour
    {
        public static VMCAvatarMaterialChangeController instance { get; private set; }
        private ModMainFlowCoordinator_AvatarCopy mainFlowCoordinator_AvatarCopy;
        private ModMainFlowCoordinator2 mainFlowCoordinator2;
        private ModMainFlowCoordinator_AvatarLight mainFlowCoordinator_AvatarLight;
        internal static string Name => "VMCAvatarMaterialChange";
        internal static bool CopyStart = false;
        internal static bool CopyMode = false;
        internal static bool AutoDestroy = true;

        //マテリアルチェンジクラス
        //internal static VMCMaterialChange VMCMC = new VMCMaterialChange();


        private InputManager inputManager;

        #region Monobehaviour Messages

        /// <summary>
        /// Only ever called once, mainly used to initialize variables.
        /// </summary>
        private void Awake()
        {
            // For this particular MonoBehaviour, we only want one instance to exist at any time, so store a reference to it in a static property
            //   and destroy any that are created while one already exists.
            if (instance != null)
            {
                Logger.log?.Warn($"Instance of {this.GetType().Name} already exists, destroying.");
                GameObject.DestroyImmediate(this);
                return;
            }
            GameObject.DontDestroyOnLoad(this); // Don't destroy this object on scene changes
            instance = this;
            instance.name = Name;
            Logger.log?.Debug($"{name}: Awake()");

            //AvatarCopyMenu
            MenuButton menuButton = new MenuButton("Avatar Copy", "Avatar Copy", ShowModMainFlowCoordinator_AvatarCopy, true);
            MenuButtons.instance.RegisterButton(menuButton);

            //MaterialChangeMenu
            MenuButton menuButton2 = new MenuButton("MaterialChange", "Material Change", ShowModFlowCoordinator2, true);
            MenuButtons.instance.RegisterButton(menuButton2);

            //AvatarLightMenu
            MenuButton menuButton3 = new MenuButton("Avata Light", "Set whether it is affected by ambient light", ShowModMainFlowCoordinator_AvatarLight, true);
            MenuButtons.instance.RegisterButton(menuButton3);


            //コントローラーフック
            //InputManager.instance.BeginPolling();
        }

        /// <summary>
        /// アバターコピーメニューコントローラー
        /// </summary>
        public void ShowModMainFlowCoordinator_AvatarCopy()
        {
            if (this.mainFlowCoordinator_AvatarCopy == null)
                this.mainFlowCoordinator_AvatarCopy = BeatSaberUI.CreateFlowCoordinator<ModMainFlowCoordinator_AvatarCopy>();
            if (mainFlowCoordinator_AvatarCopy.IsBusy) return;

            BeatSaberUI.MainFlowCoordinator.PresentFlowCoordinator(mainFlowCoordinator_AvatarCopy);
        }

        /// <summary>
        /// MaterialChangeメニューコントローラー
        /// </summary>
        public void ShowModFlowCoordinator2()
        {
            if (this.mainFlowCoordinator2 == null)
                this.mainFlowCoordinator2 = BeatSaberUI.CreateFlowCoordinator<ModMainFlowCoordinator2>();
            if (mainFlowCoordinator2.IsBusy) return;

            BeatSaberUI.MainFlowCoordinator.PresentFlowCoordinator(mainFlowCoordinator2);
        }

        /// <summary>
        /// MaterialChangeメニューコントローラー
        /// </summary>
        public void ShowModMainFlowCoordinator_AvatarLight()
        {
            if (this.mainFlowCoordinator_AvatarLight == null)
                this.mainFlowCoordinator_AvatarLight = BeatSaberUI.CreateFlowCoordinator<ModMainFlowCoordinator_AvatarLight>();
            if (mainFlowCoordinator_AvatarLight.IsBusy) return;

            BeatSaberUI.MainFlowCoordinator.PresentFlowCoordinator(mainFlowCoordinator_AvatarLight);
        }

        /// <summary>
        /// Called when the script is being destroyed.
        /// </summary>
        private void OnDestroy()
        {

            Logger.log?.Debug($"{name}: OnDestroy()");
            instance = null; // This MonoBehaviour is being destroyed, so set the static instance property to null.

        }

        private void Update()
        {
            MaterialChangeKeyDown();
            AvatarCopy();
            ControllerInput();
        }


        Int32 RightTriggerDownCount;
        float RightTriggerDownTime;
        protected VRPointer _vrPointer;


        /// <summary>
        /// 1秒以内に3回右トリガーされたら、次のアニメーションへ遷移
        /// </summary>
        private void ControllerInput()
        {
            if (inputManager == null)
            {
                inputManager = new GameObject(nameof(InputManager)).AddComponent<InputManager>();
                inputManager.BeginGameCoreScene();
            }

            if (inputManager.GetLeftGripClicked())
                Logger.log?.Debug($"GetLeftGripClicked True");

            if (inputManager.GetRightGripClicked())
                Logger.log?.Debug($"GetRightGripClicked True");


            //左手トリガー握りっぱなしで右トリガー3連続で入力されたらチェンジアニメーション
            if (!(bool)(inputManager.GetLeftTriggerDown()))
            {
                RightTriggerDownCount = 0;
                RightTriggerDownTime = 0;
            }


            if ((bool)(inputManager.GetRightTriggerClicked()))
            {
                RightTriggerDownCount += 1;
                RightTriggerDownTime = 0;   //最後に入力があってから１秒経過しても３回目入力しなかった場合のみクリアするようにする
                Logger.log?.Debug($"{name}: ControllerInput() RightTrigerCnt:{RightTriggerDownCount}");

                if (RightTriggerDownCount >= 3)
                {
                    RightTriggerDownCount = 0;
                    Logger.log?.Debug($"{name}: ToggleAnimation()");

                    VMCMaterialChange.instance.ToggleAnimation();
                }

            }


            if (RightTriggerDownCount != 0)
                RightTriggerDownTime += Time.deltaTime;

            if (RightTriggerDownTime > 0.5f)
            {
                Logger.log?.Debug($"{name}: ControllerInput() ResetDeltaTime:{RightTriggerDownTime}");
                RightTriggerDownCount = 0;
                RightTriggerDownTime = 0;
            }


            if (Input.GetKeyDown(KeyCode.T))
            {
                VMCMaterialChange.instance.ToggleAnimation();
            }

        }


        bool OldInput = false;
        private void MaterialChangeKeyDown()
        {

            bool isShift = Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift);
            bool isKey = Input.GetKey(KeyCode.Alpha1) || Input.GetKey(KeyCode.Alpha2) || Input.GetKey(KeyCode.Alpha3);

            if (isShift && isKey && !OldInput)
            {
                OldInput = true;
                if (Input.GetKey(KeyCode.Alpha1)) VMCMaterialChange.instance.SetOtherMaterialSelecter(0);
                else if (Input.GetKey(KeyCode.Alpha2)) VMCMaterialChange.instance.SetOtherMaterialSelecter(1);
                else if (Input.GetKey(KeyCode.Alpha3)) VMCMaterialChange.instance.SetOtherMaterialSelecter(2);
            }
            else
                OldInput = false;

        }

        private DateTime StartTime;
        private void AvatarCopy()
        {
            if (!CopyStart) return;
            if (StartTime == DateTime.MinValue) StartTime = DateTime.Now;
            if ((DateTime.Now - StartTime).TotalMilliseconds >= 5000)
            {
                Logger.log?.Debug($"{name}: OnDestroy()");
                VMCMaterialChange.instance.VRMCopy(CopyMode);
                StartTime = DateTime.MinValue;
                CopyStart = false;
            }
        }


        #endregion
    }
}
