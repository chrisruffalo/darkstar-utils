# easiest to build on ubuntu
from darkstar/base

# set command
CMD /darkstar/start.sh

# export volumes for git and input
VOLUME /darkstar/conf

# expose ports
EXPOSE 54002
EXPOSE 54003

# copy build script and make executable
COPY start.sh /darkstar/start.sh
RUN chmod +x /darkstar/start.sh

# copy search executable
COPY dssearch /darkstar/dssearch
RUN chmod +x /darkstar/dssearch
 


