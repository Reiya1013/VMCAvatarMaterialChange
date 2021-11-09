using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;


namespace AxCharacterShaders.Generator
{
    public class AxGenerator
    {
        // 対象とするシェーダー名のキーワード
        // フォルダ以下のシェーダー一覧から対象キーワードで絞った後、除外キーワードによって一部を対象から外す
        public string[] includeShaderNames;

        // 除外するシェーダー名のキーワード
        public string[] excludeShaderNames;

        // シェーダー名のプレフィクス
        public string namePrefix;

        // シェーダーカテゴリの挿入位置とプレフィクス
        public KeyValuePair<int, string> variationName;

        // ファイル名のプレフィクス
        public string fileNamePrefix;

        // 置換キーワードと置換内容の配列
        public Dictionary<string, string> replaceCodes;

        public void run(bool isCheckOnly = false)
        {
            // 対象シェーダーファイルを収集
            var shaders = AssetDatabase.FindAssets("t:Shader", new string[]{AxCommon.GetBaseDir() + "Shaders"});

            // includeShaderNamesを含み、excludeShaderNamesを含まないシェーダーに絞る
            var targets = shaders.Where(item => {
                var path = AssetDatabase.GUIDToAssetPath(item);
                var filename = Path.GetFileName(path);
                return includeShaderNames.Any(i => filename.Contains(i)) && !excludeShaderNames.Any(i => filename.Contains(i));
            });

            if (isCheckOnly){
                foreach (var shader in targets) {
                    var path = AssetDatabase.GUIDToAssetPath(shader);
                    var filename = Path.GetFileName(path);
                    Debug.Log(filename);
                }
                return;
            }

            // 改変を開始
            foreach (var shader in targets) {
                var path = AssetDatabase.GUIDToAssetPath(shader);
                var filename = Path.GetFileName(path);

                // 変換後のファイルパスを作成
                var destFilename = Path.GetDirectoryName(path) + Path.DirectorySeparatorChar + this.fileNamePrefix + filename;

                // シェーダーコードの変換
                var shaderCode = LoadTextFileFromDisk(path);
                var destShaderName = "";
                for (var line = 0; line < shaderCode.Count ; line++) {

                    // シェーダー名の変更
                    if (string.IsNullOrEmpty(destShaderName) && shaderCode[line].StartsWith("Shader")) {
                        // シェーダー名を分解
                        var pathinfile = shaderCode[line].Split('"')[1];
                        var shaderNameArray = new List<string>(pathinfile.Split('/'));

                        // カテゴリが定義されていれば所定の位置に追加
                        if (this.variationName.Key > 0) {
                            shaderNameArray.Insert(variationName.Key, variationName.Value);
                        }

                        // シェーダー名を決定
                        shaderNameArray.Insert(shaderNameArray.Count-1, this.namePrefix + shaderNameArray.Last());
                        shaderNameArray.RemoveAt(shaderNameArray.Count-1);
                        destShaderName = string.Join("/", shaderNameArray);

                        // コードに反映
                        var newShaderNameLine = $"Shader \"{destShaderName}\"{shaderCode[line].Split('"')[2]}";
                        shaderCode.RemoveAt(line);
                        shaderCode.Insert(line, newShaderNameLine);
                    }

                    // キーワードの置換
                    if (shaderCode[line].Contains("AXCS_GENERATOR")) {
                        var keyword = shaderCode[line].Substring(shaderCode[line].IndexOf(":")+1);
                        // 先頭についているスペースとタブ文字数を取得
                        var spacing = 0;
                        foreach(var c in shaderCode[line]) {
                            if (!Char.IsWhiteSpace(c)) break;
                            spacing++;
                        }
                        if (replaceCodes.ContainsKey(keyword)) {
                            var code = replaceCodes[keyword];
                            var lines = code.Split(new[]{"\r\n","\n","\r"}, StringSplitOptions.None);
                            shaderCode.RemoveAt(line);
                            shaderCode.InsertRange(line, lines.Select(text => {
                                    text = text.Trim();
                                    if (text.Length == 0) return text;
                                    if (text.StartsWith(@"}")) spacing-=4;
                                    text = new string(' ', spacing) + text;
                                    if (text.EndsWith(@"{")) spacing+=4;
                                    return text;
                                }
                            ));
                        }
                    }
                }
                Debug.Log("ファイルパス：" + destFilename + Environment.NewLine + "シェーダー名：" + destShaderName);

                // 変換結果を出力
                SaveTextfileToDisk(shaderCode, destFilename);
            }
            // シェーダーをReimport
            AssetDatabase.Refresh();
        }

        [MenuItem("AXCS/Generator/ジェネレーターについて" , priority = 1)]
        public static void ShowGeneratorIs()
        {
            AxTips.AxTipWindow.ShowTips(() => new AxTips.AxcsGenerator());
        }

        [MenuItem("AXCS/Generator/1.GenerateStencilWriter", priority = 21)]
        public static void generateStencilWriterVariation()
        {
            // StencilWriterジェネレーター
            var stencilWriterGenerator = new AxGenerator(){
                includeShaderNames = new string[]{"Cutout"},
                excludeShaderNames = new string[]{"Stencil", "Outline", "EmissiveFreak"},
                namePrefix = "",
                fileNamePrefix = "StencilWriter_",
            };
            stencilWriterGenerator.replaceCodes = new Dictionary<string, string>();
            stencilWriterGenerator.replaceCodes.Add(
                "STENCIL_WRITER_PROPERTIES",
                $@"// Stencil Writer
                _StencilNumber (""[StencilWriter] Number"", int) = 5
                _StencilMaskTex (""[StencilWriter] Mask Texture"", 2D) = ""white"" {{}}
                _StencilMaskAdjust (""[StencilWriter] Mask Texture Adjust"", Range(0, 1)) = 0.5
                _StencilMaskAlphaDither (""[StencilWriter] StencilAlpha(Dither)"", Range(0, 1)) = 1.0"
            );
            stencilWriterGenerator.replaceCodes.Add(
                "STENCIL_WRITER_SHADER_PASS",
                $@"Pass {{
                    Name ""STENCIL_WRITER""
                    Tags {{
                    }}
                    Cull [_Cull]

                    Stencil {{
                        Ref [_StencilNumber]
                        Comp Always
                        Pass Replace
                    }}

                    CGPROGRAM

                    #pragma vertex vert
                    #pragma fragment frag
                    #pragma only_renderers d3d9 d3d11 glcore gles
                    #pragma target 3.0
                    #define AXCS_CUTOUT

                    #include ""cginc/arkludeDecl.cginc""
                    #include ""cginc/arkludeOther.cginc""
                    #include ""cginc/arkludeVertGeom.cginc""
                    #include ""cginc/arkludeFragOnlyStencilWrite.cginc""
                    ENDCG
                }}"
            );

            stencilWriterGenerator.variationName = new KeyValuePair<int, string>(1, "_StencilWriter");
            stencilWriterGenerator.run();
        }

        [MenuItem("AXCS/Generator/2.GenerateStencilReader", priority = 22)]
        public static void generateStencilReaderVariation()
        {
            // StencilReaderジェネレーター
            var stencilReaderGenerator = new AxGenerator(){
                includeShaderNames = new string[]{"Cutout", "Fade"},
                excludeShaderNames = new string[]{"Stencil", "Outline", "EmissiveFreak"},
                namePrefix = "",
                fileNamePrefix = "StencilReader_",
            };
            stencilReaderGenerator.replaceCodes = new Dictionary<string, string>();
            stencilReaderGenerator.replaceCodes.Add(
                "STENCIL_READER_PROPERTIES",
                $@"// Stencil(Reader)
                _StencilNumber (""[StencilReader] Number"", int) = 5
                [Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompareAction (""[StencilReader] Compare Action"", int) = 6"
            );
            stencilReaderGenerator.replaceCodes.Add(
                "STENCIL_READER_QUEUE",
                $@"""Queue""=""AlphaTest+1"""
            );
            stencilReaderGenerator.replaceCodes.Add(
                "STENCIL_READER_STATEMENT",
                $@"Stencil {{
                    Ref [_StencilNumber]
                    Comp [_StencilCompareAction]
                }}
                "
            );

            stencilReaderGenerator.variationName = new KeyValuePair<int, string>(1, "_StencilReader");
            stencilReaderGenerator.run();
        }

        [MenuItem("AXCS/Generator/3.GenerateEmissiveFreak", priority = 23)]
        public static void generateEmissiveFreakVariation()
        {
            // EmissiveFreakジェネレーター
            var emissiveFreakGenerator = new AxGenerator(){
                includeShaderNames = new string[]{"Opaque", "Cutout", "Stencil", "Fade"},
                excludeShaderNames = new string[]{"Outline", "EmissiveFreak"},
                namePrefix = "",
                fileNamePrefix = "EmissiveFreak_",
            };
            emissiveFreakGenerator.replaceCodes = new Dictionary<string, string>();
            emissiveFreakGenerator.replaceCodes.Add(
                "EMISSIVE_FREAK_PROPERTIES",
                $@"// EmissiveFreak
                _EmissiveFreak1Tex (""[EmissiveFreak] Texture"", 2D ) = ""white"" {{}}
                [HDR]_EmissiveFreak1Color (""[EmissiveFreak] Color"", Color ) = (0,0,0,1)
                _EmissiveFreak1Mask (""[EmissiveFreak] Mask"", 2D ) = ""white"" {{}}
                _EmissiveFreak1U (""[EmissiveFreak] U Scroll"", Float ) = 0
                _EmissiveFreak1V (""[EmissiveFreak] V Scroll"", Float ) = 0
                _EmissiveFreak1Depth (""[EmissiveFreak] Depth"", Range(-1, 1) ) = 0
                _EmissiveFreak1DepthMask (""[EmissiveFreak] Depth Mask"", 2D ) = ""white"" {{}}
                [AXCSToggle]_EmissiveFreak1DepthMaskInvert (""[EmissiveFreak] Invert Depth Mask"", Float ) = 0
                _EmissiveFreak1Breathing (""[EmissiveFreak] Breathing Speed"", Float ) = 0
                _EmissiveFreak1BreathingMix (""[EmissiveFreak] Breathing Factor"", Range(0, 1) ) = 0
                _EmissiveFreak1BlinkOut (""[EmissiveFreak] Blink Out Speed"", Float ) = 0
                _EmissiveFreak1BlinkOutMix (""[EmissiveFreak] Blink Out Factor"", Range(0, 1) ) = 0
                _EmissiveFreak1BlinkIn (""[EmissiveFreak] Blink In"", Float ) = 0
                _EmissiveFreak1BlinkInMix (""[EmissiveFreak] Blink In Factor"", Range(0, 1) ) = 0
                _EmissiveFreak1HueShift (""[EmissiveFreak] Hue Shift Speed"", Float ) = 0
                _EmissiveFreak2Tex (""[EmissiveFreak2] Texture"", 2D ) = ""white"" {{}}
                [HDR]_EmissiveFreak2Color (""[EmissiveFreak2] Color"", Color ) = (0,0,0,1)
                _EmissiveFreak2Mask (""[EmissiveFreak2] Mask"", 2D ) = ""white"" {{}}
                _EmissiveFreak2U (""[EmissiveFreak2] U Scroll"", Float ) = 0
                _EmissiveFreak2V (""[EmissiveFreak2] V Scroll"", Float ) = 0
                _EmissiveFreak2Depth (""[EmissiveFreak2] Depth"", Range(-1, 1) ) = 0
                _EmissiveFreak2DepthMask (""[EmissiveFreak2] Depth Mask"", 2D ) = ""white"" {{}}
                [AXCSToggle]_EmissiveFreak2DepthMaskInvert (""[EmissiveFreak2] Invert Depth Mask"", Float ) = 0
                _EmissiveFreak2Breathing (""[EmissiveFreak2] Breathing Speed"", Float ) = 0
                _EmissiveFreak2BreathingMix (""[EmissiveFreak2] Breathing Factor"", Range(0, 1) ) = 0
                _EmissiveFreak2BlinkOut (""[EmissiveFreak2] Blink Out Speed"", Float ) = 0
                _EmissiveFreak2BlinkOutMix (""[EmissiveFreak2] Blink Out Factor"", Range(0, 1) ) = 0
                _EmissiveFreak2BlinkIn (""[EmissiveFreak2] Blink In"", Float ) = 0
                _EmissiveFreak2BlinkInMix (""[EmissiveFreak2] Blink In Factor"", Range(0, 1) ) = 0
                _EmissiveFreak2HueShift (""[EmissiveFreak2] Hue Shift Speed"", Float ) = 0"
            );
            emissiveFreakGenerator.replaceCodes.Add(
                "EMISSIVE_FREAK_DEFINE",
                $@"#define AXCS_EMISSIVE_FREAK"
            );

            emissiveFreakGenerator.variationName = new KeyValuePair<int, string>(1, "_EmissiveFreak");
            emissiveFreakGenerator.run();
        }

        [MenuItem("AXCS/Generator/4.GenerateOutline", priority = 24)]
        public static void generateOutlineVariation()
        {
            // Outlineジェネレーター
            var outlineGenerator = new AxGenerator(){
                includeShaderNames = new string[]{"Opaque", "Cutout", "Stencil", "EmissiveFreak"},
                excludeShaderNames = new string[]{"Fade", "Outline"},
                namePrefix = "",
                fileNamePrefix = "Outline_",
            };
            outlineGenerator.replaceCodes = new Dictionary<string, string>();
            outlineGenerator.replaceCodes.Add(
                "OUTLINE_USE_GEOM",
                "#pragma geometry geom"
            );
            outlineGenerator.replaceCodes.Add(
                "OUTLINE_SHADER_MODEL",
                "#pragma target 4.0"
            );

            outlineGenerator.replaceCodes.Add(
                "OUTLINE_PROPERTIES",
                $@"// Outline
                _OutlineWidth (""[Outline] Width"", Range(0, 20)) = 0.1
                _OutlineMask (""[Outline] Outline Mask"", 2D) = ""white"" {{}}
                _OutlineCutoffRange (""[Outline] Cutoff Range"", Range(0, 1)) = 0.5
                _OutlineColor (""[Outline] Color"", Color) = (0,0,0,1)
                _OutlineTexture (""[Outline] Texture"", 2D) = ""white"" {{}}
                _OutlineTextureColorRate (""[Outline] Texture Color Rate"", Range(0, 1)) = 0.05
                _OutlineWidthMask (""[Outline] Outline Width Mask"", 2D) = ""white"" {{}}
                [AXCSToggle]_OutlineUseColorShift(""[Outline] Use Outline Color Shift"", Int) = 0
                [PowerSlider(2.0)]_OutlineHueShiftFromBase(""[Outline] Hue Shift From Base"", Range(-0.5, 0.5)) = 0
                _OutlineSaturationFromBase(""[Outline] Saturation From Base"", Range(0, 2)) = 1
                _OutlineValueFromBase(""[Outline] Value From Base"", Range(0, 2)) = 1"
            );

            outlineGenerator.replaceCodes.Add(
                "OUTLINE_PROPERTIES_OPAQUE",
                $@"// Outline
                _OutlineWidth (""[Outline] Width"", Range(0, 20)) = 0.1
                _OutlineColor (""[Outline] Color"", Color) = (0,0,0,1)
                _OutlineTexture (""[Outline] Texture"", 2D) = ""white"" {{}}
                _OutlineTextureColorRate (""[Outline] Texture Color Rate"", Range(0, 1)) = 0.05
                _OutlineWidthMask (""[Outline] Outline Width Mask"", 2D) = ""white"" {{}}
                [AXCSToggle]_OutlineUseColorShift(""[Outline] Use Outline Color Shift"", Int) = 0
                [PowerSlider(2.0)]_OutlineHueShiftFromBase(""[Outline] Hue Shift From Base"", Range(-0.5, 0.5)) = 0
                _OutlineSaturationFromBase(""[Outline] Saturation From Base"", Range(0, 2)) = 1
                _OutlineValueFromBase(""[Outline] Value From Base"", Range(0, 2)) = 1"
            );
            outlineGenerator.replaceCodes.Add(
                "OUTLINE_DEFINE",
                $@"#define AXCS_OUTLINE"
            );

            outlineGenerator.variationName = new KeyValuePair<int, string>(1, "_Outline");
            outlineGenerator.run();
        }

		public static List<string> LoadTextFileFromDisk( string pathName )
		{
			var result = new List<string>();
            if ( !string.IsNullOrEmpty( pathName ) && File.Exists( pathName ) )
            {
                StreamReader fileReader = null;
                try
                {
                    fileReader = new StreamReader( pathName );
                    while (!fileReader.EndOfStream){
                        result.Add(fileReader.ReadLine());
                    }
                }
                catch ( Exception e )
                {
                    Debug.LogException( e );
                }
                finally
                {
                    if( fileReader != null)
                        fileReader.Close();
                }
            }
			return result;
		}

		public static void SaveTextfileToDisk( List<string> shaderBody, string pathName)
		{
			// Write to disk
			StreamWriter fileWriter = new StreamWriter( pathName );
			try
			{
                foreach(var line in shaderBody) {
				    fileWriter.WriteLine( line );
                }
			}
			catch ( Exception e )
			{
				Debug.LogException( e );
			}
			finally
			{
				fileWriter.Close();
			}
		}
    }
}