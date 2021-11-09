using BeatSaberMarkupLanguage;
using HMUI;

namespace VMCAvatarMaterialChange.Views.AvatarCopy
{
    class ModMainFlowCoordinator : FlowCoordinator
    {
        private const string titleString = "AvatarCopy";
        private AvatarCopyUI avatarCopyUI;
        
        public bool IsBusy { get; set; }

        public void ShowUI()
        {
            this.IsBusy = true;
            this.SetLeftScreenViewController(this.avatarCopyUI, ViewController.AnimationType.In);
            this.IsBusy = false;
        }

        private void Awake()
        {
            this.avatarCopyUI = BeatSaberUI.CreateViewController<AvatarCopyUI>();
            this.avatarCopyUI.mainFlowCoordinator = this;
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

            viewToDisplay = this.avatarCopyUI;

            return viewToDisplay;
        }

        protected override void BackButtonWasPressed(ViewController topViewController)
        {
            if (this.IsBusy) return;
            if (VMCAvatarMaterialChangeController.AutoDestroy)
                Plugin.VMCMC.VRMCopyDestroy();

            BeatSaberUI.MainFlowCoordinator.DismissFlowCoordinator(this);
        }
    }
}
