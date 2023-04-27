FROM jruby as build

RUN apt-get update && apt-get install -y vim netbase

RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-8.7.1-linux-x86_64.tar.gz && \
    tar -xzvf ./logstash-8.7.1-linux-x86_64.tar.gz -C /usr/share && \
    mv /usr/share/logstash-8.7.1/ /usr/share/logstash/

# if need older version:
# https://artifacts.elastic.co/downloads/logstash/logstash-6.7.2.tar.gz

RUN LOGSTASH_PATH=/usr/share/logstash && export LOGSTASH_PATH

RUN mkdir -p /usr/src/logstash-output-elasticapm
COPY ./logstash-output-elasticapm /usr/src/logstash-output-elasticapm

RUN cd /usr/src/logstash-output-elasticapm && bundle install

#gem build logstash-filter-awesome.gemspec



# FROM docker.elastic.co/logstash/logstash:8.7.0 as runtime

# USER root

# RUN apt-get update && \
#     apt-get install -y vim

# USER logstash

# #RUN logstash-plugin install logstash-input-kinesis

# RUN mkdir tmp
# COPY --from=build --chown=logstash:logstash /usr/src/logstash-output-elasticapm/logstash-output-elasticapm-0.2.0.gem ./tmp/
# RUN logstash-plugin install ./tmp/logstash-output-elasticapm-0.2.0.gem

# COPY ./config/logstash.yml ./config/pipelines.yml /usr/share/logstash/config/
# COPY ./pipeline/logs.conf /usr/share/logstash/pipeline/logs.conf
# COPY ./pipeline/traces.conf /usr/share/logstash/pipeline/traces.conf

# EXPOSE 8081
# EXPOSE 8082
