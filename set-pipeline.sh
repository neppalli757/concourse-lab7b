#!/bin/bash

set -ex

if [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ] || [ "$4" = "" ]; then
  echo $0: usage: $0 concourse-target pipeline.yml  credentials.yml pipeline-name
  exit
fi

concourse_target=$1
pipeline=$2
credentials=$3
pipeline_name=$4

if [ ! -e  $pipeline ]; then
  echo $0: Pipeline file does not exist: $pipeline
  exit
fi

if [ ! -e  $credentials ]; then
  echo $0: Credential file does not exist: $credentials
  exit
fi

cat $credentials > temp-config.yml


fly -t $concourse_target set-pipeline -c $pipeline -l temp-config.yml -p $pipeline_name -n

rm temp-config.yml

fly -t $concourse_target unpause-pipeline -p $pipeline_name
