#!/bin/bash

echo "test man yeah"
awslocal --endpoint-url=http://192.168.99.106:4566 kinesis create-stream --stream-name samplestream --shard-count 1
