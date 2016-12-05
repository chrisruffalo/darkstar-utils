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
	#docker build --rm -t "$2" "${DIR}/${1}"
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
	printf "Building darkstar binaries... "
	WD=`pwd`
	docker run --rm -ti $1 -v ${WD}:/darkstar/out${MOUNT_SUFFIX} ${TAG_BUILDER} &>/dev/null
	#docker run --rm -ti $1 -v ${WD}:/darkstar/out${MOUNT_SUFFIX} ${TAG_BUILDER}
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

	# remove old darkstar/git dir from base if it exists
	if [ -d "${DIR}/docker-base/darkstar" ]; then
		rm -rf "${DIR}/docker-base/darkstar"
	fi

	# decide what to do with existing git or what to do if it doesn't exist
	if [ -z "$GIT_DIR" ]; then
		printf "No value provided for the Git directory where the darkstar project is cloned. Using origin/master from GitHub.\n"
		GIT_DIR=""
		# checkout git into docker-base directory
		git clone http://github.com/DarkstarProject/darkstar.git/ "${DIR}/docker-base/darkstar"
	elif [ ! -d "$GIT_DIR" ]; then
		printf "No directory '$GIT_DIR' found. This should be the location where the darkstar project is cloned from Git.\n"
		exit 1
	else
		# log
		printf "Using '${GIT_DIR}' as source base, copying to Docker image working directory.\n"
		# copy git into darkstar base directory
		cp -r $GIT_DIR "${DIR}/docker-base/darkstar"
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

	# cleanup
	rm -f $DIR/docker-game/dsgame
	rm -f $DIR/docker-connect/dsconnect
	rm -f $DIR/docker-search/dssearch
	rm -rf "${DIR}/docker-base/darkstar"

	exit
fi

# nothing has been done, print help
help
