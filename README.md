# 雑兵感謝祭
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Channelを使って某オールスター感謝祭的なクイズ大会ができるようにしたアプリです。
頑張って問題を登録すれば、年末の忘年会などでいい感じの盛り上がりを見せるかもしれません

## URL一覧

* / トップページ、出題待機状態になる
* /questions/ 問題の管理（一覧・追加・詳細表示・編集・削除）。一覧から選択肢の確認へリンクされています。
* /questions/{question_id}/solutions/ 問題に対する選択肢の管理、正答マークを行う

## 使い方

1. 問題管理画面から問題を追加します
2. 問題に対して選択肢を追加します
3. 問題一覧、あるいは問題詳細画面の「出題」ボタンをクリックすると、トップページに選択した問題が表示されます
4. 問題詳細画面の「アンサーチェック」をクリックすると、回答を〆切り選択された回答の集計を表示します
5. 問題詳細画面の「正答オープン」をックリックすると、正解にマークした質問がトップページ上でオレンジ色にマークされます
6. 問題詳細画面の「取り消し」をクリックすると、出題中の問題がクリアされます
7. 問題一覧画面の「ランキング表示」リンクをクリックすると、トップページで名前を入力して回答されたものを集計して、名前ごとに順位を表示します

## ローカル起動方法

  0. `git clone git@github.com:yodatomato/zohyothanksgiving.git`
  1. `cd zohyothanksgiving`
  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

