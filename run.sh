#!/bin/bash

# do more with this
CONF_DIR="${1}"

# start the game server
docker run -d -v "${CONF_DIR}:/darkstar/conf" -p 0.0.0.0:54230:54230/udp --name dsgame --net host darkstar/dsgame

# start the search/chat server
docker run -d -v "${CONF_DIR}:/darkstar/conf" -p 0.0.0.0:54002:54002/tcp --name dssearch --net host darkstar/dssearch

# start the lobby/login/connect server
docker run -d -v "${CONF_DIR}:/darkstar/conf" -p 0.0.0.0:54001:54001/tcp -p 0.0.0.0:54003:54003/tcp -p 0.0.0.0:54230:54230/tcp -p 0.0.0.0:54231:54231/tcp --name dsconnect --net host darkstar/dsconnect
