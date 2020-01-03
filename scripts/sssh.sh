#!/usr/bin/env bash
set -e

cat << "EOF"

  _____ _____ _____ _    _ 
 / ____/ ____/ ____| |  | |
| (___| (___| (___ | |__| |
 \___ \\___ \\___ \|  __  |
 ____) |___) |___) | |  | |
|_____/_____/_____/|_|  |_|
                           

EOF

cat << EOF

===================================================

EOF

docker --version
docker-compose --version

echo ""

# Setup

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME=`basename "$0"`
SCRIPT_PATH="$DIR/$SCRIPT_NAME"
OUTPUT="$DIR/data"
if [ $# -eq 2 ]
then
    OUTPUT=$2
fi

SCRIPTS_DIR="$OUTPUT/scripts"
GITHUB_BASE_URL="https://gitea.wgn.wuerth.com/EBMS/sssh-backend/raw/branch/master/"
COREVERSION="1.0"
WEBVERSION="1.0"

# Functions

function downloadSelf() {
    curl -s -o $SCRIPT_PATH $GITHUB_BASE_URL/scripts/sssh.sh
    chmod u+x $SCRIPT_PATH
}

function downloadRunFile() {
    if [ ! -d "$SCRIPTS_DIR" ]
    then
        mkdir $SCRIPTS_DIR
    fi
    curl -s -o $SCRIPTS_DIR/run.sh $GITHUB_BASE_URL/scripts/run.sh
    chmod u+x $SCRIPTS_DIR/run.sh
    rm -f $SCRIPTS_DIR/install.sh
}

function checkOutputDirExists() {
    if [ ! -d "$OUTPUT" ]
    then
        echo "Cannot find a SSSH installation at $OUTPUT."
        exit 1
    fi
}

function checkOutputDirNotExists() {
    if [ -d "$OUTPUT/docker" ]
    then
        echo "Looks like Bitwarden is already installed at $OUTPUT."
        exit 1
    fi
}

function listCommands() {
cat << EOT
Available commands:

install
start
restart
stop
update
updatedb
updateself
updateconf
rebuild
help

See more at TBD

EOT
}

# Commands

if [ "$1" == "install" ]
then
    checkOutputDirNotExists
    mkdir -p $OUTPUT
    #downloadRunFile
    $SCRIPTS_DIR/run.sh install $OUTPUT $COREVERSION $WEBVERSION
elif [ "$1" == "start" -o "$1" == "restart" ]
then
    checkOutputDirExists
    $SCRIPTS_DIR/run.sh restart $OUTPUT $COREVERSION $WEBVERSION
elif [ "$1" == "update" ]
then
    checkOutputDirExists
    downloadRunFile
    $SCRIPTS_DIR/run.sh update $OUTPUT $COREVERSION $WEBVERSION
elif [ "$1" == "rebuild" ]
then
    checkOutputDirExists
    $SCRIPTS_DIR/run.sh rebuild $OUTPUT $COREVERSION $WEBVERSION
elif [ "$1" == "updateconf" ]
then
    checkOutputDirExists
    $SCRIPTS_DIR/run.sh updateconf $OUTPUT $COREVERSION $WEBVERSION
elif [ "$1" == "updatedb" ]
then
    checkOutputDirExists
    $SCRIPTS_DIR/run.sh updatedb $OUTPUT $COREVERSION $WEBVERSION
elif [ "$1" == "stop" ]
then
    checkOutputDirExists
    $SCRIPTS_DIR/run.sh stop $OUTPUT $COREVERSION $WEBVERSION
elif [ "$1" == "updateself" ]
then
    downloadSelf && echo "Updated self." && exit
elif [ "$1" == "help" ]
then
    listCommands
else
    echo "No command found."
    echo
    listCommands
fi