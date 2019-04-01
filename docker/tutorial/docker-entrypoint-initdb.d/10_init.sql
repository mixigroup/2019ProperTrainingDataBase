-- disable root@'%'
delete from mysql.user where user='root' and host='%';
flush privileges;

-- 演習用ユーザーの作成
create user hello@'%' identified by 'world';
grant select on employees.* to hello;
create database tmp;
grant create temporary tables on tmp.* to hello;

-- サンプルデータベースのインストール
source employees.sql;
