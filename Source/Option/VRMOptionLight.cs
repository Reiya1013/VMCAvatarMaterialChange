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

		//Light RightSaberLight;
		//Light LeftSaberLight;

		private LightmapLightsWithIds lightmapLightsWithIds;
		private LightmapLightsWithIds.LightIntensitiesData[] lightIntensitiesDatas;

		private void Awake()
        {
			//シーンチェンジイベントセット
			SceneManager.activeSceneChanged += OnActiveSceneChanged;
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
				VMCLight = GameObject.Find("VMCAvatar/VMCLight").GetComponent<Light>();
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

		//private void GetLightmap()
  //      {
		//	if (lightmapLightsWithIds == null)
		//	{
		//		GameObject gameObject = GameObject.Find("Environment/LightWithIdManager");
		//		if (gameObject != null)
		//		{
		//			var lightWithIdManager = gameObject.GetComponent<LightWithIdManager>();
		//			lightWithIdManager.colors
		//			lightmapLightsWithIds = gameObject.GetComponent<LightmapLightsWithIds>();
		//			lightIntensitiesDatas = lightmapLightsWithIds.GetField<LightmapLightsWithIds.LightIntensitiesData[], LightmapLightsWithIds>("_lights");
		//		}
		//	}
		//}

		//private void Update()
  //      {

		//	if (lightIntensitiesDatas != null)
  //          {
		//		foreach (var lightmap in lightIntensitiesDatas)
		//		{
		//			if (!Lights.ContainsKey(lightmap.lightId))
		//			{
		//				AddLight(lightmap.lightId);
		//			}
		//			Lights[lightmap.lightId].color = lightmap.color;
		//		}
		//	}

		//}

		public void AddLight(int id)
        {
			SetLight(id, "VRMOptionLight", new Vector3(0f, 1.5453f, 0f), Quaternion.Euler(130f, 43f, 75f));
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

		private void SetSaberLight(Light light, string Name, Vector3 position, Quaternion rotation)
		{
			GameObject gameObject = new GameObject(Name);
			gameObject.transform.position = position;
			gameObject.transform.rotation = rotation;
			gameObject.transform.SetParent(base.transform);
			light = gameObject.AddComponent<Light>();
			light.type = LightType.Rectangle;
			light.color = new Color(1f, 1f, 1f);
			light.renderingLayerMask = 15;
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

			//if (RightSaberLight != null) RightSaberLight.gameObject.SetActive(isActive);
			//if (LeftSaberLight != null) LeftSaberLight.gameObject.SetActive(isActive);
		}
	}
}
