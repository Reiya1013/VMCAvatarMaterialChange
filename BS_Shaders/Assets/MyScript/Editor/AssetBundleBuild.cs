using System.IO;
using UnityEditor;

public class AssetBundleBuild_
{
    [MenuItem("Expansion_/Build AssetBundleData")]
    public static void Build()
    {
        string assetBundleDirectory = "./AssetBundleData";      // 出力先ディレクトリ

        // 出力先ディレクトリが無かったら作る
        if (!Directory.Exists(assetBundleDirectory))
        {
            Directory.CreateDirectory(assetBundleDirectory);
        }

        // AssetBundleのビルド(ターゲット(プラットフォーム)毎に3つ目の引数が違うので注意)
        BuildPipeline.BuildAssetBundles(assetBundleDirectory, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows);

        // ビルド終了を表示
        EditorUtility.DisplayDialog("アセットバンドルビルド終了", "アセットバンドルビルドが終わりました", "OK");
    }

    [MenuItem("Expansion_/Reset AssetBundle Name")]
    private static void ResetName()
    {
        AssetDatabase.StartAssetEditing();

        foreach (var assetPath in AssetDatabase.GetAllAssetPaths())
        {
            var assetImporter = AssetImporter.GetAtPath(assetPath);

            if (string.IsNullOrWhiteSpace(assetImporter.assetBundleName)) continue;

            assetImporter.SetAssetBundleNameAndVariant(null, null);
            assetImporter.SaveAndReimport();
        }

        AssetDatabase.StopAssetEditing();

        foreach (var n in AssetDatabase.GetAllAssetBundleNames())
        {
            AssetDatabase.RemoveAssetBundleName(n, true);
        }

        AssetDatabase.SaveAssets();

        // ビルド終了を表示
        EditorUtility.DisplayDialog("アセットバンドル名称リセット終了", "アセットバンドル名称リセットが終わりました", "OK");
    }
}
