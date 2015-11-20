## Overview

This repository is meant to provide the basis for building useful GUI
desktops inside a docker container that can be accessed via VNC or
RDP. The container it builds is only minimally useful, in that all that is
installed is a desktop with a terminal client, but it can be used as
the base image from which to build more complete and personalize
work environments.

## Justification

Most of the examples I have found of docker GUIs have used the trick
of sharing the /tmp/.X11 socket with the host computer to allow access
via the X11 protocol. When the docker container is not run on the
local machine, it is often easier and/or faster to access it via VNC
than X11.

I have found a very few examples of VNC access, but those run the VNC
server as the root user. I wanted to run as a non-privileged user for
a couple reasons. First, it just seems like a safer practice. More
importantly, however, my intended use for a desktop container is a
portable development environment. As such, I wanted the ability to
connect to the host machine with the same user credentials exisiting
on the host machine, so that host volumes can be mapped into the
container without permission problems.

This container can be used as the basis for installing editors, IDEs
and other devlopment tools, and it will be able to read and write from
the host directories with the correct file ownership.

## Building the image

Clone this repo and execute the following command:

```
docker build -t $(basename $PWD) .
```

## Running the image

The image must be run interactively (docker run -it) because the
vncserver will prompt for a vnc password when it starts. The vnc
server will start up by default at a screen resolution of 1280x1024 in
24 bit color. These parameters can be overriden with environment
variables (RESOLUTION and DEPTH) in the run command. The desired UID
and GID of the containers user account ("me") are also specified with
environment variables (NEWUID, NEWGID).

A sample run command is shown, from my Macbook Pro, where I must use
docker-machine. This means that my UID on OS/X is not the same as the
output of "id -u" on the docker virtual machine, so I must specify the
UID and GID manually:

```
docker run -it --rm -e NEWUID=1000 -e NEWGID=50	\
       -e GEOMETRY=1024x768	\
       -v $HOME:/host_home	\
       -p 5901:5901 -p 3389:3389	\
       $(basename $PWD) $*
```
       
## Issues

While I have gotten xrdp installed and spawned when the container
starts, so far I have been unable to connect with an RDP client. The
login screen appears, indicating that the service is running, but when
the username ("me") and vnc password is entered, the login fails.

If anyone can assist in identifying the configuration issue, I will
happily fix the container.

