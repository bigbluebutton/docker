#!/bin/bash

cd /app/

# patch database url
# TODO: this should be possible via an environment variable
yq e -i '.[1].configuration.connection_info.database_url.connection_parameters.host = "postgres"' metadata/databases/databases.yaml
yq e -i ".[1].configuration.connection_info.database_url.connection_parameters.password = \"${POSTGRES_PASSWORD}\"" metadata/databases/databases.yaml


echo "SELECT 'CREATE DATABASE hasura_app' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'hasura_app')\gexec" | psql

echo "Restarting database bbb_graphql"
psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = 'bbb_graphql'" > /dev/null
psql -c "drop database if exists bbb_graphql with (force)"
psql -c "create database bbb_graphql WITH TEMPLATE template0 LC_COLLATE 'C.UTF-8'"
psql -c "alter database bbb_graphql set timezone to 'UTC'"

echo "Creating tables in bbb_graphql"
psql -U postgres -d bbb_graphql -q -f bbb_schema.sql --set ON_ERROR_STOP=on

echo "Starting hasura-graphql-engine"
gosu nobody graphql-engine serve &
PID=$!

sleep 1


#Check if Hasura is ready before applying metadata
HASURA_PORT=8080
while ! netstat -tuln | grep ":$HASURA_PORT " > /dev/null; do
    echo "Waiting for Hasura's port ($HASURA_PORT) to be ready..."
    sleep 1
done

echo "Applying new metadata to Hasura"
/usr/local/bin/hansura metadata apply --skip-update-check

wait "$PID"