using System;
using System.Collections.Generic;
using BeatSaberMarkupLanguage;
using UnityEngine;
using UnityEngine.SceneManagement;
using IPALogger = IPA.Logging.Logger;
using IPA.Utilities;

namespace VMCAvatarMaterialChange
{
    class VRMOptionLight:MonoBehaviour
    {
		public Dictionary<int, Light> Lights = new Dictionary<int, Light>();

		public Light VMCLight;

		public Dictionary<SaberType, Light> SaberLights = new Dictionary<SaberType, Light>();
		public Dictionary<SaberType, GameObject> SaberLightsGameObject = new Dictionary<SaberType, GameObject>();


		private void Awake()
        {
			//シーンチェンジイベントセット
			SceneManager.activeSceneChanged += OnActiveSceneChanged;
		}

		private void OnDisable()
        {
			//シーンチェンジイベントセット
			SceneManager.activeSceneChanged -= OnActiveSceneChanged;
		}

		/// <summary>
		/// シーンチェンジで表示を切り替える
		/// </summary>
		/// <param name="prevScene"></param>
		/// <param name="nextScene"></param>
		public void OnActiveSceneChanged(Scene prevScene, Scene nextScene)
		{
			if (VMCLight is null)
            {
				var vrcLight = GameObject.Find("VMCAvatar/VMCLight");
				if (vrcLight != null)
					VMCLight = vrcLight.GetComponent<Light>();
			}

			if (nextScene.name == "MainMenu")
			{
				SetActive(false);
			}
			if (nextScene.name == "GameCore")
			{
				SetActive(true);
			}
		}

		public void AddLight(int id)
        {
			SetLight(id, "VRMOptionLight", new Vector3(0f, 1.5453f, 0f), Quaternion.Euler(130f, 43f, 75f));
		}
		
		public void AddSaberLight(SaberType saberType,GameObject ownerObject,Color color)
        {
			RemoveSaberLight(saberType);
			SetSaberLight(saberType, ownerObject, color, "SaberLight", Vector3.zero, Quaternion.identity);
		}

		private void RemoveSaberLight(SaberType saberType)
        {
			if (SaberLightsGameObject.ContainsKey(saberType))
			{
				GameObject.DestroyImmediate(Plugin.instance.OptionLight.SaberLightsGameObject[saberType]);

				Plugin.instance.OptionLight.SaberLightsGameObject.Remove(saberType);
				Plugin.instance.OptionLight.SaberLights.Remove(saberType);
			}


		}

		private void SetLight(int id,string Name, Vector3 position, Quaternion rotation)
        {
			GameObject gameObject = new GameObject(Name);
			gameObject.transform.position = position;
			gameObject.transform.rotation = rotation;
			gameObject.transform.SetParent(base.transform);
			Lights[id] = gameObject.AddComponent<Light>();
			Lights[id].type = LightType.Directional;
			Lights[id].color = new Color(1f, 1f, 1f);
			Lights[id].renderingLayerMask = 15;
		}

		private void SetSaberLight(SaberType saberType, GameObject ownerObject, Color color, string Name, Vector3 position, Quaternion rotation)
		{
			SaberLightsGameObject[saberType] = new GameObject(Name);
            SaberLightsGameObject[saberType].transform.position = position;
            SaberLightsGameObject[saberType].transform.rotation = rotation;
            SaberLightsGameObject[saberType].transform.SetParent(ownerObject.transform);
            SaberLights[saberType] = SaberLightsGameObject[saberType].AddComponent<Light>();
			SaberLights[saberType].type = LightType.Point;
			SaberLights[saberType].color = color;
			SaberLights[saberType].renderingLayerMask = 15;
			SaberLights[saberType].range = 2f;
			//SaberLights[saberType].spotAngle = 1f;
		}

		private void SetActive(bool isActive)
        {
            if (VMCLight != null)
            {
                VMCLight.intensity = OtherMaterialChangeSetting.Instance.OtherParameter.IsAmbientLight & isActive ?
									 OtherMaterialChangeSetting.Instance.OtherParameter.VMCLightBoost : 1.0f;
			}

			foreach (Light light in Lights.Values)
				if (light != null) light.gameObject.SetActive(isActive);

			foreach (Light light in SaberLights.Values)
				if (light != null) light.gameObject.SetActive(isActive);
		}
	}
}
