using UnityEngine;
using UnityEditor;
using System;

namespace AxCharacterShaders
{
    public class AxCommon : ScriptableObject
    {
        static AxCommon instance;

        // ArxCharacterShaderが保管されているディレクトリパスを取得
        public static string GetBaseDir()
        {
            if (instance == null) instance = (AxCommon)ScriptableObject.CreateInstance(typeof(AxCommon));
            var obj = MonoScript.FromScriptableObject(instance);
            var path = AssetDatabase.GetAssetPath(obj);
            path = path.Substring(0,path.IndexOf("Editor/AxCommon.cs"));
            return path;
        }
    }

    public class AxDocs
    {
        private const string baseUrl = "https://synqark.github.io/AXCS_Docs/";
        private const string docPath = "3-documents/";

        public static void Open(string path)
        {
            Application.OpenURL(baseUrl + docPath + path);
        }
    }
}