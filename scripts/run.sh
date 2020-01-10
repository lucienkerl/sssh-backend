#!/usr/bin/env bash

DEV=false

OUTPUT_DIR=".."
if [ $# -gt 1 ]
then
    OUTPUT_DIR=$2
fi

COREVERSION="latest"
if [ $# -gt 2 ]
then
    COREVERSION=$3
fi

OS="lin"
[ "$(uname)" == "Darwin" ] && OS="mac"
ENV_DIR="$OUTPUT_DIR/env"
DOCKER_DIR="$OUTPUT_DIR"
if [ -d "$OUTPUT_DIR/docker" ]
then
    DOCKER_DIR="$OUTPUT_DIR/docker"
fi

# Initialize UID/GID which will be used to run services from within containers
if ! grep -q "^LOCAL_UID=" $ENV_DIR/uid.env 2>/dev/null || ! grep -q "^LOCAL_GID=" $ENV_DIR/uid.env 2>/dev/null
then
    LUID="LOCAL_UID=`id -u $USER`"
    [ "$LUID" == "LOCAL_UID=0" ] && LUID="LOCAL_UID=65534"
    LGID="LOCAL_GID=`id -g $USER`"
    [ "$LGID" == "LOCAL_GID=0" ] && LGID="LOCAL_GID=65534"
    mkdir -p $ENV_DIR
    echo $LUID >$ENV_DIR/uid.env
    echo $LGID >>$ENV_DIR/uid.env
fi

function dockerComposeUp() {
    dockerComposeFiles
    if [ "$DEV" == true ]
    then
        docker-compose -f ../docker-compose.dev.yml up
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
    docker-compose pull
}

function dockerComposeFiles() {
    if [ -f "${DOCKER_DIR}/docker-compose.override.yml" ]
    then
        export COMPOSE_FILE="$DOCKER_DIR/docker-compose.yml:$DOCKER_DIR/docker-compose.override.yml"
    else
        if [ "$DEV" == true ]
        then
            export COMPOSE_FILE="$DOCKER_DIR/docker-compose.dev.yml"
        else
            export COMPOSE_FILE="$DOCKER_DIR/docker-compose.yml"
        fi
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

function pullSetup(){
    docker pull lucienkerl/sssh-backend:$COREVERSION
}

function install() {
    pullSetup
}

function dockerPrune() {
    docker image prune --all --force --filter="label=com.wuerth.product=sssh"
}

function stop() {
    dockerComposeDown
}

function buildAndUploadToDocker() {
    docker build -t lucienkerl/sssh-backend ../
    docker push lucienkerl/sssh-backend:latest
}

# Commands

if [ "$1" == "install" ]
then
    install
elif [ "$1" == "start" -o "$1" == "restart" ]
then
    restart
elif [ "$1" == "stop" -o "$1" == "stop" ]
then
    stop
elif [ "$1" == "buildAndUploadToDocker" ]
then
    buildAndUploadToDocker 
elif [ "$1" == "update" ]
then
    dockerComposeDown
    pullSetup
    restart
    dockerPrune
elif [ "$1" == "start-dev" ]
then
    startDev
fi