FROM mysql:8.0.15

RUN apt update && \
  apt install -y \
    curl \
    git \
    g++ \
    make \
    bison \
    ccache \
    libssl-dev \
    libncurses5-dev \
    procps \
    locales \
    ruby \
    doxygen

RUN mkdir /tmp/cmake && \
  cd /tmp/cmake && \
  curl -L https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3.tar.gz | tar zxf - && \
  cd cmake-3.13.3 && \
  ./configure && \
  make -j4 && \
  make install && \
  rm -rf /tmp/cmake

RUN cd /opt && \
  git clone --single-branch --branch 2.0.0 --depth 1 https://github.com/mruby/mruby.git && \
  git clone --single-branch --branch mysql-8.0.15 --depth 1 https://github.com/mysql/mysql-server.git && \
  mkdir /opt/build
