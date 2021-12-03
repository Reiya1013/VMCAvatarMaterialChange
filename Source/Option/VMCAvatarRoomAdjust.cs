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
		public VRCenterAdjust centerAdjust;

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
			if (!centerAdjust) return;
			if (nextScene.name == "MainMenu")
			{
				centerAdjust.transform.position = startOffset;
			}
			if (nextScene.name == "GameCore")
			{
				startOffset = centerAdjust.transform.position;
			}
		}
	}
}
