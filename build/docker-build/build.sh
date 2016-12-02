#!/bin/bash

DARKSTAR_GIT='/darkstar/git'
DARKSTAR_OUT='/darkstar/out'
DARKSTAR_STAGE='/darkstar/stage'

# make sure that MAKE_JOBS is sane and has a value
if [ -z "${MAKE_JOBS// }" ]; then
	MAKE_JOBS=4
fi

# check that /darkstar/git exists and has the .git directory
if [ ! -d "$DARKSTAR_GIT" ]; then
	mkdir -p "$DARKSTAR_GIT"
fi

if [ ! -d "$DARKSTAR_GIT/.git" ]; then
	if [ -d "$DARKSTAR_GIT" ]; then
		rm -rf "$DARKSTAR_GIT"
	fi
	git clone http://github.com/DarkstarProject/darkstar.git/ "$DARKSTAR_GIT"
	cd "$DARKSTAR_GIT"
	git checkout origin/stable
fi

# make sure staging directory exists
if [ ! -d "$DARKSTAR_STAGE" ]; then
	mkdir -p "$DARKSTAR_STAGE"
fi

# copy git into stage directory, excluding the git directory
rsync -a "$DARKSTAR_GIT/" "$DARKSTAR_STAGE/"

# move into directory
cd "$DARKSTAR_STAGE"

# execute autogen
chmod +x "$DARKSTAR_STAGE"/autogen.sh
"$DARKSTAR_STAGE"/autogen.sh

# configure
"$DARKSTAR_STAGE"/configure

# make with 4 jobs
make -j"$MAKE_JOBS"

# make sure output directory exists
if [ ! -d "$DARKSTAR_OUT" ]; then
	mkdir -p "$DARKSTAR_OUT"
fi

# copy output to target
cp "$DARKSTAR_STAGE/dsconnect" "$DARKSTAR_OUT/"
cp "$DARKSTAR_STAGE/dsgame" "$DARKSTAR_OUT/"
cp "$DARKSTAR_STAGE/dssearch" "$DARKSTAR_OUT/"

