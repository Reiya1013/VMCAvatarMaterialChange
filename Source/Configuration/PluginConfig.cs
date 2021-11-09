using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using IPA.Config.Stores;
using IPA.Config.Stores.Attributes;

[assembly: InternalsVisibleTo(GeneratedStore.AssemblyVisibilityTarget)]

namespace VMCAvatarMaterialChange
{
    class PluginConfig
    {
        public static PluginConfig Instance { get; set; }

        public int materialChange { get; set; } = (int)MaterialChange.ON;
        [Ignore]
        public MaterialChange _MaterialChange
        {
            get => (MaterialChange)materialChange;
            set => materialChange = (int)value;
        }

        public int shadeColor { get; set; } = (int)ShadeColor.Default;
        [Ignore]
        public ShadeColor _ShadeColor
        {
            get => (ShadeColor)shadeColor;
            set => shadeColor = (int)value;
        }
        public int graphicMode { get; set; } = (int)GraphicMode.Default;
        [Ignore]
        public GraphicMode _GraphicMode
        {
            get => (GraphicMode)graphicMode;
            set => graphicMode = (int)value;
        }
        public float cutoff { get; set; } = (float)0.5;
        [Ignore]
        public float _Cutoff
        {
            get => cutoff;
            set => cutoff = (float)value;
        }

        public event Action<PluginConfig> OnChangedEvent;
        /// <summary>
        /// This is called whenever BSIPA reads the config from disk (including when file changes are detected).
        /// </summary>
        public virtual void OnReload()
        {
            // Do stuff after config is read from disk.
            this.OnChangedEvent?.Invoke(this);
        }

        /// <summary>
        /// Call this to force BSIPA to update the config file. This is also called by BSIPA if it detects the file was modified.
        /// </summary>
        public virtual void Changed()
        {
            // Do stuff when the config is changed.
            this.OnChangedEvent?.Invoke(this);
        }

        /// <summary>
        /// Call this to have BSIPA copy the values from <paramref name="other"/> into this config.
        /// </summary>
        public virtual void CopyFrom(PluginConfig other)
        {
            // This instance's members populated from other
            this._MaterialChange = other._MaterialChange;
            this._ShadeColor = other._ShadeColor;
            this._GraphicMode = other._GraphicMode;
            this._Cutoff = other._Cutoff;
        }

    }

}
