.PHONY: shell
shell: mrbdb
	docker run \
		-ti \
		-e MYSQL_ROOT_PASSWORD=mysql \
		-w /opt/build \
		-v $(PWD)/src/kiyoshi:/opt/mysql-server/storage/kiyoshi \
		-v $(PWD)/mrbdb/src:/opt/mysql-server/storage/mrbdb \
		-v $(PWD)/script:/opt/script \
		database-training \
		bash

mrbdb:
	git clone https://github.com/sh19910711/mrbdb

.PHONY: build
build:
	docker build -t database-training .

# mrbdb: 観察用差分の反映
.PHONY: observe
observe:
	cd mrbdb && git reset --hard && cat ../patch/mrbdb_debug_print.diff | git apply
