# easiest to build on ubuntu
from darkstar/base

# set command
CMD /darkstar/start.sh

# export volumes for git and input
VOLUME /darkstar/conf

# expose port (udp)
EXPOSE 54230

# copy build script and make executable
COPY start.sh /darkstar/start.sh
RUN chmod +x /darkstar/start.sh

# copy game executable
COPY dsgame /darkstar/dsgame
RUN chmod +x /darkstar/dsgame

 


