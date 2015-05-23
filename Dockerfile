FROM ubuntu:14.04
MAINTAINER Hussein Galal
ENV DEBIAN_FRONTEND=noninteractive

# Install Important tools
RUN apt-get -q update
RUN apt-get install -yqq wget software-properties-common

# Update the repos
RUN wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | tee /etc/apt/sources.list.d/elasticsearch.list
RUN echo 'deb http://packages.elasticsearch.org/logstash/1.5/debian stable main' | tee /etc/apt/sources.list.d/logstash.list
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update

# Java 8
RUN apt-get install -yqq openjdk-8-jdk

# Elasticsearch 1.4.4
RUN apt-get -yqq install elasticsearch=1.4.4
RUN sed -i "s/#network.host.*/network.host: localhost/g" /etc/elasticsearch/elasticsearch.yml
VOLUME /var/lib/elasticsearch

# Logstash 1.5 -Server
RUN apt-get install -yqq logstash
ADD logstash/input.conf /etc/logstash/conf.d/01-input.conf
ADD logstash/syslog.conf /etc/logstash/conf.d/10-syslog.conf
ADD logstash/apache.conf /etc/logstash/conf.d/20-apache.conf
ADD logstash/output.conf /etc/logstash/conf.d/40-output.conf

# Kibana 4.0.1
RUN wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz
RUN tar xf kibana-4*.tar.gz
RUN mkdir -p /opt/kibana
RUN cp -R kibana-*/* /opt/kibana
ADD kibana/kibana.yml /opt/kibana/config/kibana.yml

# Start script
ADD run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh
WORKDIR /opt/kibana

EXPOSE 8000

ENTRYPOINT /tmp/run.sh
