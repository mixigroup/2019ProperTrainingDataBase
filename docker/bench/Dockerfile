FROM gradle:5.2.1-jdk8

USER root
RUN cd /opt && \
	git clone https://github.com/isucon/isucon5-qualify && \
	cd /opt/isucon5-qualify/bench && \
	gradle compileJava
RUN apt update && apt install -y ruby jq && \
	gem install bundler
ADD webapp /opt/webapp
RUN cd /opt/webapp && bundle install -j4
