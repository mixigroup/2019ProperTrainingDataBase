-- サンプルデータベースのインストール
source employees.sql;

-- 演習用ユーザーの作成
create user hello@'%' identified by 'world';
grant select on employees.* to hello;
