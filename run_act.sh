#!/bin/bash

# Script to setup act with docker-compose services
# based on https://github.com/nektos/act

export POSTGRES_DB_DATABASE=db
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres

export MYSQL_DB_DATABASE=db
export MYSQL_USER=user
export MYSQL_PASSWORD=password

export ACT_HOST=$(hostname -I)

docker-compose up -d 

POSTGRES_DB_PORT=$(docker-compose port postgres 5432)
POSTGRES_DB_PORT="${POSTGRES_DB_PORT##*:}"

MYSQL_DB_PORT=$(docker-compose port mysql 3306)
MYSQL_DB_PORT="${MYSQL_DB_PORT##*:}"

# act -j run-robotframework-tests \
#     -W .github/workflows/psycopg2-tests.yml \
#     --artifact-server-path ${PWD}/artifacts \
#     --env ACT_DB_HOST=${ACT_HOST} --env ACT_POSTGRES_DB_PORT=${POSTGRES_DB_PORT}

# act -j run-robotframework-tests \
#     -W .github/workflows/mysql-tests.yml \
#     --artifact-server-path ${PWD}/artifacts \
#     --env ACT_DB_HOST=${ACT_HOST} --env ACT_MYSQL_DB_PORT=${MYSQL_DB_PORT}

# act -j run-robotframework-tests \
#     -W .github/workflows/sqlite3-tests.yml \
#     --artifact-server-path ${PWD}/artifacts

act pull_request \
    --artifact-server-path ${PWD}/artifacts \
    --env ACT_DB_HOST=${ACT_HOST} --env ACT_MYSQL_DB_PORT=${MYSQL_DB_PORT} --env ACT_POSTGRES_DB_PORT=${POSTGRES_DB_PORT}

docker-compose down