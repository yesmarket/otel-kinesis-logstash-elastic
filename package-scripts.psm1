# Otel-Module.psm1
Write-Host "Loading Otel-Module"

function Clean-Docker {
   <#
   .SYNOPSIS
      Helper function to clean docker containers, volumes, networks, and images.
   .DESCRIPTION
      Helper function to clean docker containers, volumes, networks, and images.
   .PARAMETER containers
      Specifies, whether or not, docker containers will be removed.
   .PARAMETER volumes
      Specifies, whether or not, docker volumes will be removed.
   .PARAMETER networks
      Specifies, whether or not, docker networks will be removed.
   .PARAMETER networks
      Specifies, whether or not, docker images will be removed.
   .Example
      Clean-Docker -containers $true -volumes $true -networks $true
   #>
   Param(
      [bool]$containers=$true,
      [bool]$volumes=$true,
      [bool]$networks=$true,
      [bool]$images=$false
   )
   if (!(Get-Command docker))
   {
      echo 'docker required'
      return
   }
   if ($containers) {
      if (docker ps -q) {
         echo "stopping running containers..."
         docker stop $(docker ps -q) > $null
      }
      if (docker ps -a -q) {
         echo "removing containers..."
         docker rm $(docker ps -a -q) > $null
      }
   }
   if ($volumes -And (docker volume ls -q)) {
      echo "removing volumes..."
      docker volume rm $(docker volume ls -q) > $null
   }
   if ($networks -And (docker network ls -f "type=custom" -q)) {
      echo "removing networks..."
      docker network rm $(docker network ls -f "type=custom" -q) > $null
   }
   if ($images -And (docker image ls -a -q)) {
      echo "removing images..."
      docker rmi $(docker image ls -a -q) > $null
   }
}

function Clean-Docker2 {
   Param(
      [string]$images='dotnet-api,otel-front,localstack,otel-back,logstash'
   )
   Clean-Docker -containers $true -volumes $true -networks $true -images $false
   if ($images -And (docker image ls -a -q)) {
      $arr = $images.Split(",")
      $arr | ForEach-Object { iex "docker rmi -f otel-kinesis-logstash-elastic_$_" }
   }
}

function Get-KinesisDataStreamRecords {
   Param(
      [string]$streamName='traces',
      [string]$endpointUrl='http://192.168.99.106:4566'
   )
   $describeStream = awslocal --endpoint-url=$endpointUrl kinesis describe-stream --stream-name $streamName | ConvertFrom-Json
   $getShardIterator = awslocal --endpoint-url=$endpointUrl kinesis get-shard-iterator --stream-name $streamName --shard-id $describeStream.StreamDescription.Shards[0].ShardId --shard-iterator-type TRIM_HORIZON | ConvertFrom-Json
   $getRecords = awslocal --endpoint-url=$endpointUrl kinesis get-records --shard-iterator $getShardIterator.ShardIterator | ConvertFrom-Json
   echo $getRecords.Records
}

function List-KinesisDataStreams {
   Param(
      [string]$endpointUrl='http://192.168.99.106:4566'
   )
   $listStreams = awslocal --endpoint-url=$endpointUrl kinesis list-streams | ConvertFrom-Json
   $listStreams.StreamNames
}

function List-KinesisDeliveryStreams {
   Param(
      [string]$endpointUrl='http://192.168.99.106:4566'
   )
   $listDeliveryStreams = awslocal --endpoint-url=$endpointUrl firehose list-delivery-streams | ConvertFrom-Json
   $listDeliveryStreams.DeliveryStreamNames
}

$otel_module = $MyInvocation.MyCommand.ScriptBlock.Module
$otel_module.OnRemove = {Write-Host "Removed Otel-Module"}
