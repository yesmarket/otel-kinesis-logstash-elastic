# Overview

The aim of this project is to build a telemetry pipeline POC that specifically uses the Open Telemetry (OTEL) collector agent to get the logs, metrics, & APM instrumentation data from a dummy microservice to a AWS Kinesis streaming layer and then through to Elasticsearch via Logstash.

# Pre-requisites

* docker
* docker-compose

# Running the project

```
docker-compose up
```
