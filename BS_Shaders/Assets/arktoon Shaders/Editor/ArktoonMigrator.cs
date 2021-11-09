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
    public class ArktoonMigrator : MonoBehaviour
    {

        // 自動マイグレーション設定
        const string autoMigrateMenuPath = "Arktoon/Migration/Auto Migration";
        public static bool AutoMigrate {get;set;} // デフォルトがチェック済みの時には true にする
        [InitializeOnLoadMethod]
        static void CallSetAutoMigrate() {
            EditorApplication.delayCall += SetAutoMigrate;
        }
        static void SetAutoMigrate() {
            AutoMigrate = bool.Parse(EditorUserSettings.GetConfigValue("select") ?? "true");
            Menu.SetChecked(autoMigrateMenuPath, AutoMigrate);
        }
        [MenuItem(autoMigrateMenuPath)]
        public static void MenuAutoMigrate ()
        {
            AutoMigrate = !AutoMigrate;
            Menu.SetChecked(autoMigrateMenuPath, AutoMigrate);
            EditorUserSettings.SetConfigValue("select", AutoMigrate.ToString());
        }
        [MenuItem(autoMigrateMenuPath, true)]
        public static bool MenuAutoMigrateValidate ()
        {
            Menu.SetChecked(autoMigrateMenuPath, AutoMigrate);
            return true;
        }


        // マイグレーションをする
        [MenuItem("Arktoon/Migration/Force migrate all arktoon materials")]
        private static void MigrateFromMenu(){
            Migrate();
        }

        /// <summary>
        /// プロジェクトに含まれるArktoonマテリアルのマイグレーションを実行
        /// </summary>
        public static void Migrate()
        {
            // Arktoonを使用しているマテリアルを列挙
            var mats = CollectMaterials(ArktoonManager.variations.ToArray());
            var matsList  = mats.ToList();
            // 列挙したマテリアルをマイグレーションする。
            var log = matsList.Select(mat => MigrateArktoonMaterial(mat));
            Debug.Log(string.Join("", new List<string>(){"Migration Report :" + Environment.NewLine}.Concat(log).ToArray()));
        }

        /// <summary>
        /// 指定されたシェーダーが使われているマテリアルを探す
        /// </summary>
        /// <param name="shaderName">探したいマテリアルのシェーダー名</param>
        /// <returns></returns>
        private static List<Material> CollectMaterials(string[] shaderNames) {
            List<Material> armat = new List<Material>();
            Renderer[] arrend = (Renderer[])Resources.FindObjectsOfTypeAll(typeof(Renderer));
            foreach (Renderer rend in arrend) {
                foreach (Material mat in rend.sharedMaterials) {
                    if (mat != null && !armat.Contains (mat)) {
                        if (mat.shader != null && mat.shader.name != null && shaderNames.Contains(mat.shader.name)) {
                            armat.Add (mat);
                        }
                    }
                }
            }
            return armat;
        }

        /// <summary>
        /// 指定したマテリアルのマイグレーションを行う
        /// </summary>
        /// <param name="mat">対象のマテリアル</param>
        /// <returns></returns>
        public static string MigrateArktoonMaterial(Material mat)
        {
            var log = "";
            // 移行先バージョンは、ArktoonManager.AssetVersionIntが持っている
            var newVersion = ArktoonManager.AssetVersionInt;

            // currentVersion(移行前バージョン)の決定方法
            // 対象マテリアルの "_Version" プロパティを確認する。
            //  _Version > 0である場合、_Versionそのものが移行前バージョンである
            //  _Versionが0である場合、「Arktoonアセットの更新前バージョン または 1.0.1.1の古いほう」を移行前バージョンとする
            var curreentVersion = 0;
            if(mat.HasProperty("_Version") && mat.GetInt("_Version") > 0) {
                curreentVersion = mat.GetInt("_Version");
            } else {
                curreentVersion = ArktoonManager.LocalVersionInt;
            }
            log += String.Format("{0} (v{1}) : ", mat.name, curreentVersion);

            // 1.0.0.0 ← (any)
            // 最初のバージョン
            // それ以前からのマイグレーションは実施しない。
            if( curreentVersion < 1000 ) {
                // do nothing
                log += String.Format(" 1000");
            }

            // 1.0.1.0 ← 1.0.0.0
            // - OUTLINE_WIDTH_MASKを排除する。
            // - UseOutlineWidthMaskがオフか、オンではあるがマスクテクスチャが指定されていない場合は、マスクテクスチャの割り当てを解除する。
            // - Use Custom Shadeがオンである場合に、Shadow Strengthを1にする
            if( curreentVersion < 1010 ) {
                mat.DisableKeyword("OUTLINE_WIDTH_MASK");
                if( (mat.HasProperty("_UseOutlineWidthMask") && mat.GetFloat("_UseOutlineWidthMask") == 0) ||
                    (mat.HasProperty("_OutlineWidthMask")    && mat.GetTexture("_OutlineWidthMask") == null )) {
                        mat.SetTexture("_OutlineWidthMask", null);
                }
                if (mat.GetInt("_ShadowPlanBUsePlanB") > 0) {
                    mat.SetFloat("_ShadowStrength", 1.0f);
                }
                log += String.Format(" 1010");
            }

            // 1.0.2.0 ← 1.0.1.0
            // shaderNameが使用されている全てのマテリアルに設定されているシェーダーキーワードを削除する。
            if( curreentVersion < 1020 ) {
                if (mat != null && mat.shader != null) {
                    var keywords = new List<string>(mat.shaderKeywords);
                    keywords.ForEach(keyword => mat.DisableKeyword(keyword));
                }
                log += String.Format(" 1020");
            }

            // バージョンを更新
            mat.SetInt("_Version", newVersion);
            return log + Environment.NewLine;
        }



        [MenuItem("Arktoon/Clear Shader Keywords")]
        private static void ClearArktoonKeywords()
        {
            ClearKeywordsByShader(ArktoonManager.variations.ToArray());
        }

        /// <summary>
        /// 指定されたシェーダーを使っている全てのマテリアルに登録されている全てのシェーダーキーワードを削除する
        /// </summary>
        /// <param name="shaderName">削除したいマテリアルが使っているシェーダー</param>
        private static void ClearKeywordsByShader(string[] shaderNames) {
            var stArea = "";
            List<Material> armat = new List<Material>();
            Renderer[] arrend = (Renderer[])Resources.FindObjectsOfTypeAll(typeof(Renderer));
            foreach (Renderer rend in arrend) {
                foreach (Material mat in rend.sharedMaterials) {
                    if (!armat.Contains (mat)) {
                        armat.Add (mat);
                    }
                }
            }
            foreach (Material mat in armat) {
                if (mat != null && mat.shader != null && mat.shader.name != null && shaderNames.Contains(mat.shader.name)) {
                    stArea += ">"+mat.name + ":" + string.Join(" ", mat.shaderKeywords) + "\n";
                    var keywords = new List<string>(mat.shaderKeywords);
                    keywords.ForEach(keyword => mat.DisableKeyword(keyword));
                    stArea += ">"+mat.name + ":" + string.Join(" ", mat.shaderKeywords) + "\n";
                }
            }
            Debug.Log(stArea);
        }
    }
}