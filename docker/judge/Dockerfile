FROM ruby:2.6.2

ADD webapp /opt/webapp
RUN cd /opt/webapp && \
	gem install bundler && \
	bundle install -j4
