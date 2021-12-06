using System;
using System.Collections.Generic;
using BeatSaberMarkupLanguage;
using UnityEngine;
using UnityEngine.SceneManagement;
using IPALogger = IPA.Logging.Logger;
using IPA.Utilities;

namespace VMCAvatarMaterialChange
{
    class VMCAvatarRoomAdjust : MonoBehaviour
    {

		private Vector3 startOffset;
		public VRCenterAdjust CenterAdjust;


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
			//作りかけのため一時停止
			return;

			if (!CenterAdjust) return;
			if (nextScene.name == "MainMenu")
			{
				CenterAdjust.transform.position = startOffset;
			}
			if (nextScene.name == "GameCore")
			{
				startOffset = CenterAdjust.transform.position;
			}
		}

		public void SetupVRCenterAdjust(VRCenterAdjust centerAdjust)
        {
			CenterAdjust = centerAdjust;
			startOffset = CenterAdjust.transform.position;
		}
	}
}
