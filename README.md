# VMCAvatarMaterialChange

VMCAvatarMaterialChangeは[VMCAvatar](https://github.com/nagatsuki/VMCAvatar-BS)だけでは使用できなかったBloomをONにするためのModです。  

[ダウンロード先](https://github.com/Reiya1013/VMCAvatarMaterialChange/releases)  

## インストール

1.VMCAvatarを導入  
2.VMCAvatarMaterialChange.dllをBeat Saberインストール先のPluginsフォルダに入れる     
※設定は今の所ありません。   


## 機能

BloomONだと光ってしまうMToonシェーダーを無理やり別なシェーダーに置き換えます。   
ですので、私のアバターなんで変えてるねん！って方はご使用をお控えください。   
現在の対応シェーダーは「MToon、Standard」 

## MToonシェーダーとの違い

2.0以降はMToon改シェーダーに変更したため、表現方法はMToonとほぼ変わりません。   
ただ、Transparent系はαチャンネルを使わないと表現できないため、以下の変換を行っております。   
MToon-Opaque → MToon-Opaque   
MToon-Cutout → MToon-Cutout   
MToon-Transparent → MToon-Cutout   
MToon-TransparentWithZWrite → MToon-Opaque   
Standard → 専用シェーダー   

## MODパラメータ
VMCAvatarMaterialChangeの使用のON/OFF   
Material Change：ON/OFF  
影色を強制的にWhiteにする。(VRM再出力したくない人や、影がピンクで嫌な人向け   
Shade Color Change：Default/White   
Graphic Mode：Default(MToon改) / Lith(Origina)   

## バグ報告 

下記にお願いいたします。  
Twitter:[Reiya](https://twitter.com/Reiya__)  


## ライセンス

MIT license
