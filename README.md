# VMCAvatarMaterialChange

VMCAvatarMaterialChangeは[VMCAvatar](https://github.com/nagatsuki/VMCAvatar-BS)だけでは使用できなかったBloomをONにするためのModです。    
~~当MODを使用するとTransparent(半透明)のマテリアルは全てCutout(切抜)に変更されるため、半透明は使用できません。  
半透明を再現したい場合は、等MODは使用しないorオプションでOFFにして、SystemのBloomをOFFにしてご使用ください。~~<br>
0.4.0以降で完全に透過に対応しました。

[ダウンロード先](https://github.com/Reiya1013/VMCAvatarMaterialChange/releases)  

## インストール

1.VMCAvatarを導入  
2.VMCAvatarMaterialChange.dllをBeat Saberインストール先のPluginsフォルダに入れる     

## 機能

BloomONだと光ってしまうMToonシェーダーを無理やり別なシェーダーに置き換えます。   
ですので、私のアバターなんで変えてるねん！って方はご使用をお控えください。   
現在の対応シェーダーは「MToon、Standard」 

## MToonシェーダーとの違い

~~0.2.0以降はMToon改シェーダーに変更したため、表現方法はMToonとほぼ変わりません。   
ただ、Transparent系はαチャンネルを使わないと表現できないため、以下の変換を行っております。   
MToon-Opaque → MToon-Opaque   
MToon-Cutout → MToon-Cutout   
MToon-Transparent → MToon-Cutout   
MToon-TransparentWithZWrite → MToon-Opaque~~
<br>
0.4.0 以降は透過対応改造MToonです。  
Standard → 専用シェーダー   

## MODパラメータ
VMCAvatarMaterialChangeの使用のON/OFF   
Material Change：ON/OFF  
影色を強制的にWhiteにする。(VRM再出力したくない人や、影がピンクで嫌な人向け   
Shade Color Change：Default/White   
Graphic Mode：Default(MToon改) / Lith(Origina)   

## AvataCopy機能 
左メニューにAvatarCopy機能を用意しました。  
破綻の確認塔のために、ポーズを撮ってボタンを押すだけで、そのポーズでアバターをコピーして表示します。  
AvatarCopy To WordPos ： ワールド原点(足跡の上)にアバターをコピーします。  
AvatarCopy To WordPos(Timer 5Sec) ： 5秒後にワールド原点(足跡の上)にアバターをコピーします。  
AvatarCopy To AvatarPos ： 現在地点にアバターをコピーします。  
AvatarCopy To AvatarPos(Timer 5Sec) ： 5秒後に現在地点にアバターをコピーします。 


## バグ報告 

下記にお願いいたします。  
Twitter:[Reiya](https://twitter.com/Reiya__)  


## ライセンス

MIT license
