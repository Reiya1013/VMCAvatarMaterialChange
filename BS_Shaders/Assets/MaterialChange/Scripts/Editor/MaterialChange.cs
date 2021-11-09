using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using MenuItem = UnityEditor.MenuItem;
using AssetBundleBuild = UnityEditor.AssetBundleBuild;
using System.Linq;

public class EditorWindowSample : EditorWindow
{

    [MenuItem("MaterialChange/MaterialChange Setting")]
    private static void Create()
    {
        // 生成
        GetWindow<EditorWindowSample>("MaterialChange設定画面");

        GUILayout.Width(500);
    }

    /// <summary>
    /// ScriptableObjectSampleの変数
    /// </summary>
    private MaterialChangeObject _base;
    private String BaseAssets = "Assets/MaterialChange/Avatars/";
    private GameObject oldBase;
    //スクロール位置
    private Vector2 _scrollPosition = Vector2.zero;

    private void OnGUI()
    {
        if (_base == null)
        {
            _base = ScriptableObject.CreateInstance<MaterialChangeObject>();

        }

        //Hierarchy上で選択しているGameObjectを配列で受け取る
        GameObject gameObject = null;
        foreach (GameObject go in Selection.gameObjects)
        {
            gameObject = go;
        }

        if (gameObject == null && _base.baseObject == null) return;
        if (gameObject != null && _base.baseObject == null)
        {
            _base.baseObject = gameObject;
        }
        if (oldBase != _base.baseObject)
        {
            _base.reset();
        }
        oldBase = gameObject;


        var allowSceneObjects = !EditorUtility.IsPersistent(_base.baseObject);
        _base.baseObject = (GameObject)EditorGUILayout.ObjectField(_base.baseObject, typeof(GameObject), allowSceneObjects);

        if (_base.baseObject == null) return;


        foreach (Renderer renderer in _base.baseObject.GetComponentsInChildren<Renderer>(true))
        {
            {
                foreach (var material in renderer.sharedMaterials)
                {
                    //Debug.Log(AssetDatabase.GetAssetPath(material));

                    string name = AssetDatabase.GetAssetPath(material);

                    if (CheckSetMaterial(name))
                    {
                        _base._materialsIndex.Add(name);
                        _base._materialsRendereName[name] = renderer.name;
                        _base._materialsAssets[name] = AssetDatabase.GetAssetPath(material);
                        _base._materialsValue[name] = material;
                        _base._newMaterialsValue[name] = null;
                        _base._newMaterialsAssets[name] = null;
                        SelectMaterial();
                    }
                    //else if(_sample._newMaterialsValue[name] != null)
                    //{
                    //    _sample._newMaterialsAssets[name] = AssetDatabase.GetAssetPath(_sample._newMaterialsValue[name]);
                    //}
                }
            }
        }

        using (new GUILayout.HorizontalScope(GUI.skin.box))
        {

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("メッシュ名", "VRMマテリアル");
            EditorGUILayout.LabelField("変更後マテリアル");
            EditorGUILayout.EndHorizontal();

            EditorGUILayout.EndVertical();
            EditorGUILayout.BeginVertical();

            //描画範囲が足りなければスクロール出来るように
            _scrollPosition = EditorGUILayout.BeginScrollView(_scrollPosition);
            foreach (String name in _base._materialsIndex)
            {
                using (new GUILayout.VerticalScope())
                {

                    var allowSceneObjectsP = !EditorUtility.IsPersistent(_base._materialsValue[name]);

                    EditorGUILayout.BeginHorizontal();
                    _base._materialsValue[name] = (Material)EditorGUILayout.ObjectField(_base._materialsRendereName[name], _base._materialsValue[name], typeof(Material), allowSceneObjectsP);
                    _base._newMaterialsValue[name] = (Material)EditorGUILayout.ObjectField(_base._newMaterialsValue[name], typeof(Material), allowSceneObjectsP);
                    EditorGUILayout.EndHorizontal();
                }
            }
            //スクロール箇所終了
            EditorGUILayout.EndScrollView();
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("追加Animation", "");
            _base._AnimatorController = (RuntimeAnimatorController)EditorGUILayout.ObjectField(_base._AnimatorController, typeof(RuntimeAnimatorController), !EditorUtility.IsPersistent(_base._AnimatorController));
            EditorGUILayout.EndHorizontal();

        }

        using (new GUILayout.VerticalScope())
        {
            if (GUILayout.Button("MaterialChange用にMaterialをコピーする"))
            {
                CopyMaterial();
            }
        }


        using (new GUILayout.VerticalScope())
        {
            if (GUILayout.Button("MaterialChange用にMaterialを選択する"))
            {
                SelectMaterial();
            }
        }

        using (new GUILayout.VerticalScope())
        {
            if (GUILayout.Button("MaterialChange用Materialのシェーダーをビーセイ用に変更"))
            {
                SetBeatSaberShader();
            }
        }

        using (new GUILayout.VerticalScope())
        {
            if (GUILayout.Button("MaterialChange用ファイルを出力する"))
            {
                SaveAssetBundles();
            }
        }

        if (!CheckSaber())
        {
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("※BeatSaber用シェーダー以外が使用されてます。");
            EditorGUILayout.EndHorizontal();
        }

    }

    private bool CheckSetMaterial(String assetName)
    {
        foreach (String name in _base._materialsIndex)
        {
            if (name == assetName) return false;
        }
        return true;
    }

    private void SelectMaterial()
    {
        foreach (String name in _base._materialsIndex)
        {
            string[] names = name.Split('/');
            if (File.Exists(BaseAssets + _base.baseObject.name + '/' + names[names.Length - 1].Replace(".asset", ".mat")))
            {
                _base._newMaterialsAssets[name] = BaseAssets + _base.baseObject.name + '/' + names[names.Length - 1].Replace(".asset", ".mat");
                _base._newMaterialsValue[name] = (Material)AssetDatabase.LoadAssetAtPath(_base._newMaterialsAssets[name], typeof(Material));
            }
        }
    }

    private void SetBeatSaberShader()
    {
        foreach (Material material in _base._newMaterialsValue.Values)
        {
            //シェーダー名にBeatSaberが含まれてるか確認し、含まれてない場合頭にBeatSaber/をつけてシェーダーがあるか確認し、ある場合置き換える
            if (!material.shader.name.Contains("BeatSaber/"))
            {
                var shader = Shader.Find($"BeatSaber/{material.shader.name}");
                if (shader != null)
                    material.shader = shader;
            }
        }
    }

    private bool CheckSaber()
    {
        foreach (Material material in _base._newMaterialsValue.Values)
        {
            //シェーダー名にBeatSaberが含まれてるか確認し、含まれてない場合頭にBeatSaber/をつけてシェーダーがあるか確認し、ある場合置き換える
            if (!material.shader.name.Contains("BeatSaber/"))
            {
                return false;
            }
        }
        return true;
    }

    private void CopyMaterial()
    {
        foreach (String name in _base._materialsIndex)
        {
            try
            {
                string[] names = name.Split('/');
                FolderName(_base.baseObject.name);
                if (!File.Exists(BaseAssets + _base.baseObject.name + '/' + names[names.Length - 1]))
                {
                    //コピー時に拡張子がassetだった場合matに変更
                    AssetDatabase.CopyAsset(name, BaseAssets + _base.baseObject.name + '/' + names[names.Length - 1].Replace(".asset", ".mat")); ;
                    //_sample._newMaterialsAssets[name] = BaseAssets + _sample.baseObject.name + '/' + names[names.Length - 1];
                    //_sample._newMaterialsValue[name] = (Material)AssetDatabase.LoadAssetAtPath(_sample._newMaterialsAssets[name], typeof(Material));
                }
            }
            catch
            {

            }
        }
    }

    private void FolderName(string folderName)
    {
        string path = BaseAssets + folderName;

        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }

        AssetDatabase.ImportAsset(path);
    }


    private void ResetName()
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
    }

    private void SaveAssetBundles()
    {
        var path = EditorUtility.SaveFilePanel("MaterialChange File Save", "", "", "mc");
        if (path == "") return;
        foreach (String name in _base._materialsIndex)
        {
            //最初にアセットバンドル化するオブジェクトを取得する
            _base._newMaterialsAssets[name] = AssetDatabase.GetAssetPath(_base._newMaterialsValue[name]);

        }
        int addCnt = 0;
        string AnimatorController = null;
        if (_base._AnimatorController)
        {
            AnimatorController = AssetDatabase.GetAssetPath(_base._AnimatorController);
            addCnt = 1;
        }

        string[] vals = new string[_base._newMaterialsAssets.Values.Count + addCnt];
        _base._newMaterialsAssets.Values.CopyTo(vals, 0);
        if (!String.IsNullOrEmpty(AnimatorController))
            vals[vals.Length - 1] = AnimatorController;

        AssetBundleBuild[] buildMap = new AssetBundleBuild[1];
        buildMap[0].assetBundleName = Path.GetFileName(path);
        buildMap[0].assetNames = vals;

        string outputPath = $"{Application.temporaryCachePath}/{Path.GetRandomFileName()}";
        Directory.CreateDirectory(outputPath);
        if (BuildPipeline.BuildAssetBundles(outputPath, buildMap, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows))
        {
            //Assetbundle成功時Tempフォルダから必要ファイル移動後、フォルダ削除
            if (File.Exists(path)) File.Delete(path);
            File.Copy(outputPath + "/" + buildMap[0].assetBundleName, path);
            Directory.Delete(Application.temporaryCachePath, true);
        }

        UnityEditor.EditorUtility.DisplayDialog("MaterialChange", "ファイル出力完了", "OK");

    }

}

[Serializable]
public class MaterialChangeObject : ScriptableObject
{
    public GameObject baseObject { get; set; }
    [SerializeField]
    public List<String> _materialsIndex { get; set; } = new List<String>();
    [SerializeField]
    public Dictionary<String, String> _materialsRendereName { get; set; } = new Dictionary<String, String>();
    [SerializeField]
    public Dictionary<String, String> _materialsAssets { get; set; } = new Dictionary<String, String>();
    [SerializeField]
    public Dictionary<string, Material> _materialsValue { get; set; } = new Dictionary<string, Material>();
    [SerializeField]
    public Dictionary<string, Material> _newMaterialsValue { get; set; } = new Dictionary<string, Material>();
    [SerializeField]
    public Dictionary<string, String> _newMaterialsAssets { get; set; } = new Dictionary<string, String>();
    [SerializeField]
    public RuntimeAnimatorController _AnimatorController { get; set; }

    public void reset()
    {
        _materialsIndex.Clear();
        _materialsRendereName.Clear();
        _materialsAssets.Clear();
        _materialsValue.Clear();
        _newMaterialsValue.Clear();
        _newMaterialsAssets.Clear();
    }
}