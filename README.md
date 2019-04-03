## 2019年度新卒データベース研修

### 研修について

#### :checkered_flag: ゴール（Motto）

本研修の目指すところ

1. 昨今ブラックボックスとして捉えられがちなデータベースをカジュアルに触れるようにする
2. データを保管するだけじゃなく効率的に集計するためのツールとしての側面も知っておく
3. 機能改善する際に修正前後でどれくらい速くなったかなど数字で示すための方法を学ぶ

#### :seedling: チュートリアル

チュートリアルでは MySQL の公式サイトで紹介されている https://github.com/datacharmer/test_db の employees データベースを利用して SQL の基本的な機能について確認していきます。

- [00_HELLO](notebooks/00_HELLO.ipynb)
  - Hello, Jupyter
- [10_SELECT](notebooks/10_SELECT.ipynb)
  - SELECT 文を利用したデータの取得方法
- [20_CRUD](notebooks/20_CRUD.ipynb)
  - レコードの追加・更新・削除など基本的な操作の説明
- [30_AGGREGATION](notebooks/30_AGGREGATION.ipynb)
  - SQL クエリを使ったデータの集計方法
- [40_MORE_SELECT](notebooks/40_MORE_SELECT.ipynb)
  - SELECT 文におけるサブクエリ・JOIN・UNIONの使い方
- [50_SQLBENRI](notebooks/50_SQLBENRI.ipynb)
  - 文字列操作などで役に立つ機能や分析クエリで多用される Window 関数について

各ノートブックの最後に練習問題を用意してあります。

#### :rocket: 演習について

チュートリアルと同様に AWS Cloud9 を利用して演習を行います。

- インデックスの演習
  - [ISUCON](http://isucon.net/) の[過去問題](https://github.com/isucon/isucon5-qualify)を利用して MySQL を利用している Web アプリケーションのボトルネックを特定し改善する方法を学ぶ
- ストレージエンジンの実装
  - MySQL の主幹機能の一つであるストレージエンジンの実装を通してデータベースの基本機能を自分で実装し SQL クエリの裏側で何が起きているのか観察してみる
  
 * * * * *

### 演習環境について

#### ディレクトリ

- `./docker` ディレクトリ
  - 演習で使用する採点用アプリケーションなどが入っています
- `./infra` ディレクトリ
  - インフラ管理に必要な設定ファイルやスクリプトなどが入っています
  
#### 管理用S3バケット

- 演習環境の管理に必要となるサーバーの SSH キーや外部サービスの認証情報などは `s3://mixi-db-training` 配下に格納されています。別の場所で実行する場合はよしなにやってください（バケット名を書き換えたり鍵を生成したり）

#### IAMユーザー管理

- ./infra/variables.tf 内の `usernames` という項目を編集すると IAM ユーザーと対応する Cloud9 の開発環境が作成されます
- 注意: IAM ユーザー名は上で指定した名前に `db.` というプレフィックスが付いた状態で作成されます

#### インフラ管理方法

- 管理用S3バケットへのアクセス権限を持った IAM アカウントを用意してください
- `./infra` ディレクトリで `make infra-tools` を実行すると必要な GPG 鍵やコマンドが入った Docker コンテナが立ち上がります

以下の手順で実行していくと演習環境を構築することができます

- terraform の実行
  - `terraform init` => `terraform apply`
- Cloud9 の設定
  - `python3 ./script/setup_cloud9.py`
  - EBS ボリュームサイズの変更
  - セキュリティグループの設定
- サーバーの設定
  - `make server`
  - チュートリアル用 MySQL サーバーの起動
  - 採点用アプリケーションの起動

 * * * * *

### ライセンス

The MIT License (MIT)

Copyright (c) 2019 mixi, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
