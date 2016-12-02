# easiest to build on ubuntu
from ubuntu:16.10

# make directories
RUN mkdir -p /darkstar

# update system and install build prerequisites
RUN apt-get update -y && \
    apt-get install -y git libmysqlclient-dev libluajit-5.1-dev libzmq3-dev && \
    apt-get clean -y

 


