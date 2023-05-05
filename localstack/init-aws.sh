#!/bin/bash

awslocal kinesis create-stream --stream-name logs --shard-count 1
awslocal kinesis create-stream --stream-name traces --shard-count 1
awslocal kinesis create-stream --stream-name metrics --shard-count 1

awslocal s3 mb s3://traces-backup
awslocal firehose create-delivery-stream --delivery-stream-name traces-to-otel --delivery-stream-type KinesisStreamAsSource --kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:us-east-1:000000000000:stream/traces,RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role" --http-endpoint-destination-configuration "EndpointConfiguration={Url=http://logstash:8082},S3BackupMode=FailedDataOnly,S3Configuration={RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,BucketARN=arn:aws:s3:::traces-backup}"

awslocal s3 mb s3://metrics-backup
awslocal firehose create-delivery-stream --delivery-stream-name metrics-to-otel --delivery-stream-type KinesisStreamAsSource --kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:us-east-1:000000000000:stream/metrics,RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role" --http-endpoint-destination-configuration "EndpointConfiguration={Url=http://logstash:8083},S3BackupMode=FailedDataOnly,S3Configuration={RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,BucketARN=arn:aws:s3:::metrics-backup}"
