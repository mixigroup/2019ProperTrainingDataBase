FROM ubuntu:18.04

RUN apt update && apt install -y \
  python3 \
  python3-pip \
  groff \
  jq \
  vim \
  unzip \
  curl

RUN pip3 install awscli
RUN mkdir -p /opt/terraform && \
  cd /opt/terraform && \
  curl -o terraform.zip https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip && \
  unzip terraform.zip && \
  mv terraform /usr/local/bin/
