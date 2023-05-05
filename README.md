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

Replace `{compose-file}` with the specific compose file you want to run.
