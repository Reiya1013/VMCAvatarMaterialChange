using UnityEngine;
using UnityEditor;
using System;

namespace AxCharacterShaders.AxTips
{
    public class AxTipWindow : EditorWindow
    {
        Vector2 scrPos = Vector2.zero;
        AxcsTip tipShowing;

        public static void ShowTips(Func<AxcsTip> func)
        {
            AxTipWindow window = (AxTipWindow)EditorWindow.GetWindow(typeof(AxTipWindow));
            window.tipShowing = func();
            window.titleContent = new GUIContent("AXCS_Tips");
            window.Show();
        }

        /// <summary>
        /// GUI描画
        /// </summary>
        void OnGUI()
        {
            scrPos = EditorGUILayout.BeginScrollView(scrPos);

            var texure = AssetDatabase.LoadAssetAtPath<Texture2D>( AssetDatabase.GUIDToAssetPath( "ebc83669f167a5346b3608ef9d1c91e0" ));
            if(this.tipShowing != null)  {
                EditorGUILayout.LabelField(this.tipShowing.Title, EditorStyles.boldLabel);
                EditorGUILayout.TextArea(this.tipShowing.Description, EditorStyles.label);
                // if(this.tipShowing.imageUrl != ""){
                //     // EditorGUILayout.LabelField(new GUIContent(texure), new GUILayoutOption[]{
                //     //     GUILayout.Width(600),
                //     //     GUILayout.Height(100),
                //     // });
                // }
                EditorGUILayout.LabelField("", GUI.skin.horizontalSlider);

                foreach (var item in this.tipShowing.properties)
                {
                    for(var i = 0; i< item.indentOffset; i++) EditorGUI.indentLevel++;
                    EditorGUILayout.LabelField(item.name, EditorStyles.boldLabel);
                    EditorGUI.indentLevel++;
                    var style = EditorStyles.label;
                    style.wordWrap = true;
                    EditorGUILayout.TextArea(item.content, style);
                    EditorGUI.indentLevel--;
                    for(var i = 0; i< item.indentOffset; i++) EditorGUI.indentLevel--;
                }
            }
            EditorGUILayout.EndScrollView();
        }
    }

    public abstract class AxcsTip
    {
        public string Title;
        public string Description;
        public Property[] properties = new Property[]{};
        public string imageUrl;
        public struct Property
        {
            public string name;
            public string content;
            public int indentOffset;

            public Property(string name, string content, int indentOffset = 0)
            {
                this.name = name;
                this.content = content;
                this.indentOffset = indentOffset;
            }
        }
    }

    class Initial : AxcsTip
    {
        public Initial()
        {
            Title = "Tips";
            Description = "カテゴリタイトルの右端をクリックすると説明が表示されます。";
        }
    }
    class AxcsGenerator : AxcsTip
    {
        public AxcsGenerator()
        {
            Title = "Generator";
            Description = "「Opaque, Fade, Cutout, FadeRefracted」の4種類のシェーダーから、「StencilReader, StencilWriter, EmissiveFreak, Outline」のバリエーションを作ることができます。 全てのシェーダーを再生成する場合は、メニューの番号順に実行してください。 自動生成されるシェーダーのプロパティに手を加えたい場合は、アセット内の [ArxCharacterShaders\\Editor\\Generator\\AxGenerator.cs] 内に定義されている書き換えコードを修正してください。";
            properties = new Property[] {
                new Property("1.GenerateStencilWriter", "CutoutからStencilWriter_Cutoutを作成します。"),
                new Property("2.GenerateStencilReader", "Cutout, Fade, FadeRefractedからStencilReader_〇〇を作成します。"),
                new Property("※StencilReader_DoubleFadeについて", "DoubleFadeは自動生成の対象ではないため、手動で整える必要があります。 StencilReader_Fadeを参考に修正してください。", 1),
                new Property("3.GenerateEmissiveFreak", "EmissiveFreak, Outline以外のシェーダーからEmissiveFreak_〇〇を作成します。"),
                new Property("4.GenerateOutline", "Fade, Outline以外のシェーダーからOutline_〇〇を作成します。"),
            };
        }
    }
}