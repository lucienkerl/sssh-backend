#!/usr/bin/env bash

DEV=false

function dockerComposeUp() {
    dockerComposeFiles
    if [ "$DEV" == true ]
    then
        docker-compose up
    else
        docker-compose up -d
    fi
}

function dockerComposeDown() {
    dockerComposeFiles
    docker-compose down
}

function dockerComposePull() {
    dockerComposeFiles
    docker-compose build
}

function dockerComposeFiles() {
    if [ "$DEV" == true ]
    then
        cp ../docker-compose.dev.yml ../docker-compose.override.yml
    else
        rm ../docker-compose.override.yml
    fi

    if [ -f "../docker-compose.override.yml" ]
    then
        export COMPOSE_FILE="../docker-compose.yml:../docker-compose.override.yml"
    else
        export COMPOSE_FILE="../docker-compose.yml"
    fi
    export COMPOSE_HTTP_TIMEOUT="300"
}

function restart() {
    dockerComposeDown
    dockerComposePull
    dockerComposeUp
}

function startDev() {
    DEV=true
    restart
}

# Commands

if [ "$1" == "install" ]
then
    restart
elif [ "$1" == "start" -o "$1" == "restart" ]
then
    restart
elif [ "$1" == "start-dev" ]
then
    startDev
fi