#if UNITY_EDITOR
using UnityEditor;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

#if !UNITY_2018_1_OR_NEWER
    using System.Reflection;
#endif

namespace lilToon
{
    //------------------------------------------------------------------------------------------------------------------------------
    // PropertyDrawer
    public class lilHDRDrawer : MaterialPropertyDrawer
    {
        // Gamma HDR
        // [lilHDR]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            float xMax = position.xMax;
            position.width = Mathf.Min(position.width, EditorGUIUtility.labelWidth + EditorGUIUtility.fieldWidth);
            Color value = prop.colorValue;
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            #if UNITY_2018_1_OR_NEWER
                value = EditorGUI.ColorField(position, new GUIContent(label), value, true, true, true);
            #else
                value = EditorGUI.ColorField(position, new GUIContent(label), value, true, true, true, null);
            #endif
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.colorValue = value;
            }

            #if UNITY_2019_1_OR_NEWER
                // Hex
                EditorGUI.BeginChangeCheck();
                EditorGUI.showMixedValue = prop.hasMixedValue;
                float intensity = value.maxColorComponent > 1.0f ? value.maxColorComponent : 1.0f;
                Color value2 = new Color(value.r / intensity, value.g / intensity, value.b / intensity, 1.0f);
                string hex = ColorUtility.ToHtmlStringRGB(value2);
                position.x += position.width + 4.0f;
                position.width = Mathf.Max(50.0f, xMax - position.x);
                hex = "#" + EditorGUI.TextField(position, GUIContent.none, hex);
                if(EditorGUI.EndChangeCheck())
                {
                    if(!ColorUtility.TryParseHtmlString(hex, out value2)) return;
                    value.r = value2.r * intensity;
                    value.g = value2.g * intensity;
                    value.b = value2.b * intensity;
                    prop.colorValue = value;
                }
                EditorGUI.showMixedValue = false;
            #endif
        }
    }

    public class lilToggleDrawer : MaterialPropertyDrawer
    {
        // Toggle without setting shader keyword
        // [lilToggle]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            bool value = (prop.floatValue != 0.0f);
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            value = EditorGUI.Toggle(position, label, value);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value ? 1.0f : 0.0f;
            }
        }
    }

    public class lilToggleLeftDrawer : MaterialPropertyDrawer
    {
        // Toggle without setting shader keyword
        // [lilToggleLeft]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            position.width -= 24;
            bool value = (prop.floatValue != 0.0f);
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            if(EditorGUIUtility.isProSkin)
            {
                value = EditorGUI.ToggleLeft(position, label, value);
            }
            else
            {
                GUIStyle customToggleFont = new GUIStyle();
                customToggleFont.normal.textColor = Color.white;
                customToggleFont.contentOffset = new Vector2(2f,0f);
                value = EditorGUI.ToggleLeft(position, label, value, customToggleFont);
            }
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value ? 1.0f : 0.0f;
            }
        }
    }

    public class lilAngleDrawer : MaterialPropertyDrawer
    {
        // [lilAngle]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            // Radian -> Degree
            float angle180 = prop.floatValue / Mathf.PI * 180.0f;

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            angle180 = EditorGUI.Slider(position, label, angle180, -180.0f, 180.0f);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                // Degree -> Radian
                prop.floatValue = angle180 * Mathf.PI / 180.0f;
            }
        }
    }

    public class lilBlinkDrawer : MaterialPropertyDrawer
    {
        // [lilBlink]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float strength = prop.vectorValue.x;
            float type = prop.vectorValue.y;
            float speed = prop.vectorValue.z / Mathf.PI;
            float offset = prop.vectorValue.w / Mathf.PI;

            EditorGUI.BeginChangeCheck();
            strength = EditorGUI.Slider(position, labels[0], strength, 0.0f, 1.0f);
            if(strength != 0.0f)
            {
                type    = EditorGUI.Toggle(EditorGUILayout.GetControlRect(), labels[1], type > 0.5f) ? 1.0f : 0.0f;
                speed   = EditorGUI.FloatField(EditorGUILayout.GetControlRect(), labels[2], speed);
                offset  = EditorGUI.FloatField(EditorGUILayout.GetControlRect(), labels[3], offset);
            }

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(strength, type, speed * Mathf.PI, offset * Mathf.PI);
            }
        }
    }

    public class lilVec3Drawer : MaterialPropertyDrawer
    {
        // Draw vector4 as vector3
        // [lilVec3]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            Vector3 vec = new Vector3(prop.vectorValue.x, prop.vectorValue.y, prop.vectorValue.z);
            float unused = prop.vectorValue.w;

            EditorGUIUtility.wideMode = true;

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            vec = EditorGUI.Vector3Field(position, label, vec);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(vec.x, vec.y, vec.z, unused);
            }
        }
    }

    public class lilVec3FloatDrawer : MaterialPropertyDrawer
    {
        // Draw vector4 as vector3 and float
        // [lilVec3Float]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            Vector3 vec = new Vector3(prop.vectorValue.x, prop.vectorValue.y, prop.vectorValue.z);
            float length = prop.vectorValue.w;

            EditorGUIUtility.wideMode = true;

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            vec = EditorGUI.Vector3Field(position, labels[0], vec);
            length = EditorGUI.FloatField(EditorGUILayout.GetControlRect(), labels[1], length);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(vec.x, vec.y, vec.z, length);
            }
        }
    }

    public class lilHSVGDrawer : MaterialPropertyDrawer
    {
        // Hue Saturation Value Gamma
        // [lilHSVG]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float hue = prop.vectorValue.x;
            float sat = prop.vectorValue.y;
            float val = prop.vectorValue.z;
            float gamma = prop.vectorValue.w;

            EditorGUI.BeginChangeCheck();
            hue = EditorGUI.Slider(position, labels[0], hue, -0.5f, 0.5f);
            sat = EditorGUI.Slider(EditorGUILayout.GetControlRect(), labels[1], sat, 0.0f, 2.0f);
            val = EditorGUI.Slider(EditorGUILayout.GetControlRect(), labels[2], val, 0.0f, 2.0f);
            gamma = EditorGUI.Slider(EditorGUILayout.GetControlRect(), labels[3], gamma, 0.01f, 2.0f);

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(hue, sat, val, gamma);
            }
        }
    }

    public class lilUVAnim : MaterialPropertyDrawer
    {
        // Angle Scroll Rotate
        // [lilUVAnim]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            Vector2 scroll = new Vector2(prop.vectorValue.x, prop.vectorValue.y);
            float angle = prop.vectorValue.z / Mathf.PI * 180.0f;
            float rotate = prop.vectorValue.w / Mathf.PI * 0.5f;

            EditorGUI.BeginChangeCheck();

            if(labels.Length == 1)
            {
                float labelWidth = EditorGUIUtility.labelWidth;
                Rect labelRect = new Rect(position.x, position.y, labelWidth, position.height);
                EditorGUI.PrefixLabel(labelRect, new GUIContent(labels[0]));
                int indentBuf = EditorGUI.indentLevel;
                EditorGUI.indentLevel = 0;
                Rect vecRect = new Rect(position.x + labelWidth, position.y, position.width - labelWidth, position.height);
                scroll = EditorGUI.Vector2Field(vecRect, GUIContent.none, scroll);
                EditorGUI.indentLevel = indentBuf;
            }
            else
            {
                // Angle
                angle = EditorGUI.Slider(position, labels[0], angle, -180.0f, 180.0f);

                lilToonInspector.DrawLine();

                // Heading (UV Animation)
                EditorGUILayout.LabelField(labels[1], EditorStyles.boldLabel);

                Rect positionVec2 = EditorGUILayout.GetControlRect();

                // Scroll label
                float labelWidth = EditorGUIUtility.labelWidth;
                Rect labelRect = new Rect(positionVec2.x, positionVec2.y, labelWidth, positionVec2.height);
                EditorGUI.PrefixLabel(labelRect, new GUIContent(labels[2]));

                // Copy & Reset indent
                int indentBuf = EditorGUI.indentLevel;
                EditorGUI.indentLevel = 0;

                // Scroll
                Rect vecRect = new Rect(positionVec2.x + labelWidth, positionVec2.y, positionVec2.width - labelWidth, positionVec2.height);
                scroll = EditorGUI.Vector2Field(vecRect, GUIContent.none, scroll);

                // Revert indent
                EditorGUI.indentLevel = indentBuf;

                // Rotate
                rotate = EditorGUI.FloatField(EditorGUILayout.GetControlRect(), labels[3], rotate);
            }

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(scroll.x, scroll.y, angle * Mathf.PI / 180.0f, rotate * Mathf.PI * 2.0f);
            }
        }
    }

    public class lilDecalAnim : MaterialPropertyDrawer
    {
        // [lilDecalAnim]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            int loopX = (int)prop.vectorValue.x;
            int loopY = (int)prop.vectorValue.y;
            int frames = (int)prop.vectorValue.z;
            float speed = prop.vectorValue.w;

            // Heading (UV Animation)
            EditorGUI.LabelField(position, labels[0], EditorStyles.boldLabel);

            EditorGUI.indentLevel++;
            Rect position1 = EditorGUILayout.GetControlRect();
            Rect position2 = EditorGUILayout.GetControlRect();
            Rect position3 = EditorGUILayout.GetControlRect();
            Rect position4 = EditorGUILayout.GetControlRect();

            EditorGUI.BeginChangeCheck();
            loopX = EditorGUI.IntField(position1, labels[1], loopX);
            loopY = EditorGUI.IntField(position2, labels[2], loopY);
            frames = EditorGUI.IntField(position3, labels[3], frames);
            speed = EditorGUI.FloatField(position4, labels[4], speed);
            EditorGUI.indentLevel--;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4((float)loopX, (float)loopY, (float)frames, speed);
            }
        }
    }

    public class lilDecalSub : MaterialPropertyDrawer
    {
        // [lilDecalSub]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float scaleX = prop.vectorValue.x;
            float scaleY = prop.vectorValue.y;
            float border = prop.vectorValue.z;
            float unused = prop.vectorValue.w;

            EditorGUI.indentLevel++;
            Rect position1 = EditorGUILayout.GetControlRect();
            Rect position2 = EditorGUILayout.GetControlRect();

            EditorGUI.BeginChangeCheck();
            scaleX = EditorGUI.Slider(position, labels[0], scaleX, 0.0f, 1.0f);
            scaleY = EditorGUI.Slider(position1, labels[1], scaleY, 0.0f, 1.0f);
            border = EditorGUI.Slider(position2, labels[2], border, 0.0f, 1.0f);
            EditorGUI.indentLevel--;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(scaleX, scaleY, border, unused);
            }
        }
    }

    public class lilEnum : MaterialPropertyDrawer
    {
        // [lilEnum]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            string[] enums = new string[labels.Length-1];
            Array.Copy(labels, 1, enums, 0, labels.Length-1);

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            float value = (float)EditorGUI.Popup(position, labels[0], (int)prop.floatValue, enums);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value;
            }
        }
    }

    public class lilEnumLabel : MaterialPropertyDrawer
    {
        // [lilEnum]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            string[] enums = new string[labels.Length-1];
            Array.Copy(labels, 1, enums, 0, labels.Length-1);

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            float value = prop.floatValue;
            if(EditorGUIUtility.isProSkin)
            {
                value = (float)EditorGUI.Popup(position, labels[0], (int)prop.floatValue, enums);
            }
            else
            {
                GUIStyle customToggleFont = new GUIStyle();
                customToggleFont.normal.textColor = Color.white;
                customToggleFont.contentOffset = new Vector2(2f,0f);
                float labelWidth = EditorGUIUtility.labelWidth;
                Rect labelRect = new Rect(position.x, position.y, labelWidth, position.height);
                EditorGUI.PrefixLabel(labelRect, new GUIContent(labels[0]), customToggleFont);
                value = (float)EditorGUI.Popup(position, " ", (int)prop.floatValue, enums);
            }
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value;
            }
        }
    }

    public class lilColorMask : MaterialPropertyDrawer
    {
        // ColorMask
        // [lilColorMask]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] masks = new string[]{"None","A","B","BA","G","GA","GB","GBA","R","RA","RB","RBA","RG","RGA","RGB","RGBA"};
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            float cullFloat = (float)EditorGUI.Popup(position, label, (int)prop.floatValue, masks);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.floatValue = cullFloat;
            }
        }
    }

    public class lil3Param : MaterialPropertyDrawer
    {
        // [lil3Param]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float param1 = prop.vectorValue.x;
            float param2 = prop.vectorValue.y;
            float param3 = prop.vectorValue.z;
            float unused = prop.vectorValue.w;

            EditorGUI.indentLevel++;
            Rect position1 = EditorGUILayout.GetControlRect();
            Rect position2 = EditorGUILayout.GetControlRect();

            EditorGUI.BeginChangeCheck();
            param1 = EditorGUI.FloatField(position, labels[0], param1);
            param2 = EditorGUI.FloatField(position1, labels[1], param2);
            param3 = EditorGUI.FloatField(position2, labels[2], param3);
            EditorGUI.indentLevel--;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(param1, param2, param3, unused);
            }
        }
    }

    public class lilALUVMode : MaterialPropertyDrawer
    {
        // [lilALUVMode]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float value = prop.floatValue;

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            if(labels.Length == 5) value = (float)EditorGUI.Popup(position, labels[0], (int)prop.floatValue, new String[]{labels[1],labels[2],labels[3],labels[4]});
            if(labels.Length == 4) value = (float)EditorGUI.Popup(position, labels[0], (int)prop.floatValue, new String[]{labels[1],labels[2],labels[3]});
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value;
            }
        }
    }

    public class lilALUVParams : MaterialPropertyDrawer
    {
        // [lilALUVParams]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float scale = prop.vectorValue.x;
            float offset = prop.vectorValue.y;
            float angle180 = prop.vectorValue.z / Mathf.PI * 180.0f;
            float band = (prop.vectorValue.w - 0.125f) * 4.0f;

            EditorGUI.BeginChangeCheck();
            if(labels.Length == 6)
            {
                Rect position1 = EditorGUILayout.GetControlRect();
                offset = EditorGUI.FloatField(position, labels[0], offset);
                band = (float)EditorGUI.Popup(position1, labels[1], (int)band, new String[]{labels[2],labels[3],labels[4],labels[5]});
            }
            if(labels.Length == 7)
            {
                Rect position1 = EditorGUILayout.GetControlRect();
                Rect position2 = EditorGUILayout.GetControlRect();
                scale = EditorGUI.FloatField(position, labels[0], scale);
                offset = EditorGUI.FloatField(position1, labels[1], offset);
                band = (float)EditorGUI.Popup(position2, labels[2], (int)band, new String[]{labels[3],labels[4],labels[5],labels[6]});
            }
            if(labels.Length == 8)
            {
                Rect position1 = EditorGUILayout.GetControlRect();
                Rect position2 = EditorGUILayout.GetControlRect();
                Rect position3 = EditorGUILayout.GetControlRect();
                scale = EditorGUI.FloatField(position, labels[0], scale);
                offset = EditorGUI.FloatField(position1, labels[1], offset);
                angle180 = EditorGUI.Slider(position2, labels[2], angle180, -180.0f, 180.0f);
                band = (float)EditorGUI.Popup(position3, labels[3], (int)band, new String[]{labels[4],labels[5],labels[6],labels[7]});
            }

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(scale, offset, angle180 * Mathf.PI / 180.0f, band / 4.0f + 0.125f);
            }
        }
    }

    public class lilALLocal : MaterialPropertyDrawer
    {
        // [lilALLocal]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float BPM = prop.vectorValue.x;
            float Notes = prop.vectorValue.y;
            float Offset = prop.vectorValue.z;
            float unused = prop.vectorValue.w;

            EditorGUI.indentLevel++;
            Rect position1 = EditorGUILayout.GetControlRect();
            Rect position2 = EditorGUILayout.GetControlRect();

            EditorGUI.BeginChangeCheck();
            BPM = EditorGUI.FloatField(position, labels[0], BPM);
            Notes = EditorGUI.FloatField(position1, labels[1], Notes);
            Offset = EditorGUI.FloatField(position2, labels[2], Offset);
            EditorGUI.indentLevel--;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(BPM, Notes, Offset, unused);
            }
        }
    }

    public class lilDissolve : MaterialPropertyDrawer
    {
        // [lilDissolve]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float type = prop.vectorValue.x;
            float shape = prop.vectorValue.y;
            float border = prop.vectorValue.z;
            float blur = prop.vectorValue.w;

            EditorGUI.BeginChangeCheck();
            if(labels.Length == 5)
            {
                if(EditorGUIUtility.isProSkin)
                {
                    type = (float)EditorGUI.Popup(position, labels[0], (int)type, new String[]{labels[1],labels[2],labels[3],labels[4]});
                }
                else
                {
                    GUIStyle customToggleFont = new GUIStyle();
                    customToggleFont.normal.textColor = Color.white;
                    customToggleFont.contentOffset = new Vector2(2f,0f);
                    float labelWidth = EditorGUIUtility.labelWidth;
                    Rect labelRect = new Rect(position.x, position.y, labelWidth, position.height);
                    EditorGUI.PrefixLabel(labelRect, new GUIContent(labels[0]), customToggleFont);
                    type = (float)EditorGUI.Popup(position, " ", (int)type, new String[]{labels[1],labels[2],labels[3],labels[4]});
                }
            }
            if(labels.Length == 6)
            {
                if(type == 1.0f)
                {
                    Rect position1 = EditorGUILayout.GetControlRect();
                    border = EditorGUI.Slider(position, labels[3], border, -1.0f, 2.0f);
                    blur = EditorGUI.Slider(position1, labels[4], blur, 0.0f, 1.0f);
                }
                if(type == 2.0f)
                {
                    Rect position1 = EditorGUILayout.GetControlRect();
                    Rect position2 = EditorGUILayout.GetControlRect();
                    shape = (float)EditorGUI.Popup(position, labels[0], (int)shape, new String[]{labels[1],labels[2]});
                    border = EditorGUI.FloatField(position1, labels[3], border);
                    blur = EditorGUI.FloatField(position2, labels[4], blur);
                }
                if(type == 3.0f)
                {
                    Rect position1 = EditorGUILayout.GetControlRect();
                    Rect position2 = EditorGUILayout.GetControlRect();
                    shape = (float)EditorGUI.Popup(position, labels[0], (int)shape, new String[]{labels[1],labels[2]});
                    border = EditorGUI.FloatField(position1, labels[3], border);
                    blur = EditorGUI.FloatField(position2, labels[4], blur);
                }
            }
            if(labels.Length == 10)
            {
                type = (float)EditorGUI.Popup(position, labels[0], (int)type, new String[]{labels[1],labels[2],labels[3],labels[4]});
                if(type == 1.0f)
                {
                    Rect position1 = EditorGUILayout.GetControlRect();
                    Rect position2 = EditorGUILayout.GetControlRect();
                    border = EditorGUI.Slider(position1, labels[8], border, -1.0f, 2.0f);
                    blur = EditorGUI.Slider(position2, labels[9], blur, 0.0f, 1.0f);
                }
                if(type == 2.0f)
                {
                    Rect position1 = EditorGUILayout.GetControlRect();
                    Rect position2 = EditorGUILayout.GetControlRect();
                    Rect position3 = EditorGUILayout.GetControlRect();
                    shape = (float)EditorGUI.Popup(position1, labels[5], (int)shape, new String[]{labels[6],labels[7]});
                    border = EditorGUI.FloatField(position2, labels[8], border);
                    blur = EditorGUI.FloatField(position3, labels[9], blur);
                }
                if(type == 3.0f)
                {
                    Rect position1 = EditorGUILayout.GetControlRect();
                    Rect position2 = EditorGUILayout.GetControlRect();
                    Rect position3 = EditorGUILayout.GetControlRect();
                    shape = (float)EditorGUI.Popup(position1, labels[5], (int)shape, new String[]{labels[6],labels[7]});
                    border = EditorGUI.FloatField(position2, labels[8], border);
                    blur = EditorGUI.FloatField(position3, labels[9], blur);
                }
            }

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(type, shape, border, blur);
            }
        }
    }

    public class lilDissolveP : MaterialPropertyDrawer
    {
        // [lilDissolveP]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');

            if(labels.Length == 2)
            {
                int type = int.Parse(labels[1]);
                if(type == 1)
                {
                    EditorGUI.BeginChangeCheck();
                    float value = EditorGUI.FloatField(position, labels[0], prop.vectorValue.x);
                    if(EditorGUI.EndChangeCheck())
                    {
                        prop.vectorValue = new Vector4(value, prop.vectorValue.y, prop.vectorValue.z, prop.vectorValue.w);
                    }
                }
                if(type == 2)
                {
                    EditorGUI.BeginChangeCheck();
                    Vector2 vec = EditorGUI.Vector2Field(position, labels[0], new Vector2(prop.vectorValue.x, prop.vectorValue.y));
                    if(EditorGUI.EndChangeCheck())
                    {
                        prop.vectorValue = new Vector4(vec.x, vec.y, prop.vectorValue.z, prop.vectorValue.w);
                    }
                }
                if(type == 3)
                {
                    EditorGUI.BeginChangeCheck();
                    Vector3 vec = EditorGUI.Vector3Field(position, labels[0], new Vector3(prop.vectorValue.x, prop.vectorValue.y, prop.vectorValue.z));
                    if(EditorGUI.EndChangeCheck())
                    {
                        prop.vectorValue = new Vector4(vec.x, vec.y, vec.z, prop.vectorValue.w);
                    }
                }
                if(type == 4)
                {
                    EditorGUI.BeginChangeCheck();
                    Vector4 vec = EditorGUI.Vector4Field(position, labels[0], prop.vectorValue);
                    if(EditorGUI.EndChangeCheck())
                    {
                        prop.vectorValue = vec;
                    }
                }
            }
            else
            {
                EditorGUI.BeginChangeCheck();
                Vector4 vec = EditorGUI.Vector4Field(position, labels[0], prop.vectorValue);
                if(EditorGUI.EndChangeCheck())
                {
                    prop.vectorValue = vec;
                }
            }
        }
    }

    public class lilOLWidth : MaterialPropertyDrawer
    {
        // [lilOLWidth]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            float value = prop.floatValue;
            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            if(value > 0.999f)
            {
                value = EditorGUI.FloatField(position, label, value);
            }
            else
            {
                value = EditorGUI.Slider(position, label, value, 0.0f, 1.0f);
            }
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.floatValue = value;
            }
        }
    }

    public class lilGlitParam1 : MaterialPropertyDrawer
    {
        // [lilGlitParam1]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            Vector2 tiling = new Vector2(prop.vectorValue.x, prop.vectorValue.y);
            float size = prop.vectorValue.z == 0.0f ? 0.0f : Mathf.Sqrt(prop.vectorValue.z);
            float contrast = prop.vectorValue.w;
            Rect position1 = EditorGUILayout.GetControlRect();
            Rect position2 = EditorGUILayout.GetControlRect();
            EditorGUIUtility.wideMode = true;

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            tiling = EditorGUI.Vector2Field(position, labels[0], tiling);
            size = EditorGUI.Slider(position1, labels[1], size, 0.0f, 2.0f);
            contrast = EditorGUI.FloatField(position2, labels[2], contrast);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(tiling.x, tiling.y, size * size, contrast);
            }
        }
    }

    public class lilGlitParam2 : MaterialPropertyDrawer
    {
        // [lilGlitParam2]
        public override void OnGUI(Rect position, MaterialProperty prop, String label, MaterialEditor editor)
        {
            string[] labels = label.Split('|');
            float speed = prop.vectorValue.x;
            float angle = prop.vectorValue.y;
            float light = prop.vectorValue.z;
            float random = prop.vectorValue.w;
            Rect position1 = EditorGUILayout.GetControlRect();
            Rect position2 = EditorGUILayout.GetControlRect();
            Rect position3 = EditorGUILayout.GetControlRect();

            EditorGUI.BeginChangeCheck();
            EditorGUI.showMixedValue = prop.hasMixedValue;
            speed = EditorGUI.FloatField(position, labels[0], speed);
            angle = EditorGUI.FloatField(position1, labels[1], angle);
            light = EditorGUI.FloatField(position2, labels[2], light);
            random = EditorGUI.Slider(position3, labels[3], random, 0.0f, 1.0f);
            EditorGUI.showMixedValue = false;

            if(EditorGUI.EndChangeCheck())
            {
                prop.vectorValue = new Vector4(speed, angle, light, random);
            }
        }
    }
}
#endif