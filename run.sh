#!/bin/bash
#
# ----- run the xvnc container, with a user "me" whose UID and GID are
# ----- changed to match the current user. Override the default geometry
# ----- of the container to start it at 1024x768
# ----- open ports for both VNC and RDP connections
#
#docker run -it --rm -e NEWUID=$(id -u) -e NEWGID=$(id -g)	\
docker run -it --rm -e NEWUID=1000 -e NEWGID=50	\
       -e GEOMETRY=1024x768	\
       -v $HOME:/host_home	\
       -p 5901:5901 -p 3389:3389	\
       $(basename $PWD) $*
