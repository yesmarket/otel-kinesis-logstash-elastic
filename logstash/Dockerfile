FROM docker.elastic.co/logstash/logstash-oss:6.7.1 AS runtime
RUN logstash-plugin install logstash-input-kinesis
COPY ./config/logstash.yml ./config/pipelines.yml /usr/share/logstash/config/
COPY ./pipeline/apps.conf /usr/share/logstash/pipeline/apps.conf
