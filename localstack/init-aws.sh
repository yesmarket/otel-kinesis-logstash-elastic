#!/bin/bash

awslocal kinesis create-stream --stream-name logs --shard-count 1
awslocal kinesis create-stream --stream-name traces --shard-count 1

awslocal s3 mb s3://logs-backup
awslocal firehose create-delivery-stream --delivery-stream-name logs-to-otel --delivery-stream-type KinesisStreamAsSource --kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:us-east-1:000000000000:stream/logs,RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role" --http-endpoint-destination-configuration "EndpointConfiguration={Url=https://eokd8cms1toy5qp.m.pipedream.net},S3BackupMode=FailedDataOnly,S3Configuration={RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,BucketARN=arn:aws:s3:::logs-backup}"

awslocal s3 mb s3://traces-backup
awslocal firehose create-delivery-stream --delivery-stream-name traces-to-otel --delivery-stream-type KinesisStreamAsSource --kinesis-stream-source-configuration "KinesisStreamARN=arn:aws:kinesis:us-east-1:000000000000:stream/traces,RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role" --http-endpoint-destination-configuration "EndpointConfiguration={Url=https://eoaj6ehaytqklbq.m.pipedream.net},S3BackupMode=FailedDataOnly,S3Configuration={RoleARN=arn:aws:iam::000000000000:role/Firehose-Reader-Role,BucketARN=arn:aws:s3:::traces-backup}"