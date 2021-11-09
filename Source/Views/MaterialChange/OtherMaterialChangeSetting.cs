using System.IO;
using UnityEngine;
using Newtonsoft.Json;
using System.Collections.Generic;

namespace VMCAvatarMaterialChange
{
    public class OtherMaterialChangeSetting
    {
        public static OtherMaterialChangeSetting Instance { get; set; } = new OtherMaterialChangeSetting();

        public static readonly string configurationFile = Path.Combine(Application.dataPath, @"..\UserData\VMCAvatarMaterialChange_Other.json");

        public SettingOther OtherParameter { get; set; }


        /// <summary>
        /// Loads the existing configuration or creates a new one
        /// </summary>
        public void LoadConfiguration()
        {
            if (!File.Exists(configurationFile))
            {
                // Create a new empty configuration if it doesn't exist
                var newConfiguration = new SettingOther();
                string json = JsonConvert.SerializeObject(newConfiguration, Formatting.Indented);
                File.WriteAllText(configurationFile, json);

                OtherParameter = newConfiguration;
                return;
            }

            Logger.log.Debug($"Other Json Load Start2 {File.Exists(configurationFile)}");
            string configuration = File.ReadAllText(configurationFile);
            OtherParameter = JsonConvert.DeserializeObject<SettingOther>(configuration);
        }

        /// <summary>
        /// Writes the current <see cref="ConfigurationData"/> to disk
        /// </summary>
        public void SaveConfiguration()
        {
            string json = JsonConvert.SerializeObject(OtherParameter, Formatting.Indented);
            File.WriteAllText(configurationFile, json);
        }
    }

    public class SettingOther
    {
        public  bool AutoMaterialChange { get; set; } = true;
        public Dictionary<string, SettingOtherList> List { get; set; } = new Dictionary<string, SettingOtherList>();
    }

    public class SettingOtherList
    {
        public string Meta { get; set; }
        public string FileAddress1 { get; set; }
        public string FileAddress2 { get; set; }
        public string FileAddress3 { get; set; }

    }
}
