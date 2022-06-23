using System;
using BeatSaberMarkupLanguage;
using BeatSaberMarkupLanguage.MenuButtons;
using UnityEngine;
using UnityEngine.SceneManagement;
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
        internal static string Name => "VMCAvatarMaterialChange";
        internal static bool CopyStart = false;
        internal static bool CopyMode = false;
        internal static bool AutoDestroy = true;

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

            //MaterialChangeMenu
            MenuButton menuButton2 = new MenuButton("Material Change", "Material Change", ShowModFlowCoordinator, true);
            MenuButtons.instance.RegisterButton(menuButton2);

            //シーンチェンジイベントセット
            SceneManager.activeSceneChanged += OnActiveSceneChanged;
        }

        /// <summary>
        /// MaterialChangeメニューコントローラー
        /// </summary>
        public void ShowModFlowCoordinator()
        {
            if (this.mainFlowCoordinator == null)
                this.mainFlowCoordinator = BeatSaberUI.CreateFlowCoordinator<ModMainFlowCoordinator>();
            if (mainFlowCoordinator.IsBusy) return;

            BeatSaberUI.MainFlowCoordinator.PresentFlowCoordinator(mainFlowCoordinator);
        }

        /// <summary>
        /// シーンチェンジでGameSceneフラグを切り替える
        /// </summary>
        /// <param name="prevScene"></param>
        /// <param name="nextScene"></param>
        public void OnActiveSceneChanged(Scene prevScene, Scene nextScene)
        {
            if (nextScene.name == "MainMenu")
            {
                VMCMaterialChange.instance.GameSceneAnimation(false);
            }
            if (nextScene.name == "GameCore")
            {
                VMCMaterialChange.instance.GameSceneAnimation(true);
            }
        }


        /// <summary>
        /// Called when the script is being destroyed.
        /// </summary>
        private void OnDestroy()
        {
            //シーンチェンジイベントセット
            SceneManager.activeSceneChanged -= OnActiveSceneChanged;

            Logger.log?.Debug($"{name}: OnDestroy()");
            instance = null; // This MonoBehaviour is being destroyed, so set the static instance property to null.
        }

        private void Update()
        {
            //MaterialChangeKeyDown();
            AvatarCopy();
            ControllerInput();
        }


        Int32 RightTriggerDownCount;
        float RightTriggerDownTime;
        Int32 LeftTriggerDownCount;
        float LeftTriggerDownTime;

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
            { 
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
            }




            //→手トリガー握りっぱなしで左トリガー3連続で入力されたらアバターチェンジ
            {
                if (!(bool)(inputManager.GetRightTriggerDown()))
                {
                    LeftTriggerDownCount = 0;
                    LeftTriggerDownTime = 0;
                }

                if ((bool)(inputManager.GetLeftTriggerClicked()))
                {
                    LeftTriggerDownCount += 1;
                    LeftTriggerDownTime = 0;   //最後に入力があってから１秒経過しても３回目入力しなかった場合のみクリアするようにする
                    Logger.log?.Debug($"{name}: ControllerInput() LeftTrigerCnt:{LeftTriggerDownCount}");

                    if (LeftTriggerDownCount >= 3)
                    {
                        LeftTriggerDownCount = 0;
                        Logger.log?.Debug($"{name}: ChangeActiveAvatar()");

                        Plugin.instance.ChangeAvatas.ChangeActiveAvatar();
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
            }





            if (Input.GetKeyDown(KeyCode.T))
            {
                VMCMaterialChange.instance.ToggleAnimation();
            }
            //if (Input.GetKeyDown(KeyCode.Alpha1))
            //{
            //    Plugin.instance.DisposeVRMOff = true;
            //    Plugin.instance.ChangeAvatas.SetAvatar(VMCMaterialChange.instance.VRMInstance);
            //}
            //if (Input.GetKeyDown(KeyCode.Alpha2))
            //{
            //    Plugin.instance.DisposeVRMOff = true;
            //    Plugin.instance.ChangeAvatas.Setup(VMCMaterialChange.instance.VRMInstance);
            //}
            //if (Input.GetKeyDown(KeyCode.Alpha3))
            //{
            //    Plugin.instance.ChangeAvatas.ChangeActiveAvatar();
            //}
            //if (Input.GetKeyDown(KeyCode.Alpha4))
            //{
            //    Plugin.instance.ChangeAvatas.Reset();
            //}
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
