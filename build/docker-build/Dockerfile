# easiest to build on ubuntu
from darkstar/base:latest

# set command
CMD /darkstar/build.sh

# export volumes for git and input
VOLUME /darkstar/git
VOLUME /darkstar/out

# make directories
RUN mkdir -p /darkstar

# update system and install build prerequisites
RUN apt-get update -y && \
    apt-get install -y autoconf pkg-config build-essential && \
    apt-get clean -y

# set environment variables
ENV MAKE_JOBS 4

# copy build script and make executable
COPY build.sh /darkstar/build.sh
RUN chmod +x /darkstar/build.sh


 


