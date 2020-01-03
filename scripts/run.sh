#!/usr/bin/env bash

OUTPUT_DIR=".."
DOCKER_DIR="$OUTPUT_DIR/docker"

function dockerComposeUp() {
    dockerComposeFiles
    docker-compose up -d
}

function dockerComposeDown() {
    dockerComposeFiles
    docker-compose down
}

function dockerComposePull() {
    dockerComposeFiles
    docker-compose pull
}

function dockerComposeFiles() {
    #if [ -f "${DOCKER_DIR}/docker-compose.override.yml" ]
    #then
    #    export COMPOSE_FILE="$DOCKER_DIR/docker-compose.yml:$DOCKER_DIR/docker-compose.override.yml"
    #else
    #    export COMPOSE_FILE="$DOCKER_DIR/docker-compose.yml"
    #fi
    export COMPOSE_FILE="../docker-compose.yml"
    export COMPOSE_HTTP_TIMEOUT="300"
}

function restart() {
    dockerComposeDown
    dockerComposePull
    dockerComposeUp
}

restart