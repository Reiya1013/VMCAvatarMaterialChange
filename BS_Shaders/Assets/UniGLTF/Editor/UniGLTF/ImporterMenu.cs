﻿using System.IO;
using UnityEditor;
using UnityEngine;


namespace UniGLTF
{
    public static class ImporterMenu
    {
        [MenuItem(UniGLTFVersion.MENU + "/Import(gltf, glb)", priority = 20)]
        public static void ImportMenu()
        {
            var path = EditorUtility.OpenFilePanel("open gltf", "", "gltf,glb");
            if (string.IsNullOrEmpty(path))
            {
                return;
            }

            if (Application.isPlaying)
            {
                //
                // load into scene
                //
                var context = new ImporterContext();
                context.Load(path);
                context.ShowMeshes();
                Selection.activeGameObject = context.Root;
            }
            else
            {
                //
                // save as asset
                //
                if (path.StartsWithUnityAssetPath())
                {
                    Debug.LogWarningFormat("disallow import from folder under the Assets");
                    return;
                }

                var assetPath = EditorUtility.SaveFilePanel("save prefab", "Assets", Path.GetFileNameWithoutExtension(path), "prefab");
                if (string.IsNullOrEmpty(path))
                {
                    return;
                }

                // import as asset
                gltfAssetPostprocessor.ImportAsset(path, Path.GetExtension(path).ToLower(), UnityPath.FromFullpath(assetPath));
            }
        }
    }
}
