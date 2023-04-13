# ラメエフェクト追加パッチ for Sunao Shader 1.4.4

![Screenshot](https://repository-images.githubusercontent.com/293795262/7dc33b80-6583-11eb-9df7-da798639e5f6)

## 注意事項

- パッチを適用する前に必ずバックアップをお取りください（gitに慣れている方はコミットを作成してください）。
- 無保証です。ご自身の責任にてご利用ください。
- Sunao Shader のオリジナル制作者様は本パッチには無関係です。オリジナル制作者様への問い合わせはしないでください。
- パッチにはオリジナルのコードが一部含まれます（MIT License により再配布が許可されています）。本パッチの改変部分も MIT License です。

## パッチの適用手順

1. 本パッチを既に適用済みでアップデートする場合は、プロジェクトから一旦 `Assets/Sunao Shader` を削除
2. [Sunao Shader 1.4.4](https://booth.pm/ja/items/1723985) をUnityプロジェクトにインポート（旧バージョンは [こちら](http://suna.ooo/agenasulab/ss/version) からダウンロードできるようです）
3. [本パッチをダウンロード](https://github.com/chigirits/LamePatchForSunaoShader/archive/master.zip) して解凍
4. Windows Explorer にてプロジェクト内の `Assets/Sunao Shader/` フォルダを開き、その直下に含まれる `Editor` および `Shader` フォルダを本リポジトリに含まれる同名のフォルダの内容でそれぞれ上書き（フォルダ内に元々存在している他のファイルは削除しないこと）

## マテリアルへの適用

マテリアル設定で以下のいずれかのシェーダを選択してください。

- `Sunao Shader/Opaque Sparkles`
- `Sunao Shader/Cutout Sparkles`
- `Sunao Shader/Transparent Sparkles`

## パラメータの調整

![パラメータ群](https://user-images.githubusercontent.com/61717977/92231170-43c40f80-eee7-11ea-96c8-fddd64957722.png)

`Opaque Sparkles` シェーダのパラメータには、通常の `Opaque` シェーダの全パラメータに加え、Emission グループに Sparkles というサブグループが追加されています。

まず全体が発光するように Emission の基本パラメータを設定してください。`Emission Color` `Emission Mask` を仮調整し、色や適用範囲を決めます。

 `Enable Sparkles` にチェックを入れるとエフェクトが有効化され、「エミッションが粒子状になる」ような効果がかかります。

以下のパラメータでエフェクトのかかり具合を調整できます。

- `Sparkle Density` : 粒子の密度
- `Sparkle Smoothness` : 粒子の滑らかさ
- `Sparkle Fineness` : 粒子の細かさ
- `Sparkle Angular Blink` : 見る角度によってきらめきが変化する速度
- `Sparkle Time Blink` : 時間経過によってきらめきが変化する速度

## Parameter Map について

たとえば目元と唇で異なるパラメータを適用したい場合、`Sparkle Parameter Map` に独自規格のマップ画像を指定することで実現できます。特に粒子の細かさはUVの密度によってばらつきやすいため、マップ画像による調整をおすすめします。

ノーマルマップと同じ感覚で、画像のRGBチャンネルにそれぞれ以下のパラメータ値を輝度として塗ってください。輝度 `255` がパラメータ値 `1.0` に当たり、実際にはこの値をスライダーの設定値に乗算した値が適用されます。

- R : `Sparkle Density`
- G : `Sparkle Smoothness`
- B : `Sparkle Fineness`

画像ファイルのインポート後は、インスペクタで `sRGB (Color Texture)` をOFFにしてください。ONのままだとガンマ補正によって適用量に偏りが生じる可能性があります。

## Tips

- ラメをのせる部分の地の色は暗めに（濃い目のチークやアイシャドウを入れる等）することをおすすめします。
- Emission パラメータの `Advanced Settings/Use Lightning` にチェックを入れない状態では暗い環境下でも強く発光しますが、本来は反射光であるラメとしては不自然に見えると思います。チェックを入れれば自然な光り方になりますが、一方で暗くて物足りない光り方になりがちです。この場合、`Emission Color` の HDR Color ウィンドウで `Intensity` を上げてください。特にポストエフェクトが効いたワールドでの効果が期待できます。
- Parameter Map画像の作成は以下の手順で行うと分かりやすいと思います。
  
  1. 部位ごとにレイヤを分けて白く塗る（マスクがフェードして消えるギリギリまで不透明度100%でしっかりと塗る）。
  2. 各レイヤごとにフォルダ分けし、それぞれ個別にレベル補正（またはトーンカーブ）エフェクトレイヤを重ねる。
  3. レベル補正（またはトーンカーブ）の出力最大値をRGBチャンネルごとに目的の値にする（調整するパラメータが百分率で表されていれば目的の値の100倍、輝度であれば255倍と考える）。
  4. 画像をエクスポートし、Unity上で効果を確認する。
  5. 満足の行く結果になるまで 3.～4. を繰り返して調整する。

## おまけ

ラメエフェクト以外に、以下の別バリエーションを使用できます。

- `Sunao Shader/Opaque Double Sided` : 裏面に別テクスチャを指定できる Opaque シェーダです。`Back Side Texture` に裏面用テクスチャを指定してください。

## ライセンス

© 2020 Chigiri Tsutsumi<br>
MIT License
