# easiest to build on ubuntu
from darkstar/base

# set command
CMD /darkstar/start.sh

# export volumes for git and input
VOLUME /darkstar/conf

# expose ports
EXPOSE 54230
EXPOSE 54001
EXPOSE 54231

# copy build script and make executable
COPY start.sh /darkstar/start.sh
RUN chmod +x /darkstar/start.sh

# copy executable
COPY dsconnect /darkstar/dsconnect
RUN chmod +x /darkstar/dsconnect
 


