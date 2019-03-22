.PHONY: infra
infra:
	mkdir -p ./infra/tmp
	aws s3 cp s3://mixi-db-training/config/keys/id_db_training.pub ./infra/tmp/
	aws s3 cp s3://mixi-db-training/config/keys/hello.public.gpg ./infra/tmp/
	docker build -t infra-tools ./docker/infra-tools
	docker run \
		-ti \
		-v $(PWD):/app \
		-v $(HOME)/.aws:/root/.aws \
		-w /app \
		infra-tools \
		bash

.PHONY: server/docker
server/docker:
	sudo apt update && sudo apt install -y docker.io
	sudo usermod -a -G docker ubuntu
	sudo service docker restart

/swapfile:
	sudo dd if=/dev/zero of=/swapfile bs=128M count=10
	sudo chmod go-rwx /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile

.PHONY: server/db
server/db: /swapfile
	docker build -t tutorial ./docker/tutorial
	docker run \
		-d \
		-v $(PWD)/docker/tutorial/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
		-p 3306:3306 \
		tutorial

.PHONY: sshkey
sshkey:
	aws s3 cp s3://mixi-db-training/config/keys/id_db_training ~/.ssh/
	chmod go-rwx ~/.ssh/id_db_training

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

.PHONY: benchapp
benchapp:
	docker build -t bench ./docker/bench
	docker run \
		-d \
		--rm \
		-v $(PWD)/docker/bench/webapp:/opt/webapp \
		-w /opt/webapp \
		-p 8080:8080 \
		bench \
		bundle exec rackup --host 0.0.0.0 --port 8080

.PHONY: url
url:
	bash -lc 'echo "https://${C9_PID}.vfs.cloud9.$(shell aws configure get region).amazonaws.com"'
