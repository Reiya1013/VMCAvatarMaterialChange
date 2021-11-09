using System;
using BeatSaberMarkupLanguage;
using BeatSaberMarkupLanguage.MenuButtons;
using UnityEngine;
using VMCAvatarMaterialChange.Views.AvatarCopy;
using VMCAvatarMaterialChange.Views.MaterialChange;
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
        private ModMainFlowCoordinator mainFlowCoordinator;
        private ModMainFlowCoordinator2 mainFlowCoordinator2;
        internal static string Name => "VMCAvatarMaterialChange";
        internal static bool CopyStart = false;
        internal static bool CopyMode = false;
        internal static bool AutoDestroy = true;

        HarmonyPatches.Patcher patcher;

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

            //Harmony
            Logger.log?.Debug($"{name}: Harmony()");
            patcher = new HarmonyPatches.Patcher("VMCAvatarMaterialChange");
            patcher.Enable();

            //AvatarCopyMenu
            MenuButton menuButton = new MenuButton("Avatar Copy", "Avatar Copy", ShowModFlowCoordinator, true);
            MenuButtons.instance.RegisterButton(menuButton);

            //MaterialChangeMenu
            MenuButton menuButton2 = new MenuButton("MaterialChange", "Material Change", ShowModFlowCoordinator2, true);
            MenuButtons.instance.RegisterButton(menuButton2);

            //コントローラーフック
            //InputManager.instance.BeginPolling();
        }

        /// <summary>
        /// アバターコピーメニューコントローラー
        /// </summary>
        public void ShowModFlowCoordinator()
        {
            if (this.mainFlowCoordinator == null)
                this.mainFlowCoordinator = BeatSaberUI.CreateFlowCoordinator<ModMainFlowCoordinator>();
            if (mainFlowCoordinator.IsBusy) return;

            BeatSaberUI.MainFlowCoordinator.PresentFlowCoordinator(mainFlowCoordinator);
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
        /// Called when the script is being destroyed.
        /// </summary>
        private void OnDestroy()
        {
            patcher.Disable();

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

            //if (_vrPointer == null)
            //{
            //    _vrPointer = GetComponent<VRPointer>();
            //    //デストロイされないようにする
            //    DontDestroyOnLoad(_vrPointer);
            //}

            //if (_vrPointer.vrController != null)
            //{
            //    if (_vrPointer.vrController.node == UnityEngine.XR.XRNode.LeftHand)
            //    {
            //        if (_vrPointer.vrController.triggerValue < 0.9f)
            //        {
            //            RightTriggerDownCount = 0;
            //            RightTriggerDownTime = 0;
            //        }
            //    }

            //    if (_vrPointer.vrController.node == UnityEngine.XR.XRNode.RightHand)
            //    {
            //        if (_vrPointer.vrController.triggerValue >0.9f)
            //        {
            //            RightTriggerDownCount += 1;
            //            RightTriggerDownTime = 0;   //最後に入力があってから１秒経過しても３回目入力しなかった場合のみクリアするようにする
            //            Logger.log?.Debug($"{name}: ControllerInput() VRController RightTrigerCnt:{RightTriggerDownCount}");

            //            if (RightTriggerDownCount >= 3)
            //            {
            //                RightTriggerDownCount = 0;
            //                Logger.log?.Debug($"{name}: ToggleAnimation()");

            //                Plugin.VMCMC.ToggleAnimation();
            //            }
            //        }
            //    }

            //}


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

                    Plugin.VMCMC.ToggleAnimation();
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
                Plugin.VMCMC.ToggleAnimation();
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
                if (Input.GetKey(KeyCode.Alpha1)) Plugin.VMCMC.SetOtherMaterialSelecter(0);
                else if (Input.GetKey(KeyCode.Alpha2)) Plugin.VMCMC.SetOtherMaterialSelecter(1);
                else if (Input.GetKey(KeyCode.Alpha3)) Plugin.VMCMC.SetOtherMaterialSelecter(2);
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
                Plugin.VMCMC.VRMCopy(CopyMode);
                StartTime = DateTime.MinValue;
                CopyStart = false;
            }
        }


        #endregion
    }
}
