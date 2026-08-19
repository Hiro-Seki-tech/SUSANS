Dante98 Reviver v1.0
=====================

昔のDante98 / Dante98II作品を、現代のブラウザ上でもう一度ひらくための復刻ツールです。

【使い方】
1. START_MY_DANTE98.bat を起動します。
2. 「🎮 Dante98ゲームを読み込む」を押し、ゲームのZIPを選びます。
3. Reviverが起動方法を自動判定します。
4. 遊ぶ・編集する・ゲーム内でセーブする、を自由に行います。
5. 終わる前に「📦 現在のゲームをZIP保存」で現在の状態を持ち帰ります。
6. 次回は、そのZIPをもう一度読み込めば続きから利用できます。

【ZIPの作り方】
Dante98：
AUTOEXEC.BAT や SAVE フォルダがある階層の、すべてのファイルとフォルダを選んで1つのZIPにします。

Dante98II：
ED.BAT や GAME.BAT がある階層の、すべてのファイルとフォルダを選んで1つのZIPにします。

ZIPを開いたとき、最初に同名フォルダが1つだけ見える形ではなく、上記BATファイルなどがすぐ見える形にしてください。

【音が鳴らないとき】
ゲーム画面を一度クリックしてください。それでも鳴らない場合は、ページを再読み込みし、画面を一度クリックしてからゲームを起動し直してください。

【タイトルに戻る】
別のゲームを読み込みたいときは「↩ タイトルに戻る」を使います。
保存していない変更やゲーム内セーブは失われるため、必要なら先に「📦 現在のゲームをZIP保存」を行ってください。

【歯車ボタン】
音量・FM音源・CPU速度などPC-98エミュレータ側の設定です。通常は変更する必要はありません。

【自動判定】
Dante98：AUTOEXEC.BAT
Dante98II編集：ED.BAT
Dante98IIプレイ：ED.BATがなくGAME.BATがある場合はGAME.BAT

【大切な原本について】
Reviverは選択した元ZIPを直接上書きしません。
それでも、大切な原本は必ず別の場所にもバックアップしてください。

【謝辞・ライセンス】
**赤森貴太郎** — QuuBeeを紹介し、SUSANS復刻とDante98 Reviver誕生への重要なきっかけを与えてくれました。

Dante98 Reviverは、QuuBeeおよびその基盤となるNP2kai等、先人の技術の上に成り立っています。
詳細な帰属表示・ライセンスは CREDITS.md、LICENSE、LICENSE-MIT、licenses/ を確認してください。


【Dante98 Reviver / PLIP ライセンス】
Dante98 ReviverとしてPLIPが独自に追加したUI・起動補助・ZIP読込／保存等のコードは、MIT Licenseで公開します。
Copyright (c) 2026 PLIP

ただし、同梱されるQuuBee、NP2kai、fmgen、フォント、SoundFont等の第三者コンポーネントには、それぞれ元のライセンスが適用されます。
配布物全体を一括してPLIPのMIT Licenseへ変更するものではありません。
詳細は LICENSE、LICENSE-MIT、CREDITS.md、licenses/ を確認してください。

