.PHONY: shell
shell:
	docker run \
		-ti \
		-e MYSQL_ROOT_PASSWORD=mysql \
		-w /opt/build \
		-v $(PWD)/src/hello:/opt/mysql-server/storage/hello \
		-v $(PWD)/script:/opt/script \
		database-training \
		bash

.PHONY: build
build:
	docker build -t database-training .
