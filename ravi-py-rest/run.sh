#!/bin/bash

SCRIPT_FOLDER="$( cd "$( dirname "$0" )"; pwd -P )" 
DOCKER_VM=`basename $SCRIPT_FOLDER`
PORTS_FILE="ports.txt"

# Search for local built docker container. This will be given priority to run.
DOCKER_IMAGE=`docker image ls | grep $DOCKER_VM | grep latest | grep -v "/$DOCKER_VM" | awk -F' ' '{print $1}'`
if [ -z $DOCKER_IMAGE ]
then
   # If local docker container not found search for pulled docker container.
   DOCKER_IMAGE=`docker image ls | grep "/$DOCKER_VM" | grep latest | awk -F' ' '{print $1}'`
fi

PORTS_COMMAND=""
if [ -f "${PORTS_FILE}" ]
then
	PORTS_COMMAND=`cat ports.txt | awk 'START {arg=""} {arg=arg" -p "$0;} END {print arg} '`
fi

if [ ! -z "$DOCKER_IMAGE" ]
then
   SCRIPT="docker run $PORTS_COMMAND -it $DOCKER_IMAGE"

   echo $SCRIPT
   $SCRIPT
else
   echo "Could not find any built docker image matching ${DOCKER_VM}"
fi

