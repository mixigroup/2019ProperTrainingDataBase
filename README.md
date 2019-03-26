## 2019年度新卒データベース研修

### 演習環境の構築

./infra ディレクトリの下にインフラ管理に必要なスクリプトなどが入っています。

- ユーザー管理
  - ./infra/variables.tf 内の `usernames` という項目を編集すると IAM ユーザーと対応する Cloud9 の開発環境が作成されます
  - 注意: IAM ユーザー名は上で指定した名前に `db.` というプレフィックスが付いた状態で作成されます
- インフラ管理ツール
  - `make infra-tools` を実行すると必要な GPG 鍵やコマンドが入った Docker コンテナが立ち上がります
- 実行手順
  - infra-tools の起動
  - terraform の実行
    - terraform init => terraform apply
  - Cloud9 の設定
    - `python3 ./script/setup_cloud9.py`
  - サーバーの設定
    - `make server`
