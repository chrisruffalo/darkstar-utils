# easiest to build on ubuntu
from darkstar/base

# set command
CMD /darkstar/start.sh

# export volumes for git and input
VOLUME /darkstar/conf

# copy build script and make executable
COPY start.sh /darkstar/start.sh
RUN chmod +x /darkstar/start.sh

# copy search executable
COPY dssearch /darkstar/dssearch
RUN chmod +x /darkstar/dssearch
 


