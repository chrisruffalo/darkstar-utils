#!/bin/bash

DARKSTAR_GIT='/darkstar'
DARKSTAR_OUT="${DARKSTAR_GIT}/out"

# make sure that MAKE_JOBS is sane and has a value
if [ -z "${MAKE_JOBS// }" ]; then
	MAKE_JOBS=4
fi

# from git dir
cd ${DARKSTAR_GIT}

# execute autogen
chmod +x "$DARKSTAR_GIT"/autogen.sh
"$DARKSTAR_GIT"/autogen.sh

# configure
"$DARKSTAR_GIT"/configure

# make with 4 jobs
make -j"$MAKE_JOBS"

# make sure output directory exists
if [ ! -d "$DARKSTAR_OUT" ]; then
	mkdir -p "$DARKSTAR_OUT"
fi

# copy output to target
cp "$DARKSTAR_GIT/dsconnect" "$DARKSTAR_OUT/"
cp "$DARKSTAR_GIT/dsgame" "$DARKSTAR_OUT/"
cp "$DARKSTAR_GIT/dssearch" "$DARKSTAR_OUT/"

