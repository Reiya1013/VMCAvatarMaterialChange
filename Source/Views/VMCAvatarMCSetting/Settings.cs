using BeatSaberMarkupLanguage.Attributes;
using System.Collections.Generic;
using System.Linq;

namespace VMCAvatarMaterialChange
{
    [HotReload]
    class Settings : PersistentSingleton<Settings>
    {
        [UIValue("options1")]
        private List<object> options_change_mode = (new object[] { MaterialChange.OFF, MaterialChange.ON }).ToList();
        [UIValue("options2")]
        private List<object> options_color_mode = (new object[] { ShadeColor.Default, ShadeColor.White }).ToList();
        [UIValue("options3")]
        private List<object> graphic_mode_value = (new object[] { GraphicMode.Default, GraphicMode.Lite }).ToList();

        private MaterialChange _materialChange;
        [UIValue("MaterialChange_value")]
        public MaterialChange MaterialChange_value
        {
            get => _materialChange;
            set => _materialChange = value;
        }

        private ShadeColor _shadeColor;
        [UIValue("ShadeColor_value")]
        public ShadeColor ShadeColor_value
        {
            get => _shadeColor;
            set => _shadeColor = value;
        }

        private GraphicMode _graphicMode;
        [UIValue("GraphicMode_value")]
        public GraphicMode GraphicMode_value
        {
            get => _graphicMode;
            set => _graphicMode = value;
        }

        private float _cutout;
        [UIValue("Cutout_value")]
        public float Cutout_value
        {
            get => _cutout;
            set => _cutout = value;
        }



        [UIAction("#apply")]
        public void OnApply()
        {
            PluginConfig.Instance._MaterialChange = _materialChange;
            PluginConfig.Instance._ShadeColor = _shadeColor;
            PluginConfig.Instance._GraphicMode = _graphicMode;
            PluginConfig.Instance._Cutoff = _cutout;

            VMCMaterialChange.instance.ChangeMaterial();
        }

        public void Awake()
        {
            _materialChange = PluginConfig.Instance._MaterialChange ;
            _shadeColor = PluginConfig.Instance._ShadeColor ;
            _graphicMode = PluginConfig.Instance._GraphicMode;
            _cutout = PluginConfig.Instance._Cutoff;
        }

    }
}
