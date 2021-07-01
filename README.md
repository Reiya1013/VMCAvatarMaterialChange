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

## MaterialChange機能 
左メニューにMaterialChange機能を用意しました。  
専用ファイル（.mc）を用意することで、ロード済みのアバターのシェーダーを変更することができます。  
専用ファイル（.mc）の作成にはUnity上で作業をする必要があります。  
以下の説明書を参照して作成してください。  
[取り扱い説明書スプレッドシート](https://docs.google.com/spreadsheets/d/1q-H6GGQlBpILypFg1mCgrPAgbT-rlfklXOje0kkD_-c/edit?usp=sharing)  
Unityに必要なファイルは最新のReleaseに［MaterialChange.unitypackage］が付属しておりますので、そちらをお使いください。  

対応シェーダー一覧  
・ビートセイバー専用Sunaoシェーダー([本家](https://booth.pm/ja/items/1723985))  
・ビートセイバー専用ユニティーちゃんトゥーンシェーダー([本家](https://unity-chan.com/download/releaseNote.php?id=UTS2_0))  
・ビートセイバー専用MToon<br>
・ビートセイバー専用arktoon<br>
・ビートセイバー専用Crystal Shader([本家](https://booth.pm/ja/items/1148311))  
・ビートセイバー専用glass Shader([本家](https://booth.pm/ja/items/1035152))  
・ビートセイバー専用Seiso Shader([本家](https://booth.pm/ja/items/2296837))  
・ビートセイバー専用GamingEffect Shader([本家](https://booth.pm/ja/items/2019300))  
・ビートセイバー専用poiyomi Shader ※専用手順あり([本家](https://github.com/poiyomi/PoiyomiToonShader))  
<br>

## バグ報告 

下記にお願いいたします。  
Twitter:[Reiya](https://twitter.com/Reiya__)  


## ライセンス

MIT license
