using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VMCAvatarMaterialChange
{
    //
    // 概要:影の色を変更するパラメータ
    //
    public enum MaterialChange
    {
        //マテリアル変更を行いません
        OFF = 0,
        //マテリアル変更を行います
        ON = 1,
    }
    
    //
    // 概要:影の色を変更するパラメータ
    //
    public enum ShadeColor
    {
        //変更を行いません
        Default = 0,
        //白に変更します
        White = 1,
    }

    //
    // 概要:影の色を変更するパラメータ
    //
    public enum GraphicMode
    {
        //MToon改シェーダー
        Default = 0,
        //Originalシェーダー
        Lite = 1,
    }

}
