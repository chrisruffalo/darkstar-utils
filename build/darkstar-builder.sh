#!/bin/bash

# local variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# determine if SElinux is enabled and set MOUNT_SUFFIX
which sestatus &>/dev/null
[[ $? == 0 ]] && MOUNT_SUFFIX=":z" || MOUNT_SUFFIX=""
#printf "Mount suffix: $MOUNT_SUFFIX\n"

# values
OPTION="$1"
TAG_ROOT='darkstar'
TAG_BASE="${TAG_ROOT}/base"
TAG_BUILDER="${TAG_ROOT}/builder"
TAG_GAME="${TAG_ROOT}/dsgame"
TAG_CONNECT="${TAG_ROOT}/dsconnect"
TAG_SEARCH="${TAG_ROOT}/dssearch"

# function for help
function help {
	printf "Usage: 'darkstar-builder.sh [COMMAND] [OPTIONS]'\n\n"
	printf "Available commands:\n"
	printf "\tbuild [GIT] - builds the darkstar project\n"
	printf "\t\tGIT - optional, the directory where the darkstar project has been checked out\n"
	printf "\n"
}

function container {
	printf "Building darkstar ${1} container... "
	docker build --rm -t "$2" "${DIR}/${1}" &>/dev/null
	if [ $? == 0 ]; then
		printf "[SUCCESS]\n"
	else
		printf "[ERROR] (Status: $?)\n"
		exit
	fi
}

# function for pre-build containers
function precontainers {
	container docker-base $TAG_BASE
	container docker-build $TAG_BUILDER
}

# functions for post-build artifact hosting containres
function containers {
	container docker-connect $TAG_CONNECT
	container docker-game $TAG_GAME
	container docker-search $TAG_SEARCH
}

# function for build
# param $1 should be additional options
function build {
	printf "Building darkstar... "
	WD=`pwd`
	docker run --rm -ti $1 -v ${WD}:/darkstar/out${MOUNT_SUFFIX} ${TAG_BUILDER} > /dev/null 2>&1
	if [ $? == 0 ]; then
		printf "[SUCCESS]\n"
	else
		printf "[ERROR] (Status: $?)\n"
		exit
	fi
}


# do help command
if [ -z "$OPTION" ] || [ "$OPTION" == "help" ]; then
	help
	exit
fi

# do build command
if [ "build" == "$OPTION" ]; then
	# get git dir from params
	GIT_DIR=$2

	# use 
	if [ -z "$GIT_DIR" ]; then
		printf "No value provided for the Git directory where the darkstar project is cloned. Using origin/stable from GitHub.\n"
		GIT_DIR=""
	elif [ ! -d "$GIT_DIR" ]; then
		printf "No directory '$GIT_DIR' found. This should be the location where the darkstar project is cloned from Git.\n"
		exit 1
	fi

	# build base and build containers
	precontainers

	# clean up old artifacts
	if [ -e "$DIR/docker-game/dsgame" ]; then
		rm -f "$DIR/docker-game/dsgame"
	fi
	if [ -e "$DIR/docker-connect/dsconnect" ]; then
		rm -f "$DIR/docker-connect/dsconnect"
	fi
	if [ -e "$DIR/docker-search/dssearch" ]; then
		rm -f "$DIR/docker-search/dssearch"
	fi

	# if a GIT_DIR is provided, build with it
	if [ ! -z "$GIT_DIR" ]; then
		build "-v $GIT_DIR:/darkstar/git$MOUNT_SUFFIX"
	else
		build
	fi

	# move artifacts
	mv dssearch "$DIR/docker-search/"
	mv dsgame "$DIR/docker-game/"
	mv dsconnect "$DIR/docker-connect/"

	# build containers
	containers

	exit
fi

# nothing has been done, print help
help
