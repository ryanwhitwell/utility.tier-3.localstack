FROM debian:jessie

LABEL Author="Ryan Whitwell (ryanwhitwell.developer@gmail.com)"

WORKDIR /tmp/

# Update apt-get and install dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y curl && \
    apt-get install -y wget && \
    apt-get install -y nano 

# Install Java Runtime Environment
RUN apt-get install -y default-jre && \
    export JAVA_HOME=/usr/bin && \
    export PATH=$JAVA_HOME/bin:$PATH

# Install version 3.2 of MongoDB
RUN echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" >> /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    wget --no-check-certificate -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | apt-key add - && \
    apt-get update -y && \
    apt-get install -y mongodb-org=3.2.22 mongodb-org-server=3.2.22 mongodb-org-shell=3.2.22 mongodb-org-mongos=3.2.22 mongodb-org-tools=3.2.22 && \
    mkdir -p /data/db/ && \
    mkdir -p /data/config/

# Install latest version of RabbitMQ
RUN curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | apt-key add - && \
    apt-get install apt-transport-https -y && \
    apt-get update -y && \
    apt-get install rabbitmq-server -y --fix-missing

# Install version 3.6.16 of RabbitMQ
# RUN curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | apt-key add - && \
#     echo "deb https://dl.bintray.com/rabbitmq-erlang/debian jessie erlang-19.x" >> /etc/apt/sources.list.d/bintray.rabbitmq.list && \
#     echo "deb https://dl.bintray.com/rabbitmq/debian jessie rabbitmq-server-v3.6.x" >> /etc/apt/sources.list.d/bintray.rabbitmq.list && \
#     apt-get update -y && \
#     apt-get install rabbitmq-server -y --fix-missing

# Install latest version of Redis
RUN apt-get install -y redis-server

# Install latest version of Elasticsearch
# RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
#     echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list && \
#     apt-get update -y && \
#     apt-get install elasticsearch

WORKDIR /

# Install version 2.3.4 of Elasticsearch
RUN curl -k -L -O https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.4/elasticsearch-2.3.4.tar.gz && \
    tar -xvf elasticsearch-2.3.4.tar.gz && \
    rm -rf elasticsearch-2.3.4.tar.gz && \
    mkdir -p /elasticsearch-2.3.4/logs/ && \
    mkdir -p /elasticsearch-2.3.4/data/
    
# Install scripts
ADD scripts/ scripts/