using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Networking;
using System.IO;
using UnityEditor.Callbacks;
using System.Linq;
using System;
using System.Text.RegularExpressions;

namespace ArktoonShaders
{
    public class ArktoonManager : MonoBehaviour
    {
        static string url = "https://api.github.com/repos/synqark/Arktoon-Shaders/releases/latest";
        static UnityWebRequest www;
        public static readonly string version = "1.0.2.6";

        /// <summary>
        /// アセットが示すバージョンをintで返却
        /// マイグレーション時の移行先バージョンとして使われる
        /// </summary>
        /// <value></value>
        public static int AssetVersionInt {
            get
            {
                var new_version = ArktoonManager.version;
                System.Version newVersion = new System.Version(new_version);
                return newVersion.Major * 1000 + newVersion.Minor * 100 + newVersion.Build * 10 + newVersion.Revision;
            }
        }

        /// <summary>
        /// プロジェクトに記録されているArktoonのバージョンをintで返却
        /// マイグレーション時にマテリアルにバージョン情報が記載されていない場合に、移行元バージョンとして使われる
        /// そのため、存在しない場合はマイグレーション最小値である1.0.1.1固定となる。
        /// </summary>
        /// <value></value>
        public static int LocalVersionInt {
            get
            {
                string localVersion = EditorUserSettings.GetConfigValue("arktoon_version_local") ?? "";
                if(string.IsNullOrEmpty(localVersion)) localVersion = "1.0.1.1";
                System.Version existVersion = new System.Version(localVersion);
                return existVersion.Major * 1000 + existVersion.Minor * 100 + existVersion.Build * 10 + existVersion.Revision;
            }
        }

        public static readonly List<string> variations = new List<string>(){
                "arktoon/Opaque",
                "arktoon/Fade",
                "arktoon/AlphaCutout",
                "arktoon/FadeRefracted",
                "arktoon/Stencil/Reader/Cutout",
                "arktoon/Stencil/Reader/Double/FadeFade",
                "arktoon/Stencil/Reader/Fade",
                "arktoon/Stencil/Writer/Cutout",
                "arktoon/Stencil/WriterMask/Cutout"
                // TODO:これ動的にならないかな？
        };

        [DidReloadScripts(0)]
        private static void CheckVersion ()
        {
            if(EditorApplication.isPlayingOrWillChangePlaymode) return;

            // ローカルバージョンを確認
            Debug.Log ("[Arktoon] Checking local version.");
            string localVersion = EditorUserSettings.GetConfigValue("arktoon_version_local") ?? "";

            if (!localVersion.Equals(version)) {
                // Arktoonが更新または新規にインストールされているので、既存のマテリアルの更新を行う。
                ArktoonMigrator.Migrate();
            }
            // ローカルバージョンをセット
            EditorUserSettings.SetConfigValue("arktoon_version_local", version);

            // リモート(githubのpublic release)のバージョンを取得
            Debug.Log ("[Arktoon] Checking remote version.");
            www = UnityWebRequest.Get(url);
            #if UNITY_2017_OR_NEWER
            www.SendWebRequest();
            #else
            #pragma warning disable 0618
            www.Send();
            #pragma warning restore 0618
            #endif

            EditorApplication.update += EditorUpdate;
        }

        private static void EditorUpdate()
        {
            while (!www.isDone) return;

            #if UNITY_2017_OR_NEWER
                if (www.isNetworkError || www.isHttpError) {
                    Debug.Log(www.error);
                } else {
                    UpdateHandler(www.downloadHandler.text);
                }
            #else
                #pragma warning disable 0618
                if (www.isError) {
                    Debug.Log(www.error);
                } else {
                    UpdateHandler(www.downloadHandler.text);
                }
                #pragma warning restore 0618
            #endif

            EditorApplication.update -= EditorUpdate;
        }

        static void UpdateHandler(string apiResult)
        {
            gitJson git = JsonUtility.FromJson<gitJson>(apiResult);
            string version = git.tag_name;
            EditorUserSettings.SetConfigValue ("arktoon_version_remote", version);
            Debug.Log("[Arktoon] Remote version : " + version);
        }

        public class gitJson
        {
            public string tag_name;
        }
    }
}