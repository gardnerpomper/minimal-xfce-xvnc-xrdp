#!/bin/bash
#
# ------ start the VNC server
# ------ this will prompt for a password
#
vncserver $DISPLAY -depth $DEPTH -geometry $GEOMETRY -localhost
#
# ----- start xrdp
#
sleep 1
sudo sed -i 's/SBINDIR=\/usr\/local\/sbin/SBINDIR=\/usr\/sbin/' /etc/xrdp/xrdp.sh
sudo /etc/xrdp/xrdp.sh start
#
# ----- start in $HOME, after running .bash_profile
# ----- to simulate an initial login
#
cd $HOME
source $HOME/.bash_profile
#
# ----- keep the container from exiting by running
# ----- a never ending process in the foreground
#
tail -f ~/.vnc/*.log > /dev/null
