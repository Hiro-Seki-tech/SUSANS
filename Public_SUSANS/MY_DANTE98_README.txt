Dante98 Reviver v0.6

Dante98 / Dante98II の作品を現代のブラウザで開き、編集・テストプレイし、
編集後のゲーム一式をZIPとして持ち帰るための復刻・保守環境です。

1. START_MY_DANTE98.bat をダブルクリックします。
2. games.json に登録されたゲームを選択します。
3. Reviverが自動判定します。
   - Dante98   : AUTOEXEC.BAT から起動
   - Dante98II : ED.BAT から編集環境を起動
4. 編集・テストプレイ後、「編集済みZIPを書き出す」でZIPを保存します。
5. 書き出すZIP名は元のZIPと同じです。games/ の元ZIPは自動上書きされません。
6. 内容を確認後、必要なら games/ 内の同名ZIPと置き換えてください。

ゲーム追加:
  games/ にZIPを置き、games/games.json に name と file を追加します。

例（登録方法を説明するための記載例）:
[
  {"name":"Wizardry","file":"Wizardry.zip"},
  {"name":"DragonQuest","file":"DragonQuest.zip"},
  {"name":"FinalFantasy","file":"FinalFantasy.zip"}
]

1作品につき { } を1組使い、作品同士をカンマで区切ります。
name はメニュー表示名、file は実際のZIPファイル名です。
Dante98 / Dante98II の種類を書く必要はありません。

注意:
- 大切な原本は別の場所にもバックアップしてください。
- Dante98IIは一部編集画面で選択位置の反転表示が見えにくい／表示されない場合があります。
- ZIPはゲーム用ファイルがZIP直下にあるQuuBeeで正常に読み込める構造にしてください。

謝辞:
Dante98 ReviverはQuuBeeと、その基盤となるNP2kai等の先人の技術の上に成り立っています。
素晴らしい技術を公開・継承してくださった開発者の皆様に感謝します。
ライセンス・詳細な帰属表示は CREDITS.md / LICENSE 類を参照してください。
