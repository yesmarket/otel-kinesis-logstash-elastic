# Overview

The aim of this project is to build a telemetry pipeline POC that specifically uses the Open Telemetry (OTEL) collector agent to get logs, metrics, and traces from some dummy microservices (dotnet, java, and node.js) to a AWS Kinesis streaming layer and then through to Elasticsearch via Logstash.

# Pre-requisites

## requried

* git
* git-crypt
* docker
* docker-compose

## optional

* PowerShell (for some useful helper commands)
* dotnet core (for the ./demo-apps/dotnet-api)
* Java (for ./demo-apps/java-api)
* node.js (for ./demo-apps/node-bff)
* Ruby (for logstash plugins i.e. logstash-output-elasticapm and logstash-input-kinesis)

# getting started

```
git clone git@github.com:yesmarket/otel-kinesis-logstash-elastic.git
git submodule update --init --recursive
git-crypt unlock
```

# running the project

```
docker-compose -f {compose-file} up --build
```

Obviously replace `{compose-file}` with the specific compose file you want to run e.g. `docker-compose.kinesis.yml`.

# integration pipelines

There are several integration pipelines through to Elastic with each having a separate docker-compose file.

## direct

| type | pipeline | working |
| --- | --- | --- |
| metrics (java-api) | `microservices (opentelemetry agent grpc/otlp exporter) -> elastic apm -> elasticsearch` | yes |
| traces | `microservices (opentelemetry agent grpc/otlp exporter) -> elastic apm -> elasticsearch` | yes |

## otel

| type | pipeline | working |
| --- | --- | --- |
| logs | `microservices (serilog console sink) -> file <- (file reciever) otel collector agent (elasticsearch exporter) -> elasticsearch ingest pipeline -> elasticsearch` | no |
| metrics (java-api) | `microservices (opentelemetry agent grpc/otlp exporter) -> (otlp/grpc receiver) otel collector agent (elasticsearch exporter) -> elastic apm -> elasticsearch` | no |
| metrics (dotnet-api) | `microservices (prometheus endpoint) <- (prometheus reciever) otel collector agent (elasticsearch exporter) -> elastic apm -> elasticsearch` | no |
| traces | `microservices (opentelemetry agent grpc/otlp exporter) -> (otlp/grpc reciever) otel collector agent (elasticsearch exporter) -> elastic apm -> elasticsearch` | no |

Note: ^^ these aren't working!

## kinesis

| type | pipeline | working |
| --- | --- | --- |
| logs | `microservices (serilog console sink) -> file <- (file reciever) otel collector agent (awskinesis exporter) -> kinesis data stream <- (kinesis input) Logstash (elasticsearch output) -> elasticsearch ingest pipeline -> elasticsearch` | yes |
| metrics (java-api) | `microservices (opentelemetry agent grpc/otlp exporter) -> (otlp/grpc receiver) otel collector agent (awskinesis exporter) -> kinesis data stream <- kinesis delivery stream -> (http input) Logstash (elasticapm output) -> elastic apm -> elasticsearch` | no |
| metrics (dotnet-api) | `microservices (prometheus endpoint) <- (prometheus reciever) otel collector agent (awskinesis exporter) -> kinesis data stream <- kinesis delivery stream -> (http input) Logstash (elasticapm output) -> elastic apm -> elasticsearch` | no |
| traces | `microservices (opentelemetry agent grpc/otlp exporter) -> (otlp/grpc reciever) otel collector agent (awskinesis exporter) -> kinesis data stream <- kinesis delivery stream -> (http input) Logstash (elasticapm output) -> elastic apm -> elasticsearch` | yes |


