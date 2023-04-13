using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class TextHyperLink : Text, IPointerClickHandler
{
    readonly List<Entry> entries = new List<Entry>();

    struct Entry
    {
        public readonly string RegexPattern;
        public readonly Color Color;
        public readonly Action<string> Callback;

        public Entry(string regexPattern, Color color, Action<string> callback)
        {
            RegexPattern = regexPattern;
            Color = color;
            Callback = callback;
        }
    }

    Canvas rootCanvas;
    Canvas RootCanvas => rootCanvas ?? (rootCanvas = GetComponentInParent<Canvas>());

    /// <summary>
    /// 正規表現にマッチした部分文字列にクリックイベントリスナを登録します
    /// </summary>
    /// <param name="regexPattern">正規表現</param>
    /// <param name="onClick">クリック時のコールバック</param>
    public void OnClick(string regexPattern, Action<string> onClick)
    {
        OnClick(regexPattern, color, onClick);
    }

    /// <summary>
    /// 正規表現にマッチした部分文字列に色とクリックイベントリスナを登録します
    /// </summary>
    /// <param name="regexPattern">正規表現</param>
    /// <param name="color">テキストカラー</param>
    /// <param name="onClick">クリック時のコールバック</param>
    public void OnClick(string regexPattern, Color color, Action<string> onClick)
    {
        if (string.IsNullOrEmpty(regexPattern) || onClick == null)
        {
            return;
        }

        entries.Add(new Entry(regexPattern, color, onClick));
    }

    Vector3 CalculateLocalPosition(Vector3 position, Camera pressEventCamera)
    {
        if (!RootCanvas)
        {
            return Vector3.zero;
        }

        if (RootCanvas.renderMode == RenderMode.ScreenSpaceOverlay)
        {
            return transform.InverseTransformPoint(position);
        }

        RectTransformUtility.ScreenPointToLocalPointInRectangle(
            rectTransform,
            position,
            pressEventCamera,
            out var localPosition
        );

        return localPosition;
    }

    void IPointerClickHandler.OnPointerClick(PointerEventData eventData)
    {
        //    var localPosition = CalculateLocalPosition(eventData.position, eventData.pressEventCamera);

        //    for (var s = 0; s < m_TempVerts.Length; s++)
        //    {
        //        for (var b = 0; b < spans[s].BoundingBoxes.Count; b++)
        //        {
        //            if (spans[s].BoundingBoxes[b].Contains(localPosition))
        //            {
        //                spans[s].Callback(text.Substring(spans[s].StartIndex, spans[s].Length));
        //                break;
        //            }
        //        }
        //    }
    }

    readonly UIVertex[] m_TempVerts = new UIVertex[4];
    protected override void OnPopulateMesh(VertexHelper toFill)
    {
        if (font == null)
            return;

        // We don't care if we the font Texture changes while we are doing our Update.
        // The end result of cachedTextGenerator will be valid for this instance.
        // Otherwise we can get issues like Case 619238.
        m_DisableFontTextureRebuiltCallback = true;

        Vector2 extents = rectTransform.rect.size;

        var settings = GetGenerationSettings(extents);
        cachedTextGenerator.PopulateWithErrors(text, settings, gameObject);

        // Apply the offset to the vertices
        IList<UIVertex> verts = cachedTextGenerator.verts;
        float unitsPerPixel = 1 / pixelsPerUnit;
        int vertCount = verts.Count;

        // We have no verts to process just return (case 1037923)
        if (vertCount <= 0)
        {
            toFill.Clear();
            return;
        }

        Vector2 roundingOffset = new Vector2(verts[0].position.x, verts[0].position.y) * unitsPerPixel;
        roundingOffset = PixelAdjustPoint(roundingOffset) - roundingOffset;
        toFill.Clear();
        if (roundingOffset != Vector2.zero)
        {
            for (int i = 0; i < vertCount; ++i)
            {
                int tempVertsIndex = i & 3;
                m_TempVerts[tempVertsIndex] = verts[i];
                m_TempVerts[tempVertsIndex].position *= unitsPerPixel;
                m_TempVerts[tempVertsIndex].position.x += roundingOffset.x;
                m_TempVerts[tempVertsIndex].position.y += roundingOffset.y;
                if (tempVertsIndex == 3)
                    toFill.AddUIVertexQuad(m_TempVerts);
            }
        }
        else
        {
            for (int i = 0; i < vertCount; ++i)
            {
                int tempVertsIndex = i & 3;
                m_TempVerts[tempVertsIndex] = verts[i];
                m_TempVerts[tempVertsIndex].position *= unitsPerPixel;
                if (tempVertsIndex == 3)
                    toFill.AddUIVertexQuad(m_TempVerts);
            }
        }

        m_DisableFontTextureRebuiltCallback = false;
    }


    //public override void RemoveListeners()
    //{
    //    base.RemoveListeners();
    //    entries.Clear();
    //}

    ///// <summary>
    ///// イベントリスナを追加します
    ///// テキストの変更などでイベントの再登録が必要なときにも呼び出されます
    ///// <see cref="HypertextBase.OnClick"/> を使ってクリックイベントリスナを登録してください
    ///// </summary>
    //protected override void AddListeners()
    //{
    //    foreach (var entry in entries)
    //    {
    //        foreach (Match match in Regex.Matches(text, entry.RegexPattern))
    //        {
    //            OnClick(match.Index, match.Value.Length, entry.Color, entry.Callback);
    //        }
    //    }
    //}
}
