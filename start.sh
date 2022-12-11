#!/bin/bash

echo "Cloning Airbyte branch.."

git clone -b modern-data-stack https://github.com/KattsonBastos/airbyte

echo "Starting Airbyte.."

docker-compose -f ./airbyte/docker-compose.yml up -d

echo "Starting Airflow.."

docker-compose -f ./airflow/docker-compose.yml up -d

echo "Starting Metabase.."

docker-compose -f ./metabase/docker-compose.yml up -d