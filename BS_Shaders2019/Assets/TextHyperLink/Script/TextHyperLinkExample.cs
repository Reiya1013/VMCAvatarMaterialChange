using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.UI;

public class TextHyperLinkExample : MonoBehaviour
{
    [SerializeField]
    TextHyperLink text;

    const string RegexURL = @"https?://(?:[!-~]+\.)+[!-~]+";
    const string RegexHashtag = @"[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー]+";

    void Start()
    {
        text.OnClick(RegexURL, Color.cyan, url => Debug.Log(url));
        text.OnClick(RegexHashtag, Color.green, hashtag => Debug.Log(hashtag));
    }
}