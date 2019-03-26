.PHONY: jupyter
jupyter:
	docker run \
		-v $(PWD)/notebooks:/home/jovyan/tutorial \
		--rm \
		--name jupyter \
		-e CHOWN_HOME=1 \
		-u root \
		-e NB_UID=$$(id -u) \
		-e NB_GID=$$(id -g) \
		-p $(PORT):8888 \
		jupyter/base-notebook

.PHONY: isucon5q
isucon5q:
	sudo yum update -y && sudo yum install -y mysql-server
	sudo service mysqld restart
	echo create database isucon5q | mysql -uroot
	aws s3 cp s3://mixi-db-training/isucon5q/dump.sql.gz /tmp/dump.sql.gz
	cat /tmp/dump.sql.gz | gunzip | mysql -uroot isucon5q


.PHONY: url
url:
	bash -lc 'echo "https://${C9_PID}.vfs.cloud9.$(shell aws configure get region).amazonaws.com"'
