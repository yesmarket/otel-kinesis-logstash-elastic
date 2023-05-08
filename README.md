# Overview

The aim of this project is to build a telemetry pipeline POC that specifically uses the Open Telemetry (OTEL) collector agent to get logs, metrics, and traces from some dummy microservices (dotnet, java, and node.js) to an AWS Kinesis streaming layer (using localstack) and finally through to Elasticsearch (Elastic Cloud) via Logstash.

# Pre-requisites

## requried

* git
* git-crypt
* docker
* docker-compose

## optional

* PowerShell (for some helper commands)
* dotnet core (if you intend to modify ./demo-apps/dotnet-api)
* Java (if you intend to modify ./demo-apps/java-api)
* node.js (if you intend to modify ./demo-apps/node-bff)
* Ruby (if you intend to modify the logstash-output-elasticapm plugin)

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

## docker-compose.direct.yml

| type | pipeline | working |
| :--- | :--- | :---: |
| metrics (java-api) | `microservices (opentelemetry agent grpc/otlp exporter) -> elastic apm -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236388851-0cdbf473-af2c-4090-93b5-1ef597f86b9c.png" height="20" width="20" /> |
| traces | `microservices (opentelemetry agent grpc/otlp exporter) -> elastic apm -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236388851-0cdbf473-af2c-4090-93b5-1ef597f86b9c.png" height="20" width="20" /> |

## docker-compose.otel.yml

| type | pipeline | working |
| :--- | :--- | :---: |
| logs | `microservices (serilog console sink) -> file <- (file reciever) otel collector agent (elasticsearch exporter) -> elasticsearch ingest pipeline -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236389448-71505ef6-d7d7-4cd3-acc0-e549de122f47.png" height="20" width="20" /> |
| metrics | `microservices (prometheus endpoint) <- (prometheus reciever) otel collector agent (elasticsearch exporter) -> elastic apm -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236389448-71505ef6-d7d7-4cd3-acc0-e549de122f47.png" height="20" width="20" /> |
| traces | `microservices (opentelemetry agent grpc/otlp exporter) -> (otlp/grpc reciever) otel collector agent (elasticsearch exporter) -> elastic apm -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236389448-71505ef6-d7d7-4cd3-acc0-e549de122f47.png" height="20" width="20" /> |

Note: ^^ these aren't working!

## docker-compose.kinesis.yml

| type | pipeline | working |
| :--- | :--- | :---: |
| logs | `microservices (serilog console sink) -> file <- (file reciever) otel collector agent (awskinesis exporter) -> kinesis data stream <- (kinesis input) Logstash (elasticsearch output) -> elasticsearch ingest pipeline -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236388851-0cdbf473-af2c-4090-93b5-1ef597f86b9c.png" height="20" width="20" /> |
| metrics | `microservices (prometheus endpoint) <- (prometheus reciever) otel collector agent (awskinesis exporter) -> kinesis data stream <- kinesis delivery stream -> (http input) Logstash (elasticapm output) -> elastic apm -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236388851-0cdbf473-af2c-4090-93b5-1ef597f86b9c.png" height="20" width="20" /> |
| traces | `microservices (opentelemetry agent grpc/otlp exporter) -> (otlp/grpc reciever) otel collector agent (awskinesis exporter) -> kinesis data stream <- kinesis delivery stream -> (http input) Logstash (elasticapm output) -> elastic apm -> elasticsearch` | <img src="https://user-images.githubusercontent.com/10783372/236388851-0cdbf473-af2c-4090-93b5-1ef597f86b9c.png" height="20" width="20" /> |
