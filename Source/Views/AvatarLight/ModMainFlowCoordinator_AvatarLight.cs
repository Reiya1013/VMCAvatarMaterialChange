using BeatSaberMarkupLanguage;
using HMUI;

namespace VMCAvatarMaterialChange.Views.AvatarLight
{
    class ModMainFlowCoordinator_AvatarLight : FlowCoordinator
    {
        private const string titleString = "AvatarLight";
        private AvatarLightUI avatarLightUI;
        
        public bool IsBusy { get; set; }

        public void ShowUI()
        {
            this.IsBusy = true;
            this.SetLeftScreenViewController(this.avatarLightUI, ViewController.AnimationType.In);
            this.IsBusy = false;
        }

        private void Awake()
        {
            this.avatarLightUI = BeatSaberUI.CreateViewController<AvatarLightUI>();
            this.avatarLightUI.mainFlowCoordinator = this;
        }

        protected override void DidActivate(bool firstActivation, bool addedToHierarchy, bool screenSystemEnabling)
        {
            SetTitle(titleString);
            this.showBackButton = true;

            var viewToDisplay = DecideMainView();

            this.IsBusy = true;
            ProvideInitialViewControllers(viewToDisplay);
            this.IsBusy = false;
        }

        private ViewController DecideMainView()
        {
            ViewController viewToDisplay;

            viewToDisplay = this.avatarLightUI;

            return viewToDisplay;
        }

        protected override void BackButtonWasPressed(ViewController topViewController)
        {
            if (this.IsBusy) return;
            if (VMCAvatarMaterialChangeController.AutoDestroy)
                VMCMaterialChange.instance.VRMCopyDestroy();

            BeatSaberUI.MainFlowCoordinator.DismissFlowCoordinator(this);
        }
    }
}
