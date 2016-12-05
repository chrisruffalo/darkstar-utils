# easiest to build on ubuntu
from ubuntu:17.04

# make directories
RUN mkdir -p /darkstar && \
    mkdir -p /darkstar/log && \
    mkdir -p /darkstar/conf

# update system and install build prerequisites
RUN apt-get update -y && \
    apt-get install -y git libmysqlclient-dev libluajit-5.1-dev libzmq3-dev && \
    apt-get clean -y

# copy darkstar into /darkstar
COPY darkstar /darkstar 


