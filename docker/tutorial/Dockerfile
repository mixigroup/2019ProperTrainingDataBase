FROM mysql:8.0.15

ENV MYSQL_ROOT_PASSWORD=mysql

RUN apt update && \
	apt install -y git && \
	git clone --depth 1 https://github.com/datacharmer/test_db /opt/test_db
