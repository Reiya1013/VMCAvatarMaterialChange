①Texture:メインのテクスチャです。普通に指定してください。
②BOXSize:BOXのサイズの補正です。
　BOXSizeChange:BOXサイズの補正です。0であれば一定、0より大きければポリゴンサイズによって補正されます。

ここから下は指定しなくても問題ありません。

③RimEffect:Rimの強度を指定します。
④RimColor:Rimの色を指定できます。

⑤LegasyPoly:Box化前のメッシュを表示します。数値で大きさを変えられます。

⑥NormalExtrusion:Boxを元ポリゴンの法線方向に爆発させられます。
⑦Gravity:⑥で飛ばした後に受ける重力の方向を指定できます。
⑧FloorHight:⑥で飛ばした後の床の高さを指定できます。(たいていY=-1くらいでいい感じになります。)

⑨RotationMap:Boxを回転させる場合の回転軸をテクスチャで指定できます。赤成分がX軸,緑成分がY軸,青成分がZ軸です。
⑩RotationUSpeed:⑨を時間でスクロールさせます。
⑪RotationAxis:Boxを回転させる回転軸を指定できます。
⑫RotationSpeed:回転速度を指定できます。

⑬VoxelSizeMap:Boxのサイズをテクスチャで指定できます。より白い部分のBoxが大きくなります。
⑭VoxelSizeUV:⑬を時間でスクロールさせます。
⑮VoxSizePower:大きさの変化の強さを指定できます。

⑯PolygonExtrusion:ここにマップを指定するとBoxの面を法線方向に飛ばせます。より白い部分がより遠くに飛びます。
⑰PolyUVSpeed:⑯を時間でスクロールさせます。
⑱ExtrusionPower:法線方向に飛ばす力を指定できます。

⑲ShadowMap:ここにBOXの影側の色のマップを指定できます。
⑳ShadowUVSpeed：⑲を時間でをスクロールさせます。
㉑ShadowColor:ここで影の色を指定できます。
㉒ShadowPower:影の強さを指定します。

㉓SubTexture:個々のVoxの面に貼るテクスチャを指定できます。
㉔SubTexturePower:㉓の濃度に補正をかけます。

㉕:AutoMaticTessellation:わからない人はさわらないこと！かなり重くなる設定です。
	ポリゴンの面積に応じてテッセレーションをかけてVoxを増やします。上限はtess_factor=InsideTessFactor=3ですが、[HideInInspector] _TessFactorで上限を増やせます。

* by,HhotateA
* Released under the MIT license
* Twitter :@HHOTATEA_VRC
*
* Date: 2018-09-12 開始
* Date: 2018-09-14 更新
* Date: 2018-09-15 更新
* Date: 2018-09-16 バグ修正
* Date: 2018-09-18 バグ修正
* Date: 2018-10-13 機能改善:ボックスの中心がポリゴンの中心になるように
* Date: 2019/01/29 大幅変更、ライティングが設定できるようになりました。