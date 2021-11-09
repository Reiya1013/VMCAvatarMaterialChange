using BeatSaberMarkupLanguage;
using HMUI;

namespace VMCAvatarMaterialChange.Views.MaterialChange
{
    class ModMainFlowCoordinator2 : FlowCoordinator
    {
        private const string titleString = "MaterialChange";
        private MaterialChangeUI materialChangeUI;
        
        public bool IsBusy { get; set; }

        public void ShowUI()
        {
            this.IsBusy = true;
            this.SetLeftScreenViewController(this.materialChangeUI, ViewController.AnimationType.In);
            this.IsBusy = false;
        }

        private void Awake()
        {
            this.materialChangeUI = BeatSaberUI.CreateViewController<MaterialChangeUI>();
            this.materialChangeUI.mainFlowCoordinator = this;
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

            viewToDisplay = this.materialChangeUI;

            return viewToDisplay;
        }

        protected override void BackButtonWasPressed(ViewController topViewController)
        {
            if (this.IsBusy) return;

            BeatSaberUI.MainFlowCoordinator.DismissFlowCoordinator(this);
        }
    }
}
