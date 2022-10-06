FROM docker.elastic.co/logstash/logstash-oss:6.7.1 AS runtime
RUN logstash-plugin install logstash-input-kinesis
#RUN logstash-plugin install --version '1.0.2' logstash-input-sfdc_elf
COPY ./config/logstash.yml ./config/pipelines.yml /usr/share/logstash/config/
COPY ./pipeline/kinesis.conf /usr/share/logstash/pipeline/kinesis.conf
#COPY ./pipeline/elf.conf /usr/share/logstash/pipeline/elf.conf
